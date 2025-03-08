import Foundation
import Models

public struct SummaryLoader {
    private let decoder: JSONDecoder
    private let rootDirectory: URL
    private let fileManager: FileManager

    private static let requiredFiles: Set<RequiredFile> = [
        .acquisitionDetails,
        .imageMetaData,
        .weatherData
    ]

    public init(
        decoder: JSONDecoder = JSONDecoder(),
        fileManager: FileManager = FileManager.default,
        rootDirectory: URL
    ) {
        self.decoder = decoder
        self.fileManager = fileManager
        self.rootDirectory = rootDirectory
    }

    /// Traverses directories recursively and returns a `Summary` containing sorted sessions.
    public func createSummary() throws -> Summary {
        defer { rootDirectory.stopAccessingSecurityScopedResource() }
        let accessible = rootDirectory.startAccessingSecurityScopedResource()
        guard accessible else {
#warning("How can this be tested? Find a directory that will deny access?")
            throw SummaryLoaderError.accessDenied(rootDirectory)
        }

        var sessions: [Session] = []

        if let enumerator = fileManager.enumerator(at: rootDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) {
            for case let directoryURL as URL in enumerator {
                if fileManager.fileExists(atPath: directoryURL.path) {
                    let contents = (try? fileManager.contentsOfDirectory(atPath: directoryURL.path)) ?? []

                    // If the directory contains one of the required files, check whether they are all present. If not, thrown an error.
                    if contents.contains(where: { SummaryLoader.requiredFiles.map(\.name).contains($0) }) {
                        guard SummaryLoader.requiredFiles.map(\.name).allSatisfy(contents.contains) else {
                            let existing = SummaryLoader.requiredFiles.filter { contents.contains($0.name) }
                            let missing = SummaryLoader.requiredFiles.subtracting(existing)
                            throw SummaryLoaderError.missingRequiredFiles(directoryURL, missing)
                        }

                        let acquisitionURL = directoryURL.appendingPathComponent(RequiredFile.acquisitionDetails.name)
                        let imageMetaURL = directoryURL.appendingPathComponent(RequiredFile.imageMetaData.name)
                        let weatherURL = directoryURL.appendingPathComponent(RequiredFile.weatherData.name)

                        let acquisitionDetails: AcquisitionDetails
                        let imageMetaData: [ImageMetaData]
                        let weatherData: [WeatherData]

                        do {
                            acquisitionDetails = try decoder.decode(AcquisitionDetails.self, from: try Data(contentsOf: acquisitionURL))
                        } catch {
                            throw SummaryLoaderError.decodingError(acquisitionURL)
                        }

                        do {
                            imageMetaData = try decoder.decode([ImageMetaData].self, from: try Data(contentsOf: imageMetaURL))
                        } catch {
                            throw SummaryLoaderError.decodingError(imageMetaURL)
                        }

                        do {
                            weatherData = try decoder.decode([WeatherData].self, from: try Data(contentsOf: weatherURL))
                        } catch {
                            throw SummaryLoaderError.decodingError(weatherURL)
                        }

                        var currentURL: URL? = directoryURL

                        while let url = currentURL {
                            currentURL = url.deletingLastPathComponent()
                            if currentURL?.path == rootDirectory.path { break }
                        }
                        sessions.append(Session(acquisitionDetails: acquisitionDetails, imageMetaData: imageMetaData, weatherData: weatherData))
                    }
                }
            }
        }
        let sortedSessions = sessions.sorted(by: { $0.date ?? .distantPast < $1.date ?? .distantPast })
        return Summary(sessions: sortedSessions)
    }
}
