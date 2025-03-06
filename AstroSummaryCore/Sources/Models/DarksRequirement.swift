import Foundation

public struct DarksRequirement {
    public let binning: String
    public let exposureDurationSeconds: Measurement<UnitDuration>
    public let gain: Int
    public let targetCameraTemperature: Measurement<UnitTemperature>

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

extension DarksRequirement: Hashable {}
