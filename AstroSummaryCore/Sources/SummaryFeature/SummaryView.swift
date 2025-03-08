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
        .toolbar {
            if case let .loaded(url, summary) = viewModel.state {
                if let targetName = summary.formattedTargetName {
                    ToolbarItem(placement: .principal) {
                        Text(targetName)
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .status) {
                    Text(url.formatted(.url.scheme(.never).path()))
                        .foregroundStyle(.secondary)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                openButton
            }
            ToolbarItem(placement: .automatic) {
                Button("Clear") {
                    viewModel.clickedClearButton()
                }
                .disabled(viewModel.disableClearButton)
            }
        }
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [.folder]
        ) { result in
            viewModel.selectedDirectory(with: result)
        }
    }

    private var initialView: some View {
        ContentUnavailableView {
            Label("No Project", systemImage: "tablecells")
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
        TabView {
            Table(summary.darks) {
                TableColumn("Temperature") { dark in
                    Text(dark.formattedTargetCameraTemperature)
                }

                TableColumn("Duration") { dark in
                    Text(dark.formattedExposureDurationSeconds)
                }

                TableColumn("Gain") { dark in
                    Text(dark.formattedGain)
                }

                TableColumn("Binning") { dark in
                    Text(dark.formattedBinning)
                }
            }
            .tabItem {
                Label("Darks", systemImage: "lightbulb.slash")
            }

            Table(summary.sessions) {
                // This is a workaround to diaplay more than 10 columns in the table
                if true {
                    TableColumn("Date") { session in
                        Text(session.formattedDate)
                    }

                    TableColumn("Filter") { session in
                        Text(session.formattedFilter)
                    }

                    TableColumn("Number") { session in
                        Text(session.formattedNumber)
                    }

                    TableColumn("Duration") { session in
                        Text(session.formattedDuration)
                    }

                    TableColumn("Binning") { session in
                        Text(session.formattedBinning)
                    }

                    TableColumn("Gain") { session in
                        Text(session.formattedGain)
                    }

                    TableColumn("Cooling") { session in
                        Text(session.formattedCooling)
                    }

                    TableColumn("Mean FWHM") { session in
                        Text(session.formattedMeanFWHM)
                    }

                    TableColumn("Temperature") { session in
                        Text(session.formattedTemperature)
                    }

                    TableColumn("Bias") { session in
                        Text(session.formattedBiasCount)
                    }
                }

                // This is a workaround to diaplay more than 10 columns in the table
                if true {
                    TableColumn("Dark") { session in
                        Text(session.formattedDarkCount)
                    }

                    TableColumn("Flat") { session in
                        Text(session.formattedFlatCount)
                    }
                }
            }
            .tabItem {
                Label("Sessions", systemImage: "list.bullet")
            }

            List {
                LabeledContent("Total Duration", value: summary.formattedTotalDuration)
                LabeledContent("Days Imaged", value: summary.formattedUniqueDateCount)
                LabeledContent("Date Interval", value: summary.formattedDateInterval)
                LabeledContent("Total Span", value: summary.formattedDateRange)
                LabeledContent("Filters", value: summary.formattedUniqueFilters)
            }
            .alternatingRowBackgrounds()
            .tabItem {
                Label("Stats", systemImage: "chart.bar")
            }
        }
    }

    @ViewBuilder
    private func loadedView(for url: URL, summary: Summary) -> some View {
        Group {
            if summary.sessions.isEmpty {
                emptySummaryView(for: url)
            } else {
                populatedSummaryView(for: summary)
            }
        }
    }

    private var errorView: some View {
        Text("Error")
    }

    private var openButton: some View {
        Button("Open Project") {
            viewModel.clickedOpenButton()
        }
    }
}
