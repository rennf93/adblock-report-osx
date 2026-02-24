import SwiftUI

#if canImport(UIKit)
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#else
import AppKit

struct ShareSheet: View {
    let text: String
    @State private var copied = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: Theme.spacingMD) {
                // Header
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Theme.brandBlueLight)
                    Text("Export Results")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }

                // Text content
                ScrollView {
                    Text(text)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.8))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Theme.spacingSM)
                }
                .background {
                    RoundedRectangle(cornerRadius: Theme.radiusMD)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radiusMD)
                                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                        )
                }

                // Copy button
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                    withAnimation {
                        copied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            copied = false
                        }
                    }
                } label: {
                    HStack(spacing: Theme.spacingSM) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        Text(copied ? "Copied!" : "Copy to Clipboard")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(GradientButtonStyle())
            }
            .padding(Theme.spacingLG)
        }
        .frame(minWidth: 480, minHeight: 360)
    }
}
#endif
