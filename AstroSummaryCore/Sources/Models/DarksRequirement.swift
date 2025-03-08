import Foundation

public struct DarksRequirement: Equatable, Hashable, Identifiable {
    public let binning: String
    public let exposureDurationSeconds: Measurement<UnitDuration>
    public let gain: Int
    public let targetCameraTemperature: Measurement<UnitTemperature>

    public var id: String {
        formattedBinning
        + formattedExposureDurationSeconds
        + formattedGain
        + formattedTargetCameraTemperature
    }

    public var formattedBinning: String {
        binning
    }

    public var formattedExposureDurationSeconds: String {
        exposureDurationSeconds.formatted(.measurement(
            width: .abbreviated,
            usage: .asProvided,
            numberFormatStyle: .number.precision(.fractionLength(0...1)))
        )
    }

    public var formattedGain: String {
        gain.formatted()
    }

    public var formattedTargetCameraTemperature: String {
        targetCameraTemperature.formatted(.measurement(
            width: .abbreviated,
            usage: .asProvided,
            numberFormatStyle: .number.precision(.fractionLength(0...1)))
        )
    }

    public init(
        binning: String,
        exposureDurationSeconds: Measurement<UnitDuration>,
        gain: Int,
        targetCameraTemperature: Measurement<UnitTemperature>
    ) {
        self.binning = binning
        self.exposureDurationSeconds = exposureDurationSeconds
        self.gain = gain
        self.targetCameraTemperature = targetCameraTemperature
    }
}
