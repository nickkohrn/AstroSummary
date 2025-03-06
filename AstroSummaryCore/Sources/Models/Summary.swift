import Foundation

public struct Summary {
    public let sessions: [Session]

    public var darks: [DarksRequirement] {
        var uniqueDarks = Set<DarksRequirement>()

        for session in sessions {
            if let binning = session.binning,
               let exposureDuration = session.totalExposureDurationSeconds,
               let gain = session.gain,
               let targetCameraTemperature = session.targetCameraTemperature {
                let requirement = DarksRequirement(
                    binning: binning,
                    exposureDurationSeconds: exposureDuration,
                    gain: gain,
                    targetCameraTemperature: targetCameraTemperature
                )
                uniqueDarks.insert(requirement)
            }
        }

        return Array(uniqueDarks)
    }

    public init(sessions: [Session]) {
        self.sessions = sessions
    }
}

extension Summary: Equatable {}
