import Foundation
import Models
import Testing

struct AcquisitionDetailsTests {
    @Test
    func decodeAcquisitionDetails() throws {
        let jsonString = #"""
        {
            "TargetName": "M 81",
            "RACoordinates": "9h 48m 1s",
            "DECCoordinates": "69° 34' 57\"",
            "TelescopeName": "William Optics Gran Turismo 81 IV",
            "FocalLength": 382.0,
            "FocalRatio": 4.7,
            "CameraName": "ZWO ASI2600MM Pro",
            "PixelSize": 3.76,
            "BitDepth": 16,
            "ObserverLatitude": 31.548,
            "ObserverLongitude": -99.382,
            "ObserverElevation": 472.4
        }
        """#

        let jsonData = try #require(jsonString.data(using: .utf8))

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(AcquisitionDetails.self, from: jsonData)

        let expected = AcquisitionDetails(targetName: "M 81")

        #expect(decoded == expected)
    }
}
