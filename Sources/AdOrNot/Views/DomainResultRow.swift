import SwiftUI

struct DomainResultRow: View {
    let result: TestResult

    var body: some View {
        HStack(spacing: Theme.spacingSM) {
            // Status icon with colored background
            ZStack {
                Circle()
                    .fill(result.isBlocked
                          ? Theme.scoreGood.opacity(0.15)
                          : Theme.scoreWeak.opacity(0.15))
                    .frame(width: 28, height: 28)

                Image(systemName: result.isBlocked ? "checkmark" : "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(result.isBlocked ? Theme.scoreGood : Theme.scoreWeak)
            }

            // Domain info
            VStack(alignment: .leading, spacing: 1) {
                Text(result.domain.hostname)
                    .font(.caption.monospaced())
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text(result.domain.provider)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.35))
            }

            Spacer()

            // Response time
            if let ms = result.responseTimeMs, !result.isBlocked {
                Text("\(Int(ms))ms")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.3))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background {
                        Capsule()
                            .fill(Color.white.opacity(0.06))
                    }
            }
        }
        .padding(.vertical, Theme.spacingXS)
        .padding(.horizontal, Theme.spacingMD)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(result.domain.provider), \(result.domain.hostname), \(result.isBlocked ? "blocked" : "exposed")")
    }
}

#Preview("Blocked") {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()
        VStack {
            DomainResultRow(result: TestResult(
                domain: TestDomain(hostname: "pagead2.googlesyndication.com", provider: "Google Ads", category: .ads),
                isBlocked: true
            ))
            DomainResultRow(result: TestResult(
                domain: TestDomain(hostname: "analytics.google.com", provider: "Google Analytics", category: .analytics),
                isBlocked: false,
                responseTimeMs: 142
            ))
        }
        .glassCard()
    }
}
