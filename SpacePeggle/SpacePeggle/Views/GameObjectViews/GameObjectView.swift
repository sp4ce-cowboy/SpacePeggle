import SwiftUI

struct GameObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: MainViewModel

    var gameObject: any GameObject

    var rotation: Angle { gameObject.rotation }

    var scale: Double { gameObject.magnification }

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
            .rotationEffect(rotation, anchor: .center)
            .scaleEffect(scale, anchor: .center)
            .opacity(viewModel.gameObjectOpacities[gameObject.id, default: 1])
            .gesture(handleLongPress)
            .gesture(handleMagnification.simultaneously(with: handleRotate))

    }

    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleGameObjectRemoval(self)
            }
    }

    var handleRotate: some Gesture {
        RotateGesture()
            .onChanged { angle in
                viewModel.handleRotate(self, angle: angle.rotation)
            }
    }

    var handleMagnification: some Gesture {
        MagnifyGesture()
            .onChanged { scale in
                viewModel.handleMagnify(self, scale: scale.magnification)
            }
    }

}
