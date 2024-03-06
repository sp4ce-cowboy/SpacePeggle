import SwiftUI

struct GameObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
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
                .if(gameObject.hp != nil) { view in
                    view.overlay {
                        ZStack {
                            Gauge(value: current, in: minValue...maxValue) {
                                Image(systemName: "heart")
                                    .foregroundColor(.red)
                            } currentValueLabel: {
                                Text("\(Int(current))")
                                    .foregroundColor(Color.green)
                            } minimumValueLabel: {
                                Text("\(Int(minValue))")
                                    .foregroundColor(Color.green)
                            } maximumValueLabel: {
                                Text("\(Int(maxValue))")
                                    .foregroundColor(Color.red)
                            }
                            .gaugeStyle(.accessoryCircularCapacity)
                            .scaleEffect(0.7)
                        }
                    }

                }
                .scaledToFit()
                .frame(width: gameObjectImageWidth, height: gameObjectImageHeight)
                .position(center.point)
                .rotationEffect(rotation, anchor: center.unitPoint)
                .opacity(viewModel.gameObjectOpacities[gameObject.id, default: .unit])
                .gesture(handleLongPress)
        }
    }

    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleGameObjectRemoval(self)
            }
    }
}
