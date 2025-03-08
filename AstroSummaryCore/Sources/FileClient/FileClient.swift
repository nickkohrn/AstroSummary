import Foundation
import Models

public struct FileClient: FileClientProtocol {
    private let decoder: JSONDecoder
    private let fileManager: any FileManagerProtocol
    private static let requiredFiles: Set<RequiredFile> = [.acquisitionDetails, .imageMetaData, .weatherData]

    public init(
        fileManager: any FileManagerProtocol = FileManager.default,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileManager = fileManager
        self.decoder = decoder
    }

    public func createSummary(from url: URL) throws -> Summary {
        let isDirectory = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false
        guard isDirectory else { throw FileClientError.directoryNotFound }

        if checkForRequiredFiles(in: url) {
            return try createSummaryFromDirectory(url)
        }
        return try traverseDirectories(rootDirectory: url)
    }

    private func traverseDirectories(rootDirectory: URL) throws -> Summary {
        var sessions: [Session] = []

        if let enumerator = fileManager.enumerator(
            at: rootDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles],
            errorHandler: nil
        ) {

            for case let directoryURL as URL in enumerator {
                var isDirectory: ObjCBool = false

                if fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory), isDirectory.boolValue {

                    let directoryName = directoryURL.lastPathComponent.uppercased()

                    if directoryName.localizedLowercase == "flat" {
                        enumerator.skipDescendants()
                        continue
                    }

                    let contents = (try? fileManager.contentsOfDirectory(atPath: directoryURL.path)) ?? []

                    if FileClient.requiredFiles.map(\.name).allSatisfy(contents.contains) {
                        do {
                            if let session = try createSession(from: directoryURL) {
                                sessions.append(session)
                            }
                            enumerator.skipDescendants()
                        } catch {
                            throw error
                        }
                    } else {
                        throw FileClientError.missingRequiredFiles(directoryURL)
                    }
                }
            }
        } else {
            throw FileClientError.directoryNotFound
        }
        return Summary(sessions: sessions)
    }

    private func checkForRequiredFiles(in directory: URL) -> Bool {
        let contents = (try? fileManager.contentsOfDirectory(atPath: directory.path)) ?? []
        return FileClient.requiredFiles.map(\.name).allSatisfy(contents.contains)
    }

    private func createSummaryFromDirectory(_ directory: URL) throws -> Summary {
        var sessions: [Session] = []

        do {
            if let session = try createSession(from: directory) {
                sessions.append(session)
            }
        } catch {
            throw error
        }

        return Summary(sessions: sessions)
    }

    private func createSession(from directory: URL) throws -> Session? {
        var fileData: [RequiredFile: Data] = [:]

        for file in FileClient.requiredFiles {
            let fileURL = directory.appendingPathComponent(file.name)
            fileData[file] = try? Data(contentsOf: fileURL)
        }

        guard
            let acquisitionData = fileData[RequiredFile.acquisitionDetails],
            let imageMetaData = fileData[RequiredFile.imageMetaData],
            let weatherData = fileData[RequiredFile.weatherData]
        else {
            throw FileClientError.missingRequiredFiles(directory)
        }

        do {
            let acquisitionDetails = try decoder.decode(AcquisitionDetails.self, from: acquisitionData)
            let imageMeta = try decoder.decode([ImageMetaData].self, from: imageMetaData)
            let weather = try decoder.decode([WeatherData].self, from: weatherData)

            return Session(
                acquisitionDetails: acquisitionDetails,
                imageMetaData: imageMeta,
                weatherData: weather
            )

        } catch {
            throw FileClientError.decodingError(directory)
        }
    }
}
