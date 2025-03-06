import Foundation
import FoundationExtensions
import Models
import Testing

struct SessionTests {
    @Test
    func averageAmbientTemperatureComputation() {
        let weatherData = [
            WeatherData(exposureStartUTC: "2025-03-06T01:42:40.9050406Z", temperature: 10.0),
            WeatherData(exposureStartUTC: "2025-03-06T02:42:40.9050406Z", temperature: 15.0),
            WeatherData(exposureStartUTC: "2025-03-06T03:42:40.9050406Z", temperature: 20.0)
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: weatherData
        )

        let expectedTemperature = Measurement<UnitTemperature>(value: 15.0, unit: .celsius)
        #expect(session.averageAmbientTemperature == expectedTemperature)
    }

    @Test
    func averageAmbientTemperatureHandlesNonFiniteValues() {
        let weatherData = [
            WeatherData(exposureStartUTC: "2025-03-06T01:42:40.9050406Z", temperature: 5.0),
            WeatherData(exposureStartUTC: "2025-03-06T02:42:40.9050406Z", temperature: 15.0),
            WeatherData(exposureStartUTC: "2025-03-06T03:42:40.9050406Z", temperature: .infinity)
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: weatherData
        )

        #expect(session.averageAmbientTemperature == nil)
    }

    @Test
    func binningComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.binning == "2x2")
    }

    @Test
    func binningComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.binning == nil)
    }

    @Test
    func binningComputationDifferentValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "3x3",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.binning == nil)
    }

    @Test
    func dateComputation() throws {
        let imageMetaData = [
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        let date = try #require(ISO8601DateFormatter.default.date(from: "2025-03-06T02:42:40.9050406Z"))
        let expectedDate = Calendar.current.startOfDay(for: date)
        #expect(session.date == expectedDate)
    }

    @Test
    func dateComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.date == nil)
    }

    @Test
    func exposureDurationSecondsComputation() {
        let imageMetaData = [
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        let expectedDuration = Measurement<UnitDuration>(value: 300.0, unit: .seconds)
        #expect(session.exposureDurationSeconds == expectedDuration)
    }

    @Test
    func exposureDurationSecondsEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.exposureDurationSeconds == nil)
    }

    @Test
    func exposureDurationSecondsNonFiniteValue() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: .infinity,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.exposureDurationSeconds == nil)
    }

    @Test
    func exposuresComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T03:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.exposures == 2)
    }

    @Test
    func exposuresComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.exposures == nil)
    }

    @Test
    func filterComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.filter == "L")
    }

    @Test
    func filterComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.filter == nil)
    }

    @Test
    func filterComputationDifferentValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "R",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.filter == nil)
    }

    @Test
    func gainComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.gain == 200)
    }

    @Test
    func gainComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.gain == nil)
    }

    @Test
    func gainComputationDifferentValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 250,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.gain == nil)
    }

    @Test
    func meanFWHMComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.0,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 3.0,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.meanFWHM == 2.5)
    }

    @Test
    func meanFWHMComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.meanFWHM == nil)
    }

    @Test
    func meanFWHMComputationNonFiniteValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: .nan,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.5,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.meanFWHM == 2.5)
    }

    @Test
    func targetCameraTemperatureComputation() {
        let imageMetaData = [
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        let expectedTemperature = Measurement<UnitTemperature>(value: -10.0, unit: .celsius)
        #expect(session.targetCameraTemperature == expectedTemperature)
    }

    @Test
    func targetCameraTemperatureComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.targetCameraTemperature == nil)
    }

    @Test
    func targetCameraTemperatureComputationDifferentValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -15.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.targetCameraTemperature == nil)
    }

    @Test
    func totalExposureDurationSecondsComputation() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 300.0,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: 200.0,
                exposureStartUTC: "2025-03-06T02:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            )
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        let expectedDuration = Measurement<UnitDuration>(value: 500.0, unit: .seconds)
        #expect(session.totalExposureDurationSeconds == expectedDuration)
    }

    @Test
    func totalExposureDurationSecondsComputationEmptyArray() {
        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: [],
            weatherData: []
        )

        #expect(session.totalExposureDurationSeconds == nil)
    }

    @Test
    func totalExposureDurationSecondsComputationNonFiniteValues() {
        let imageMetaData = [
            ImageMetaData(
                binning: "2x2",
                cameraTargetTemp: -10.0,
                duration: .nan,
                exposureStartUTC: "2025-03-06T01:42:40.9050406Z",
                filterName: "L",
                fwhm: 2.1,
                gain: 200,
                offset: 50
            ),
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
        ]

        let session = Session(
            acquisitionDetails: AcquisitionDetails(targetName: "M 81"),
            imageMetaData: imageMetaData,
            weatherData: []
        )

        #expect(session.totalExposureDurationSeconds == nil)
    }
}
