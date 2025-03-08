import Foundation

extension DateComponentsFormatter {
    public static var `default`: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        return formatter
    }
}
