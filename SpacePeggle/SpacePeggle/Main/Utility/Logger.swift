import SwiftUI

/// The logger class can be set to be active if logging is required,
/// within the constants class.
class Logger {
    static var isActive = Constants.LOGGING_IS_ACTIVE

    private init() { }

    static func log(_ string: String, _ caller: Any? = nil) {
        if isActive {
            let callerType = caller == nil ? "Unknown" : String(describing: type(of: caller!))
            let date = Date.now.formatted(date: .omitted, time: .standard)
            print("[\(date)] -- [\(callerType)] \(string)")
        }

    }
}
