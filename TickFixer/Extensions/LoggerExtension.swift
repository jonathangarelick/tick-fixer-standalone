import OSLog

// https://www.avanderlee.com/debugging/oslog-unified-logging/
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let main = Logger(subsystem: subsystem, category: "main")
}
