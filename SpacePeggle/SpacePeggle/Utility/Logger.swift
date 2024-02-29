import SwiftUI

/// The logger class can be set to be active if logging is required,
/// within the constants class.
class Logger {
    static var isActive = Constants.LOGGING_IS_ACTIVE

    static func log(_ string: String, _ caller: Any? = nil) {
        if isActive {
            let callerType = caller == nil ? "Unknown" : String(describing: type(of: caller!))
            print("[\(callerType)] \(string)")
        }
    }
}
