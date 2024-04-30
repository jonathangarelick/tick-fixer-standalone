import Foundation
import SystemConfiguration

class PingManager: ObservableObject {
    @Published var defaultGateway: String?

    private var pingProcess: Process?

    init() {
        defaultGateway = getDefaultGatewayAddress()
        if let defaultGateway = defaultGateway {
            startPinging(address: defaultGateway)
        }
    }

    deinit {
        stopPinging()
    }

    func startPinging(address: String) {
        pingProcess = Process()
        pingProcess?.executableURL = URL(fileURLWithPath: "/sbin/ping")
        pingProcess?.arguments = ["-i", "0.2", address]

        do {
            try pingProcess?.run()
        } catch {
            print("Error starting ping process: \(error.localizedDescription)")
        }
    }

    func stopPinging() {
        pingProcess?.terminate()
        pingProcess = nil
    }

    func getDefaultGatewayAddress() -> String? {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", "netstat -nr | awk '/default/ {print $2}' | head -n1"]
        task.launchPath = "/bin/zsh"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

        task.waitUntilExit()

        return output
    }
}

