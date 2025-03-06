import Foundation

public struct Session {
    private let calendar: Calendar
    public let acquisitionDetails: AcquisitionDetails
    public let imageMetaData: [ImageMetaData]
    public let weatherData: [WeatherData]

    public init(
        calendar: Calendar = .current,
        acquisitionDetails: AcquisitionDetails,
        imageMetaData: [ImageMetaData],
        weatherData: [WeatherData]
    ) {
        self.calendar = calendar
        self.acquisitionDetails = acquisitionDetails
        self.imageMetaData = imageMetaData
        self.weatherData = weatherData
    }

    /// Computes the average ambient temperature in Celsius.
    /// Returns `nil` if unavailable or invalid.
    public var averageAmbientTemperature: Measurement<UnitTemperature>? {
        guard !weatherData.isEmpty else { return nil }

        let sum = weatherData.reduce(0.0) { $0 + $1.temperature }
        let average = sum / Double(weatherData.count)

        return average.isFinite ? Measurement(value: average, unit: .celsius) : nil
    }

    /// Returns the binning mode used, or `nil` if unavailable.
    public var binning: String? {
        guard let binning = imageMetaData.first?.binning else { return nil }
        guard (imageMetaData.allSatisfy { $0.binning == binning }) else { return nil }
        return binning
    }

    /// Represents the adjusted date (start of session day).
    public var date: Date? {
        guard let firstDate = imageMetaData.first?.exposureStartDate,
              let adjustedDate = calendar.date(byAdding: .hour, value: -12, to: firstDate)
        else { return nil }

        return calendar.startOfDay(for: adjustedDate)
    }

    /// Returns the exposure duration in seconds, or `nil` if unavailable.
    public var exposureDurationSeconds: Measurement<UnitDuration>? {
        guard let duration = imageMetaData.first?.duration, duration.isFinite else { return nil }
        return Measurement(value: duration, unit: .seconds)
    }

    /// Returns the number of exposures captured, or `nil` if none exist.
    public var exposures: Int? {
        imageMetaData.isEmpty ? nil : imageMetaData.count
    }

    /// Returns the filter used, or `nil` if unavailable.
    public var filter: String? {
        guard let filter = imageMetaData.first?.filterName else { return nil }
        guard (imageMetaData.allSatisfy { $0.filterName == filter }) else { return nil }
        return filter
    }

    /// Returns the gain used, or `nil` if unavailable.
    public var gain: Int? {
        guard let gain = imageMetaData.first?.gain else { return nil }
        guard (imageMetaData.allSatisfy { $0.gain == gain }) else { return nil }
        return gain
    }

    /// Computes the mean FWHM, or `nil` if unavailable.
    public var meanFWHM: Double? {
        let fwhmValues = imageMetaData.compactMap { $0.fwhm }.filter { $0.isFinite }
        guard !fwhmValues.isEmpty else { return nil }
        return fwhmValues.reduce(0, +) / Double(fwhmValues.count)
    }

    /// Returns the target camera temperature in Celsius, if available.
    public var targetCameraTemperature: Measurement<UnitTemperature>? {
        guard let temp = imageMetaData.first?.cameraTargetTemp else { return nil }
        guard (imageMetaData.allSatisfy { $0.cameraTargetTemp == temp }) else { return nil }
        return Measurement(value: temp, unit: .celsius)
    }

    /// Total exposure duration across all images.
    public var totalExposureDurationSeconds: Measurement<UnitDuration>? {
        guard !imageMetaData.isEmpty else { return nil }
        
        let sum = imageMetaData.reduce(0.0) { $0 + $1.duration }
        return sum.isFinite ? Measurement(value: sum, unit: .seconds) : nil
    }
}

extension Session: Equatable {}
