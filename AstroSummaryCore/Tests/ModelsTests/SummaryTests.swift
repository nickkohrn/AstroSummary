import Foundation
import FoundationExtensions
import Models
import Testing

struct SummaryTests {
    @Test
    func darksComputation() {
        let sessions = [
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "2x2",
                        cameraTargetTemp: -10.0,
                        duration: 300.0,
                        exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 200,
                        offset: 50
                    )
                ],
                weatherData: []
            ),
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 82"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "2x2",
                        cameraTargetTemp: -10.0,
                        duration: 300.0,
                        exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 200,
                        offset: 50
                    )
                ],
                weatherData: []
            )
        ]

        let summary = Summary(sessions: sessions)

        let expectedDarks = [
            DarksRequirement(
                binning: "2x2",
                exposureDurationSeconds: Measurement(value: 300.0, unit: .seconds),
                gain: 200,
                targetCameraTemperature: Measurement(value: -10.0, unit: .celsius)
            )
        ]

        #expect(summary.darks == expectedDarks)
    }

    @Test
    func darksComputationWithDifferentValues() {
        let sessions = [
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "2x2",
                        cameraTargetTemp: -10.0,
                        duration: 300.0,
                        exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 200,
                        offset: 50
                    )
                ],
                weatherData: []
            ),
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 82"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "3x3",
                        cameraTargetTemp: -15.0,
                        duration: 400.0,
                        exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 250,
                        offset: 50
                    )
                ],
                weatherData: []
            )
        ]

        let summary = Summary(sessions: sessions)

        let expectedDarks = [
            DarksRequirement(
                binning: "2x2",
                exposureDurationSeconds: Measurement(value: 300.0, unit: .seconds),
                gain: 200,
                targetCameraTemperature: Measurement(value: -10.0, unit: .celsius)
            ),
            DarksRequirement(
                binning: "3x3",
                exposureDurationSeconds: Measurement(value: 400.0, unit: .seconds),
                gain: 250,
                targetCameraTemperature: Measurement(value: -15.0, unit: .celsius)
            )
        ]

        #expect(Set(summary.darks) == Set(expectedDarks))
    }

    @Test
    func darksComputationWithDuplicateSessions() {
        let sessions = [
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "2x2",
                        cameraTargetTemp: -10.0,
                        duration: 300.0,
                        exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 200,
                        offset: 50
                    )
                ],
                weatherData: []
            ),
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "2x2",
                        cameraTargetTemp: -10.0,
                        duration: 300.0,
                        exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 200,
                        offset: 50
                    )
                ],
                weatherData: []
            ),
            Session(
                acquisitionDetails: AcquisitionDetails(targetName: "M 82"),
                imageMetaData: [
                    ImageMetaData(
                        binning: "3x3",
                        cameraTargetTemp: -15.0,
                        duration: 400.0,
                        exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                        filterName: "L",
                        fwhm: 2.1,
                        gain: 250,
                        offset: 50
                    )
                ],
                weatherData: []
            )
        ]

        let summary = Summary(sessions: sessions)

        let expectedDarks = [
            DarksRequirement(
                binning: "2x2",
                exposureDurationSeconds: Measurement(value: 300.0, unit: .seconds),
                gain: 200,
                targetCameraTemperature: Measurement(value: -10.0, unit: .celsius)
            ),
            DarksRequirement(
                binning: "3x3",
                exposureDurationSeconds: Measurement(value: 400.0, unit: .seconds),
                gain: 250,
                targetCameraTemperature: Measurement(value: -15.0, unit: .celsius)
            )
        ]

        #expect(Set(summary.darks) == Set(expectedDarks))
    }

    @Test
    func darksComputationWithEmptySessions() {
        let summary = Summary(sessions: [])
        #expect(summary.darks.isEmpty)
    }
}
