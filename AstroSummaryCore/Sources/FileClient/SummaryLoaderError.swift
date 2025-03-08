import Foundation

public enum SummaryLoaderError: Error {
    case accessDenied(URL)
    case decodingError(URL)
    case missingRequiredFiles(URL, Set<RequiredFile>)
}

extension SummaryLoaderError: Equatable {}

