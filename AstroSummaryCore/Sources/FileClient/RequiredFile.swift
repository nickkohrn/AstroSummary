import Foundation

public struct RequiredFile {
    public let name: String
}

extension RequiredFile {
    public static let acquisitionDetails = RequiredFile(name: "AcquisitionDetails.json")
    public static let imageMetaData = RequiredFile(name: "ImageMetaData.json")
    public static let weatherData = RequiredFile(name: "WeatherData.json")
}

extension RequiredFile: Hashable {}

extension RequiredFile: Sendable {}
