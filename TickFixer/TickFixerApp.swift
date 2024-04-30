import OSLog
import SwiftUI

@main
struct TickFixerApp: App {
    @StateObject var pingManager = PingManager()
    
    var body: some Scene {
        MenuBarExtra {
            Button("TickFixer v1.0.0", action: {})
                .disabled(true)
            
            Divider()
            
            if !(pingManager.defaultGateway?.isEmpty ?? false) {
                Button("Running...", systemImage: "figure.run", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            } else {
                Button("Default Gateway Not Found", systemImage: "exclamationmark.triangle", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            }
            
            Button("Quit") {
                Logger.main.debug("User initiated exit")
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: "target")
        }
    }
}
