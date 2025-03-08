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

    public enum Tab: Equatable {
        case darks
        case sessions
        case stats
    }

    public var disableClearButton: Bool {
        switch state {
        case .error: true
        case .initial: true
        case .loaded(_, let summary): summary.sessions.isEmpty
        case .loading: true
        }
    }

    public private(set) var state = State.initial

    public var showFileImporter = false

    public var selectedTab = Tab.darks

    public init() {}

    public func clickedClearButton() {
        state = .initial
    }

    public func clickedOpenButton() {
        showFileImporter = true
    }

    public func selectedDirectory(with result: Result<URL, any Error>) {
        state = .loading
        switch result {
        case .success(let url):
            do {
                let summary = try SummaryLoader(rootDirectory: url).createSummary()
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
