import SwiftUI
import SwiftData

@main
struct AdOrNotApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(for: TestReport.self)
    }
}
