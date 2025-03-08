import FileClient
import Foundation
import Testing
import Models

struct SessionLoaderTests {
    @Test
    func createsSummary() throws {
        let testDirectory = try #require(Bundle.module.url(
            forResource: "TestResources/AllFilesDirectory",
            withExtension: nil
        ))

        let summary = try SummaryLoader(rootDirectory: testDirectory).createSummary()
        #expect(summary.sessions.count == 1)
    }

    @Test
    func requiredFileMissing() throws {
        let testDirectory = try #require(Bundle.module.url(
            forResource: "TestResources/MissingFilesDirectory",
            withExtension: nil
        ))

        do {
            _ = try SummaryLoader(rootDirectory: testDirectory).createSummary()
            Issue.record("Expected missingRequiredFiles error but did not get one.")
        } catch SummaryLoaderError.missingRequiredFiles(let directory, let missingFiles) {
            #expect(directory.path == testDirectory.appending(path: "LIGHT").path)
            #expect(missingFiles == [.imageMetaData, .weatherData])
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func decodingFailure() throws {
        let testDirectory = try #require(Bundle.module.url(
            forResource: "TestResources/AllFilesDirectory",
            withExtension: nil
        ))

        do {
            _ = try SummaryLoader(decoder: ThrowingJSONDecoder(), rootDirectory: testDirectory).createSummary()
            Issue.record("Expected decodingError but did not get one.")
        } catch SummaryLoaderError.decodingError(let url) {
            print(url)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
