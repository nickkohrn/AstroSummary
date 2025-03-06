import Foundation
import FoundationExtensions
import Models
import Testing

struct WeatherDataTests {
    @Test
    func decodeWeatherData() {
        let weatherData = WeatherData(exposureStartUTC: "2021-01-01T00:00:00Z", temperature: 25.0)
        #expect(weatherData.temperature == 25.0)
    }

    @Test
    func exposureStartDateComputation() {
        let weatherData = WeatherData(exposureStartUTC: "2025-03-06T01:42:40.9050406Z", temperature: 13.2)
        let expectedDate = ISO8601DateFormatter.default.date(from: "2025-03-06T01:42:40.9050406Z")
        #expect(weatherData.exposureStartDate == expectedDate)
    }
}
