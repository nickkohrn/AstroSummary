import Foundation
import FoundationExtensions

public struct WeatherData {
    public let exposureStartUTC: String
    public let temperature: Double

    public var exposureStartDate: Date? {
        ISO8601DateFormatter.default.date(from: exposureStartUTC)
    }

    public init(exposureStartUTC: String, temperature: Double) {
        self.exposureStartUTC = exposureStartUTC
        self.temperature = temperature
    }
}

extension WeatherData: Codable {
    private enum CodingKeys: String, CodingKey {
        case exposureStartUTC = "ExposureStartUTC"
        case temperature = "Temperature"
    }
}

extension WeatherData: Equatable {}
