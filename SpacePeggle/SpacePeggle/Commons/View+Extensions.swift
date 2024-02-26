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
