import Foundation
import Models

public protocol FileClientProtocol {
    func createSummary(from url: URL) throws -> Summary
}
