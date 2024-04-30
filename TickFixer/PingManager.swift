import AppKit
import Foundation
import OSLog
import SystemConfiguration

class PingManager: ObservableObject {
    @Published var running: Bool = false

    var process: Process = Process()
    var failureCount: Int = 0

    init() {
        guard let defaultGateway = getDefaultGatewayAddress() else { return }

        initProcess(address: defaultGateway)
        runProcess()

        NotificationCenter.default.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            self?.process.terminate()
        }
    }

    func initProcess(address: String) {
        process.executableURL = URL(fileURLWithPath: "/sbin/ping")
        process.arguments = ["-i", "0.2", address]

        let pipe = Pipe()
        process.standardOutput = pipe

        let outputHandle = pipe.fileHandleForReading
        outputHandle.readabilityHandler = { [weak self] handle in
            if let output = String(data: handle.availableData, encoding: .utf8), output.contains("timeout") {
                guard let self = self else { return }

                if self.failureCount >= 100 {
                    Logger.main.error("Failed to ping 100 times. Terminating")
                    self.process.terminate()
                    DispatchQueue.main.async {
                        self.running = false
                    }
                    return
                }

                self.failureCount += 1
            }
        }
    }

    func runProcess() {
        do {
            try process.run()
            running = true
        } catch {
            Logger.main.error("Failed to run process: \(error.localizedDescription)")
        }
    }

    func getDefaultGatewayAddress() -> String? {
        Logger.main.debug("Getting default gateway")

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

        Logger.main.debug("Default gateway is: \(output ?? "nil")")

        return output
    }
}

