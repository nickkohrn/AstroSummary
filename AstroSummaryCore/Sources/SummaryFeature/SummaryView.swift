import FileClient
import Foundation
import Models
import SwiftUI

public struct SummaryView: View {
    @Bindable private var viewModel = SummaryViewModel()

    public init() {}

    public var body: some View {
        VStack {
            switch viewModel.state {
            case .initial:
                initialView
            case .loading:
                loadingView
            case .loaded(let url, let summary):
                loadedView(for: url, summary: summary)
            case .error:
                errorView
            }
        }
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [.directory]
        ) { result in
            viewModel.selectedDirectory(with: result)
        }





//        VStack {
//            if isLoading {

//            } else {
//                if summary.sortedSessions.isEmpty {
//                    ContentUnavailableView {
//                        Label("No Data", systemImage: "tablecells")
//                    } description: {
//                        Text("Open a project to see acquisition details.")
//                    } actions: {
//                        openButton
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .padding()
//                } else {
//                    Table(summary.sortedSessions, selection: $selectedID) {
//                        if showDateColumn {
//                            TableColumn("Date") { session in
//                                if let value = session.date {
//                                    Text(value.formatted(.dateTime.year().month().day()))
//                                }
//                            }
//                        }
//
//                        if showFilterColumn {
//                            TableColumn("Filter") { session in
//                                if let value = session.filter {
//                                    Text(value)
//                                }
//                            }
//                        }
//
//                        if showNumberColumn {
//                            TableColumn("Number") { session in
//                                if let value = session.number {
//                                    Text(value.formatted())
//                                }
//                            }
//                        }
//
//                        if showDurationColumn {
//                            TableColumn("Duration") { session in
//                                if let value = formattedSeconds(for: session) {
//                                    Text(value)
//                                }
//                            }
//                        }
//
//                        if showBinningColumn {
//                            TableColumn("Binning") { session in
//                                if let value = session.binning {
//                                    Text(value)
//                                }
//                            }
//                        }
//
//                        if showGainColumn {
//                            TableColumn("Gain") { session in
//                                if let value = session.gain {
//                                    Text(value.formatted())
//                                }
//                            }
//                        }
//
//                        if showCoolingColumn {
//                            TableColumn("Cooling") { session in
//                                if let value = session.targetCameraTemperature {
//                                    Text(value.formatted(.measurement(width: .abbreviated, usage: .asProvided)))
//                                }
//                            }
//                        }
//
//                        if showSkyQualityColumn {
//                            TableColumn("Sky Quality") { session in
//                                if let value = session.skyQuality {
//                                    Text(value)
//                                }
//                            }
//                        }
//
//                        if showMeanFWHMColumn {
//                            TableColumn("Mean FWHM") { session in
//                                if let value = session.meanFWHM {
//                                    Text(value.formatted(.number.precision(.fractionLength(0...1))))
//                                }
//                            }
//                        }
//
//                        // This is a goofy workaround to get more than 10 table columns.
//                        if true {
//                            if showTemperatureColumn {
//                                TableColumn("Temperature") { session in
//                                    if let value = session.ambientTemperature {
//                                        Text(value.formatted(.measurement(width: .abbreviated, usage: .asProvided, numberFormatStyle: .number.precision(.fractionLength(0...1)))))
//                                    }
//                                }
//                            }
//
//                            if showBiasColumn {
//                                TableColumn("Bias") { _ in
//                                    Text(biasCount.formatted())
//                                }
//                            }
//
//                            if showDarkColumn {
//                                TableColumn("Dark") { _ in
//                                    Text(darkCount.formatted())
//                                }
//                            }
//
//                            if showFlatsColumn {
//                                TableColumn("Flat") { _ in
//                                    Text(flatCount.formatted())
//                                }
//                            }
//
//                            if showEnteredColumn {
//                                TableColumn("Entered") { session in
//                                    if let index = summary.sessions.firstIndex(where: { $0.id == session.id }) {
//                                        Toggle("", isOn: $summary.sessions[index].isEntered)
//                                            .labelsHidden()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .animation(.default, value: summary.sessions)
//                    .onChange(of: selectedID) { _, newValue in
//                        selectedID = newValue
//                        guard let session = summary.sessions.first(where: { $0.id == newValue }) else {
//                            return
//                        }
//                        dismissWindow(id: "session")
//                        openWindow(id: "session", value: session)
//                    }
//                }
//            }
//        }
//        .animation(.default, value: isLoading)
//        .toolbar {
//            ToolbarItem(placement: .automatic) {
//                Button("Open...") {
//                    selectDirectory()
//                }
//            }
//
//            ToolbarItem(placement: .automatic) {
//                Button("Clear") {
//                    clearData()
//                }
//                .disabled(summary.sessions.isEmpty)
//            }
//
//            ToolbarItem(placement: .automatic) {
//                Button {
//                    showPopup.toggle()
//                } label: {
//                    Image(systemName: "info.circle")
//                }
//                .disabled(summary.sessions.isEmpty)
//                .popover(isPresented: $showPopup, arrowEdge: .top) {
//                    VStack {
//                        if let total = formattedTotalDuration(for: summary) {
//                            LabeledContent("Total Duration:") {
//                                Text(total)
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                        LabeledContent("Days Imaged:") {
//                            Text(summary.uniqueDateCount.formatted())
//                                .foregroundStyle(.secondary)
//                        }
//                        if let range = summary.dateRange {
//                            LabeledContent("Span:") {
//                                Text(range.formatted(.components(style: .abbreviated, fields: [.day])))
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                        if let filters = summary.uniqueFilters {
//                            LabeledContent("Filters:") {
//                                Text(filters.formatted(.list(type: .and, width: .narrow)))
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                    }
//                    .padding()
//                }
//            }
//
//            ToolbarItem(placement: .principal) {
//                if let projectName = summary.projectName {
//                    Text(projectName)
//                        .fontWeight(.bold)
//                }
//            }
//
//            ToolbarItem(placement: .automatic) {
//                SettingsLink {
//                    Label("Settings", systemImage: "gearshape")
//                }
//            }
//
//            ToolbarItem(placement: .automatic) {
//                Menu("Export") {
//                    Button("Export as CSV") {
//                        exportData(format: .csv)
//                    }
//                    Button("Export as JSON") {
//                        exportData(format: .json)
//                    }
//                    Button("Export as Excel") {
//                        exportData(format: .excel)
//                    }
//                }
//                .disabled(summary.sessions.isEmpty)
//            }
//        }
    }

    private var initialView: some View {
        ContentUnavailableView {
            Label("Select a Summary", systemImage: "tablecells")
        } description: {
            Text("Open a project to view its summary.")
        } actions: {
            openButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var loadingView: some View {
        ProgressView("Loading...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }

    private func emptySummaryView(for url: URL) -> some View {
        ContentUnavailableView {
            Label("No Summary Available", systemImage: "tablecells")
        } description: {
            Text("Information required to create a project summary was not found at '\(url.path)'")
        } actions: {
            openButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private func populatedSummaryView(for summary: Summary) -> some View {
        Text(String(describing: summary))
    }

    @ViewBuilder
    private func loadedView(for url: URL, summary: Summary) -> some View {
        if summary.sessions.isEmpty {
            emptySummaryView(for: url)
        } else {
            populatedSummaryView(for: summary)
        }
    }

    private var errorView: some View {
        Text("Error")
    }

    private var openButton: some View {
        Button("Open...") {
            viewModel.clickedOpenButton()
        }
    }

    /// Clears the current session data
//    private func clearData() {
//        withAnimation {
//            summary = Summary(sessions: [])
//            selectedDirectory = nil
//        }
//    }

    /// Loads sessions from the selected directory into `Summary`
//    private func loadSummary(from directory: URL) {
//        isLoading = true
//        DispatchQueue.global(qos: .userInitiated).async {
//            let loader = SessionLoader(rootDirectory: directory)
//            do {
//                let newSummary = try loader.loadSummary()
//                DispatchQueue.main.async {
//                    self.summary = newSummary
//                    self.isLoading = false
//                }
//            } catch {
//                // TODO: Handle error
//                print(error)
//            }
//        }
//    }

//    private func formattedSeconds(for session: Session) -> String? {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.second]
//        formatter.unitsStyle = .abbreviated
//        return formatter.string(from: session.duration)
//    }

//    private func formattedTotalDuration(for summary: Summary) -> String? {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .abbreviated
//        return formatter.string(from: summary.totalDuration)
//    }

    /// Exports session data as CSV, JSON, or Excel
//    private func exportData(format: ExportFormat) {
//        let panel = NSSavePanel()
//        panel.canCreateDirectories = true
//
//        switch format {
//        case .csv:
//            panel.allowedContentTypes = [UTType.commaSeparatedText]
//            panel.nameFieldStringValue = "\(summary.projectName ?? "sessions").csv"
//        case .json:
//            panel.allowedContentTypes = [UTType.json]
//            panel.nameFieldStringValue = "\(summary.projectName ?? "sessions").json"
//        case .excel:
//            panel.allowedContentTypes = [UTType.spreadsheet]
//            panel.nameFieldStringValue = "\(summary.projectName ?? "sessions").xlsx"
//        }
//
//        if panel.runModal() == .OK, let url = panel.url {
//            do {
//                let data: Data?
//                switch format {
//                case .csv:
//                    data = generateCSVData()
//                case .json:
//                    data = generateJSONData()
//                case .excel:
//                    data = generateExcelData()
//                }
//
//                if let data = data {
//                    try data.write(to: url)
//                }
//            } catch {
//                print("Failed to export data: \(error)")
//            }
//        }
//    }

//#warning("The CSV data doesn't appear to be aligned when opened in Numbers.")
//    private func generateCSVData() -> Data? {
//        var csvString = "Date,Filter,Number,Duration,Binning,Gain,Cooling,Sky Quality,Temperature\n"
//
//        for session in summary.sessions {
//            let date = session.date?.formatted(.dateTime.year().month().day()) ?? "N/A"
//            let filter = session.filter ?? "N/A"
//            let number = session.number.map { "\($0)" } ?? "N/A"
//            let duration = formattedSeconds(for: session) ?? "N/A"
//            let binning = session.binning ?? "N/A"
//            let gain = session.gain.map { "\($0)" } ?? "N/A"
//            let cooling = session.targetCameraTemperature?.formatted(.measurement(width: .abbreviated)) ?? "N/A"
//            let skyQuality = session.skyQuality ?? "N/A"
//            let temperature = session.ambientTemperature?.formatted(.measurement(width: .abbreviated)) ?? "N/A"
//
//            csvString.append("\(date),\(filter),\(number),\(duration),\(binning),\(gain),\(cooling),\(skyQuality),\(temperature)\n")
//        }
//
//        return csvString.data(using: .utf8)
//    }

//    private func generateJSONData() -> Data? {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        return try? encoder.encode(summary.sessions)
//    }

//    private func generateExcelData() -> Data? {
//        generateCSVData() // Excel can read CSV files
//    }
}
