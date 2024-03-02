import SwiftUI

/// This View presents a transparent, rectangular overlay that can
/// defining the bounds for the gameplay area independently of other views.
///
/// The PlayableArea is the static analogue to GameAreaView. While they
/// serve identical functions, PlayableArea is controlled by the LevelScene M
/// while GameAreaView by the GameSceneVM. This provides a clearer separation
/// of responsibilities.
///
struct PlayableAreaView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var size: CGSize {
        viewModel.geometryState.size
    }

    var width: Double {
        size.width
    }
    var height: Double {
        size.height
    }

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            // .padding()
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .gesture(handleTapGesture)
    }

    var handleTapGesture: some Gesture {
        SpatialTapGesture()
            .onEnded { value in
                Logger.log("Tap detected at \(value.location)", self)
                viewModel.handleAreaTap(in: value.location)
            }
    }
}
