import SwiftUI

/// This View presents a transparent, rectangular overlay that can detect
/// user input gestures, which is used for defining the bounds for the playable
/// area independently of other views.
struct PlayableAreaView: View {
    var width: Double
    var height: Double
    var adjustedHeight: Double {
        height * Utility.TOP_HEIGHT_MODIFIER
    }

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .padding()
            .frame(width: width, height: adjustedHeight)
            .ignoresSafeArea()
            .contentShape(Rectangle())
    }
}
