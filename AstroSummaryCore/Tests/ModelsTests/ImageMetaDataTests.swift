import Foundation
import FoundationExtensions
import Models
import Testing

struct ImageMetaDataTests {
    @Test
    func decodeImageMetaData() throws {
        let jsonString = """
        {
            "Binning": "2x2",
            "CameraTargetTemp": -10.5,
            "Duration": 300.0,
            "ExposureStartUTC": "2025-03-06T01:42:40.9050406Z",
            "FilterName": "L",
            "FWHM": 2.1,
            "Gain": 200,
            "Offset": 50
        }
        """

        let jsonData = try #require(jsonString.data(using: .utf8))

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ImageMetaData.self, from: jsonData)

        let expected = ImageMetaData(
            binning: "2x2",
            cameraTargetTemp: -10.5,
            duration: 300.0,
            exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
            filterName: "L",
            fwhm: 2.1,
            gain: 200,
            offset: 50
        )

        #expect(decoded == expected)
    }

    @Test
    func exposureStartDateComputation() {
        let imageMetaData = ImageMetaData(
            binning: "2x2",
            cameraTargetTemp: -10.5,
            duration: 300.0,
            exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
            filterName: "L",
            fwhm: 2.1,
            gain: 200,
            offset: 50
        )

        let expectedDate = ISO8601DateFormatter.default.date(from: "2025-03-06T01:42:40.9050406Z")
        #expect(imageMetaData.exposureStartDate == expectedDate)
    }
}
