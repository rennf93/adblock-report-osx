import SwiftUI

struct TestingView: View {
    @Bindable var viewModel: TestViewModel
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            AnimatedMeshBackground()

            VStack(spacing: Theme.spacingXL) {
                Spacer()

                // Progress ring
                progressRing
                    .padding(.bottom, Theme.spacingSM)

                // Status info
                statusSection

                // Live stats
                liveStats

                Spacer()

                // Cancel button
                Button {
                    viewModel.cancelTest()
                } label: {
                    HStack(spacing: Theme.spacingSM) {
                        Image(systemName: "xmark")
                        Text("Cancel")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.bottom, Theme.spacingXL)
            }
            .padding(.horizontal, Theme.spacingXL)
        }
    }

    // MARK: - Progress Ring

    private var progressRing: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(Theme.brandBlue.opacity(0.08))
                .frame(width: 240, height: 240)
                .blur(radius: 20)
                .scaleEffect(pulseScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        pulseScale = 1.08
                    }
                }

            // Background track
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: 14)
                .frame(width: 200, height: 200)

            // Progress arc
            Circle()
                .trim(from: 0, to: viewModel.progress)
                .stroke(
                    AngularGradient(
                        colors: [Theme.brandCyan, Theme.brandBlue, Theme.brandIndigo],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 14, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
                .shadow(color: Theme.brandBlue.opacity(0.4), radius: 8)

            // Center content
            VStack(spacing: Theme.spacingXS) {
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Text("\(viewModel.completedCount)/\(viewModel.totalCount)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Test progress")
        .accessibilityValue("\(Int(viewModel.progress * 100))%, \(viewModel.completedCount) of \(viewModel.totalCount) domains tested")
    }

    // MARK: - Status Section

    private var statusSection: some View {
        VStack(spacing: Theme.spacingSM) {
            HStack(spacing: Theme.spacingSM) {
                ProgressView()
                    .controlSize(.small)
                    .tint(.white)
                Text("Testing...")
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            Text(viewModel.currentDomain)
                .font(.caption.monospaced())
                .foregroundStyle(.white.opacity(0.4))
                .lineLimit(1)
                .truncationMode(.middle)
        }
    }

    // MARK: - Live Stats

    private var liveStats: some View {
        HStack(spacing: Theme.spacingMD) {
            StatCard(
                title: "Elapsed",
                value: formatDuration(viewModel.elapsedTime),
                icon: "clock.fill"
            )
            StatCard(
                title: "Tested",
                value: "\(viewModel.completedCount)",
                icon: "checkmark.circle.fill"
            )
            StatCard(
                title: "Remaining",
                value: "\(viewModel.totalCount - viewModel.completedCount)",
                icon: "hourglass"
            )
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    TestingView(viewModel: PreviewData.makeRunningViewModel())
}
