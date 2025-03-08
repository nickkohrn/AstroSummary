import FileClient
import Foundation
import Models
import Observation

@Observable
public final class SummaryViewModel {
    public enum State: Equatable {
        case initial
        case loading
        case loaded(URL, Summary)
        case error
    }

    public private(set) var state = State.initial

    public var showFileImporter = false

    public init() {}

    public func clickedOpenButton() {
        showFileImporter = true
    }

    public func selectedDirectory(with result: Result<URL, any Error>) {
        state = .loading
        switch result {
        case .success(let url):
            print(url)
            do {
                let summary = try FileClient().createSummary(from: url)
                state = .loaded(url, summary)
            } catch {
                print(error)
                state = .error
            }
        case .failure(let error):
            print(error)
            state = .error
        }
    }
}
