//import FileClient
//import Foundation
//import Testing
//import Models
//
//struct FileClientTests {
//    @Test
//    func createsSummaryWithSingleSession() throws {
//        let testDirectory = try #require(Bundle.module.url(
//            forResource: "TestResources/AllFilesDirectory",
//            withExtension: nil
//        ))
//
//        do {
//            let summary = try FileClient().createSummary(from: testDirectory)
//            #expect(summary.sessions.count == 1)
//            #expect(summary.darks.count == 1)
//        } catch {
//            Issue.record("Unexpected error: \(error)")
//        }
//    }
//
//    @Test
//    func createsSummaryWithMultipleSessions() throws {
//        let testDirectory = try #require(Bundle.module.url(
//            forResource: "TestResources/MultipleAllFilesDirectory",
//            withExtension: nil
//        ))
//
//        do {
//            let summary = try FileClient().createSummary(from: testDirectory)
//            #expect(summary.sessions.count == 2)
//            // The directories contain identical contents, so the darks should be the same.
//            #expect(summary.darks.count == 1)
//        } catch {
//            Issue.record("Unexpected error: \(error)")
//        }
//    }
//
//    @Test
//    func createsSummarySkippingFlats() throws {
//        let testDirectory = try #require(Bundle.module.url(
//            forResource: "TestResources/AllFilesForFlatsDirectory",
//            withExtension: nil
//        ))
//
//        do {
//            let summary = try FileClient().createSummary(from: testDirectory)
//            #expect(summary.sessions.isEmpty)
//        } catch {
//            Issue.record("Unexpected error: \(error)")
//        }
//    }
//
//    @Test
//    func throwsDirectoryNotFound() throws {
//        let fileClient = FileClient(fileManager: FileManager.default)
//
//        do {
//            let url = try #require(URL(string: "/dev/null"))
//            _ = try fileClient.createSummary(from: url)
//            Issue.record("Expected \(FileClientError.directoryNotFound)")
//        } catch {
//            let fileClientError = try #require(error as? FileClientError)
//            #expect(fileClientError == .directoryNotFound)
//        }
//    }
//
//    @Test
//    func throwsMissingRequiredFiles() throws {
//        let testDirectory = try #require(Bundle.module.url(
//            forResource: "TestResources/AcquisitionDetailsOnlyDirectory",
//            withExtension: nil
//        ))
//
//        do {
//            _ = try FileClient().createSummary(from: testDirectory)
//            Issue.record("Expected missingRequiredFiles error but did not get one.")
//        } catch let FileClientError.missingRequiredFiles(missingFileDirectory) {
//            #expect(missingFileDirectory.deletingLastPathComponent().path == testDirectory.path)
//        } catch {
//            Issue.record("Unexpected error: \(error)")
//        }
//    }
//
//    @Test
//    func throwsDecodingError() throws {
//        let testDirectory = try #require(Bundle.module.url(
//            forResource: "TestResources/AllFilesDirectory",
//            withExtension: nil
//        ))
//
//        let fileClient = FileClient(decoder: ThrowingJSONDecoder())
//
//        do {
//            _ = try fileClient.createSummary(from: testDirectory)
//            Issue.record("Expected decodingError but did not get one.")
//        } catch let FileClientError.decodingError(decodingDirectory) {
//            #expect(decodingDirectory.deletingLastPathComponent().path == testDirectory.path)
//        } catch {
//            Issue.record("Unexpected error: \(error)")
//        }
//    }
//}
