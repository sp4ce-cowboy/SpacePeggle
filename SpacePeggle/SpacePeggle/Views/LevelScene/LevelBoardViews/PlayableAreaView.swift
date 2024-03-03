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

    var area: CGRect { viewModel.levelDomain }
    var geometrySize: CGSize { viewModel.geometryState.size }

    var body: some View {
        ZStack {
            area
                .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round,
                                           lineJoin: .bevel, dash: [3, 10]))
                .foregroundStyle(Color.red)
                .foregroundColor(.clear)
                .contentShape(area) // Will only register hits within playable area
                .if(!viewModel.isLevelDesignerPaused) { view in
                    view.gesture(handleTap)
                }
        }
    }

    private var handleTap: some Gesture {
        SpatialTapGesture()
            .onEnded { value in
                viewModel.currentGameObject = nil
                Logger.log("Tap detected at \(value.location)", self)
                viewModel.handleAreaTap(in: value.location)
            }
    }
}
