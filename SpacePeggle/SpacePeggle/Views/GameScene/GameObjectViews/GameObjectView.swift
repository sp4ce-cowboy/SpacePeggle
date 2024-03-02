import SwiftUI

struct GameObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: GameSceneViewModel
    @State private var isSelected = false
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
            // .rotationEffect(rotation, anchor: .center)
            // .scaleEffect(scale, anchor: .center)
            .opacity(viewModel.gameObjectOpacities[gameObject.id, default: 1])
            .onTapGesture { self.isSelected.toggle() }
            .gesture(handleLongPress)
        //  .gesture(handleMagnify.simultaneously(with: handleRotate))

        if isSelected {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(width: gameObjectImageWidth * scale,
                       height: gameObjectImageHeight * scale)
                .position(gameObject.centerPosition.point)
                .overlay(resizerView.position(x: gameObject.centerPosition.point.x + 20,
                                              y: gameObject.centerPosition.point.y + 20)
                         // Position resizer at bottom-right corner
                )
        }

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

    /// Handles magnification.
    ///
    /// All game objects already contain a magnification value within them, and the gesture
    /// magnification scale starts from 1.0 every single time. This means that, from a unit
    /// size of 1.0, an initial magnification of 2.0 will double it. Afterwards, any succesive
    /// magnification of 2.0 will quadruple the initial size. To offset this scaling effect
    var handleMagnify: some Gesture {
        MagnifyGesture()
            .onChanged { _ in
                // Adjust sensitivity
                // let newMagnification = log(gestureScale.magnification) / log(2)
                // print(newMagnification)

                // Calculate new scale based on gesture
                // let newScale = gameObject.magnification * newMagnification

                // Clamp the scale to a maximum of 4x and minimum of 1x
                // let clampedScale = min(max(newScale, 1.0), 4.0)
                // viewModel.handleMagnify(self, scale: clampedScale)

            }
    }

    var resizerView: some View {
        Image(systemName: "arrow.down.right.circle.fill")
            .imageScale(.large)
            .frame(width: 30, height: 30)
            .foregroundColor(.red)
            .opacity(isSelected ? 1 : 0)
            .simultaneousGesture(DragGesture()
                .onChanged { value in

                    let width = gameObjectImageWidth + value.translation.width
                    let height = gameObjectImageHeight + value.translation.height

                    let originalDiagonal = sqrt(pow((gameObjectImageWidth), 2) + pow((gameObjectImageHeight), 2))
                    let newDiagonal = sqrt(pow((width), 2) + pow((height), 2))

                    let newScale = newDiagonal / originalDiagonal
                    let clampedScale = min(max(newScale, 1.0), 4.0)

                    print(clampedScale)
                    viewModel.handleMagnify(self, scale: clampedScale)

                    let center = gameObject.centerPosition // Example center, adjust as needed
                    let startAngle = atan2(value.startLocation.y - center.y, value.startLocation.x - center.x)
                    let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x)
                    let angleDifference = currentAngle - startAngle

                    let rotationAngle = Angle(radians: Double(angleDifference))
                    print(rotationAngle)

                    viewModel.handleRotate(self, angle: rotationAngle)
                })
    }
}
