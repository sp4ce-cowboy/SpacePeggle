import SwiftUI

struct GameObjectView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel
    var gameObject: any GameObject

    var center: Vector { gameObject.centerPosition }
    var rotation: Angle { gameObject.rotation }
    var scale: Double { gameObject.scale }
    var gameObjectType: String { gameObject.gameObjectType.rawValue }
    var gameObjectImageHeight: Double { gameObject.height }
    var gameObjectImageWidth: Double { gameObject.width }

    var gameObjectImage: String {
        ObjectSet.defaultGameObjectSet[gameObjectType]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var current: Double { Double(gameObject.hp) }
    var minValue: Double { Double(Constants.MIN_HP_VALUE) }
    var maxValue: Double { Double(Constants.MAX_HP_VALUE) }

    var body: some View {
        ZStack {
            Image(gameObjectImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .if(gameObject.hp > 1) { view in
                    view.overlay(GameObjectHealthOverlayView(gameObject: gameObject))
                        .environmentObject(viewModel)
                }
                .frame(width: gameObjectImageWidth, height: gameObjectImageHeight)
                .position(center.point)
                .rotationEffect(rotation, anchor: center.unitPoint)
                .opacity(viewModel.gameObjectOpacities[gameObject.id, default: .unit])
                .gesture(handleLongPress)
        }
    }

    /// For stuck balls
    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleGameObjectRemoval(self)
            }
    }
}
