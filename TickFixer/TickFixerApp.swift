import SwiftUI

@main
struct TickFixerApp: App {
    @StateObject var pingManager = PingManager()

    var body: some Scene {
        MenuBarExtra {
            Button("Tick Fixer (Standalone) v1.0.0", action: {})
                .disabled(true)

            Divider()

            if pingManager.defaultGateway?.isEmpty ?? true {
                Button("Default Gateway Not Found", systemImage: "exclamationmark.triangle", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: "target")
        }
    }
}
