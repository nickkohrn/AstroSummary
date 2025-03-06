import Foundation
import FoundationExtensions

public struct ImageMetaData {
    public let binning: String
    public let cameraTargetTemp: Double
    public let duration: Double
    public let exposureStartUTC: String
    public let filterName: String
    public let fwhm: Double
    public let gain: Int
    public let offset: Int

    public var exposureStartDate: Date? {
        return ISO8601DateFormatter.default.date(from: exposureStartUTC)
    }

    public init(
        binning: String,
        cameraTargetTemp: Double,
        duration: Double,
        exposureStartUTC: String,
        filterName: String,
        fwhm: Double,
        gain: Int,
        offset: Int
    ) {
        self.binning = binning
        self.cameraTargetTemp = cameraTargetTemp
        self.duration = duration
        self.exposureStartUTC = exposureStartUTC
        self.filterName = filterName
        self.fwhm = fwhm
        self.gain = gain
        self.offset = offset
    }
}

extension ImageMetaData: Codable {
    private enum CodingKeys: String, CodingKey {
        case binning = "Binning"
        case cameraTargetTemp = "CameraTargetTemp"
        case duration = "Duration"
        case exposureStartUTC = "ExposureStartUTC"
        case filterName = "FilterName"
        case fwhm = "FWHM"
        case gain = "Gain"
        case offset = "Offset"
    }
}

extension ImageMetaData: Equatable {}
