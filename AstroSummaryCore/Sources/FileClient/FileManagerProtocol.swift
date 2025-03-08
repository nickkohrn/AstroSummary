import Foundation

public protocol FileManagerProtocol {
    func contentsOfDirectory(atPath path: String) throws -> [String]

    func enumerator(
        at url: URL,
        includingPropertiesForKeys keys: [URLResourceKey]?,
        options mask: FileManager.DirectoryEnumerationOptions,
        errorHandler handler: ((URL, any Error) -> Bool)?
    ) -> FileManager.DirectoryEnumerator?

    func fileExists(atPath: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
}

extension FileManager: FileManagerProtocol {}
