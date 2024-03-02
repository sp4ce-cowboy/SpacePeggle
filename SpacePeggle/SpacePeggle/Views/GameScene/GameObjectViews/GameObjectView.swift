import SwiftUI

struct GameObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: GameSceneViewModel
    var gameObject: any GameObject

    var rotation: Angle { gameObject.rotation }
    var scale: Double { gameObject.scale }
    var gameObjectType: String { gameObject.gameObjectType }
    var gameObjectImageHeight: Double { gameObject.height }
    var gameObjectImageWidth: Double { gameObject.width }

    var gameObjectImage: String {
        ObjectSet.defaultGameObjectSet[gameObjectType]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var body: some View {
        Image(gameObjectImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: gameObjectImageWidth, height: gameObjectImageHeight)
            .position(gameObject.centerPosition.point)
            .rotationEffect(rotation, anchor: .center)
            .scaleEffect(scale, anchor: .center)
            .opacity(viewModel.gameObjectOpacities[gameObject.id, default: .unit])
            .gesture(handleLongPress)

    }

    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleGameObjectRemoval(self)
            }
    }
}
