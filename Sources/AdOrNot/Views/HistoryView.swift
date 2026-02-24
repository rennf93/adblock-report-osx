import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \TestReport.date, order: .reverse)
    private var reports: [TestReport]

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            AnimatedMeshBackground()

            if reports.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: Theme.spacingMD) {
                        ForEach(reports) { report in
                            NavigationLink(destination: HistoryDetailView(report: report)) {
                                reportCard(report)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(report)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.vertical, Theme.spacingMD)
                    .frame(maxWidth: 640)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("History")
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Theme.spacingLG) {
            ZStack {
                Circle()
                    .fill(Theme.brandBlue.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .blur(radius: 15)

                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 44))
                    .foregroundStyle(Theme.brandBlueLight.opacity(0.5))
            }

            VStack(spacing: Theme.spacingSM) {
                Text("No Test History")
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Text("Run your first test to see results here.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    // MARK: - Report Card

    private func reportCard(_ report: TestReport) -> some View {
        HStack(spacing: Theme.spacingMD) {
            ScoreGaugeView(
                score: report.overallScore,
                animateOnAppear: false,
                size: 50,
                showGlow: false
            )

            VStack(alignment: .leading, spacing: Theme.spacingXS) {
                Text(report.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("\(report.blockedDomains)/\(report.totalDomains) blocked")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Text("\(Int(report.overallScore))%")
                .font(.title3.bold().monospacedDigit())
                .foregroundStyle(ScoreThreshold.color(for: report.overallScore))

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.3))
        }
        .glassCard(padding: Theme.spacingMD)
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .modelContainer(.preview)
}
