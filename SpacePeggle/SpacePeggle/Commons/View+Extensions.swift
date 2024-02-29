import SwiftUI

/// This extension to View adds a conditional modifer to all views.
///
/// This allows for a view to have a modifier applied to it depending on a
/// boolean condition, or return itself otherwise.
///
/// Adapted from https://www.avanderlee.com/swiftui/conditional-view-modifier/
extension View {

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool,
                                          transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

/// Extensions to allow for a safer retrieval of screen size in the
/// context of SwiftUI where geometry reader might not be available.
///
/// Adapted from
/// 
/// '''
/// https://stackoverflow.com/questions/74458971/
/// correct-way-to-get-the-screen-size-on-ios-after-uiscreen-main-deprecation
/// '''
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                    return window
            }
        }
        return nil
    }
}

extension UIScreen {
    static var currentSize: CGSize {
        UIWindow.current?.windowScene?.keyWindow?.bounds.size ??
        UIScreen.main.bounds.size
    }
}
