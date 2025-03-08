import Foundation
import FoundationExtensions

public struct Summary {
    private let calendar: Calendar
    public let sessions: [Session]

    public var darks: [DarksRequirement] {
        var uniqueDarks = Set<DarksRequirement>()

        for session in sessions {
            if let binning = session.binning,
               let exposureDuration = session.exposureDurationSeconds,
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

    public init(sessions: [Session], calendar: Calendar = .current) {
        self.calendar = calendar
        self.sessions = sessions
    }

    public var dateInterval: DateInterval? {
        let honestDates = sessions.compactMap(\.date)
        guard !honestDates.isEmpty,
              let min = honestDates.min(by: <),
              let max = honestDates.max(by: <)
        else { return nil }
        return DateInterval(start: min, end: max)
    }

    public var dateRange: Range<Date>? {
        let honestDates = sessions.compactMap(\.date)
        guard !honestDates.isEmpty else { return nil }
        // Add one more day to the max because the end date should be included in the range.
        guard let min = honestDates.min(),
              let max = honestDates.max(),
              let dayAfterMax = calendar.date(byAdding: .day, value: 1, to: max)
        else { return nil }
        return min..<dayAfterMax
    }

    public var totalDuration: Measurement<UnitDuration>? {
        let honestDurations = sessions.compactMap(\.totalExposureDurationSeconds)
        guard !honestDurations.isEmpty else { return nil }
        let sum = honestDurations.reduce(0.0) { partial, duration in
            partial + duration.value
        }
        return Measurement(value: sum, unit: .seconds)
    }

    public var uniqueDateCount: Int? {
        let honestDates = sessions.compactMap(\.date)
        guard !honestDates.isEmpty else { return nil }
        let dateComponents = honestDates.map {
            calendar.dateComponents([.year, .month, .day], from: $0)
        }
        let uniqued = Set(dateComponents)
        return uniqued.count
    }

    public var uniqueFilters: [String]? {
        guard !sessions.isEmpty else { return nil }
        let allFilters = sessions.compactMap(\.filter)
        let uniqued = Set(allFilters)
        return Array(uniqued).sorted {
            $0.localizedStandardCompare($1) == .orderedAscending
        }
    }

    public var formattedDateInterval: String {
        guard let dateInterval else { return "--" }
        return DateIntervalFormatter.default.string(from: dateInterval) ?? "--"
    }

    public var formattedDateRange: String {
        guard let dateRange else { return "--" }
        return dateRange.formatted(.components(style: .abbreviated, fields: [.day]))
    }

    public var formattedTotalDuration: String {
        guard let totalDuration else { return "--" }
        let dateComponents = DateComponents(second: Int(totalDuration.value))
        let formatted = DateComponentsFormatter.default.string(from: dateComponents)
        return formatted ?? "--"
    }

    public var formattedUniqueDateCount: String {
        guard let uniqueDateCount else { return "--" }
        return uniqueDateCount.formatted()
    }

    public var formattedUniqueFilters: String {
        guard let uniqueFilters else { return "--" }
        return uniqueFilters.formatted(.list(type: .and, width: .short))
    }

    public var formattedTargetName: String? {
        sessions.first?.acquisitionDetails.targetName
    }
}

extension Summary: Equatable {}
