import Foundation

public struct AcquisitionDetails {
    public let targetName: String

    public init(targetName: String) {
        self.targetName = targetName
    }
}

extension AcquisitionDetails: Equatable {}

extension AcquisitionDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case targetName = "TargetName"
    }
}
