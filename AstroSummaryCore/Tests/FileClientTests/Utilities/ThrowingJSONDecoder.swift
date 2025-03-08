import Foundation

final class ThrowingJSONDecoder: JSONDecoder, @unchecked Sendable {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Test error"))
    }
}
