import Foundation

public enum FileClientError: Error {
    case directoryNotFound
    case missingRequiredFiles(URL)
    case decodingError(URL)
}

extension FileClientError: Equatable {}

