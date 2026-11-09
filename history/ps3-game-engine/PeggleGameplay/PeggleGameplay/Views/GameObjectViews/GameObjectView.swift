import SwiftUI

struct GameObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: MainViewModel

    var gameObject: any GameObject

    var gameObjectType: String {
        gameObject.gameObjectType
    }
    var gameObjectImage: String {
        ObjectSet.defaultGameObjectSet[gameObjectType]?.name ??
        ObjectSet.DEFAULT_IMAGE_STUB
    }
    var gameObjectImageHeight: Double {
        Double(ObjectSet.defaultGameObjectSet[gameObjectType]?.size.height ??
        CGFloat(Constants.UNIVERSAL_LENGTH))
    }
    var gameObjectImageWidth: Double {
        Double(ObjectSet.defaultGameObjectSet[gameObjectType]?.size.width ??
        CGFloat(Constants.UNIVERSAL_LENGTH))
    }

    var body: some View {
        Image(gameObjectImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: gameObjectImageWidth, height: gameObjectImageHeight)
            .position(gameObject.centerPosition.point)
            .gesture(handleLongPress)
            .opacity(viewModel.gameObjectOpacities[gameObject.id, default: 1])

    }

    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleGameObjectRemoval(self)
            }
    }

}
