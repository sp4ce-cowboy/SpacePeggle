import SwiftUI

/// The Display Link class allows for the CADisplayLink and its corollaries to be
/// encapsulated.
///
/// Benefits of this approach:
///
/// * Decoupling: DisplayLink is decoupled from the view model, making it easier to use and manage.
///   It can be used by any part of the app that requires frame updates, not just the GameSceneViewModel.
///
/// * Reusability: The DisplayLink class can be reused across different parts of the game
///   wherever a CADisplayLink is needed outside the scope of the GameEngine
///
/// * Single Responsibility: Each class has a clear responsibility; DisplayLink manages
///   frame timing, while GameSceneViewModel handles game state updates and UI notifications.
///
/// Solution adapted from [here]
/// (https://stackoverflow.com/questions/67658580/how-to-properly-link-cadisplaylink-with-swiftui)
/// in February 2024 by Rubesh. Originally posted in 2021 to StackOverflow
/// by [Artem V](https://stackoverflow.com/users/16006855/artem-v)
///
class DisplayLink: NSObject {
    // static let sharedInstance = DisplayLink()
    var displayLink: CADisplayLink?

    /// A closure type that includes the frame duration
    var onUpdate: ((_ frameDuration: TimeInterval) -> Void)?

    override init() {
        super.init()
    }

    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc func updateDisplay(displayLink: CADisplayLink) {
        let frameDuration = displayLink.targetTimestamp - displayLink.timestamp
        onUpdate?(frameDuration)
    }

    func invalidate() {
        displayLink?.invalidate()
        displayLink = nil
        onUpdate = nil
    }

}
