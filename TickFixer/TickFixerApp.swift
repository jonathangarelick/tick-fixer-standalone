import OSLog
import SwiftUI

@main
struct TickFixerApp: App {
    @StateObject var pingManager = PingManager()

    var body: some Scene {
        MenuBarExtra {
            Button("TickFixer v1.0.0") {}
                .disabled(true)

            Divider()

            Button(pingManager.running ? "Running..." : "Not Running",
                   systemImage: pingManager.running ? "figure.run" : "exclamationmark.triangle") {}
                .labelStyle(.titleAndIcon)
                .disabled(true)

            Button("Quit") {
                Logger.main.debug("User initiated exit")
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: "target")
        }
    }
}
