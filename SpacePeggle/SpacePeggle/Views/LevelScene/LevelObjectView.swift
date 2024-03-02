import SwiftUI

struct LevelObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: LevelSceneViewModel
    @State var isSelected = false

    var levelObject: any GameObject

    var rotation: Angle { levelObject.rotation }
    var scale: Double { levelObject.scale }
    var center: CGPoint { levelObject.centerPosition.point}
    var levelObjectType: String { levelObject.gameObjectType }
    var levelObjectImageHeight: Double { levelObject.height }
    var levelObjectImageWidth: Double { levelObject.width }

    var levelObjectImage: String {
        ObjectSet.defaultGameObjectSet[levelObjectType]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var body: some View {
        ZStack {
            Image(levelObjectImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: levelObjectImageWidth, height: levelObjectImageHeight)
                .position(center)
                .rotationEffect(rotation, anchor: .center)
                .onTapGesture { self.isSelected.toggle() }
                .onLongPressGesture { viewModel.handleLevelObjectLongPress(self) }
            //  .gesture(handleMagnify.simultaneously(with: handleRotate))

            if isSelected {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    .frame(width: levelObjectImageWidth * scale,
                           height: levelObjectImageHeight * scale)
                    .position(center)
                    .rotationEffect(rotation, anchor: .center)
                    .overlay(resizerIconView
                        .position(x: center.x + (levelObjectImageWidth * scale).half,
                                  y: center.y + (levelObjectImageHeight * scale).half)
                            .rotationEffect(rotation, anchor: .center)
                    )
            }
        }

    }

    var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleLevelObjectLongPress(self)
            }
    }

    var handleRotate: some Gesture {
        RotateGesture()
            .onChanged { angle in
                viewModel.handleLevelObjectRotation(self, angle: angle.rotation)
            }
    }

    var handleMagnification: some Gesture {
        MagnifyGesture()
            .onChanged { scale in
                viewModel.handleLevelObjectMagnification(self, scale: scale.magnification)
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
                // let newScale = levelObject.magnification * newMagnification

                // Clamp the scale to a maximum of 4x and minimum of 1x
                // let clampedScale = min(max(newScale, 1.0), 4.0)
                // viewModel.handleMagnify(self, scale: clampedScale)

            }
    }

    /// The resizer view represents the corner of the size adjustment box.
    var resizerIconView: some View {
        Image(systemName: "arrow.down.right.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
            .foregroundColor(.red)
            .opacity(isSelected ? 1 : 0)
            .gesture(DragGesture()
                .onChanged { value in

                    let width = levelObjectImageWidth + value.translation.width
                    let height = levelObjectImageHeight + value.translation.height

                    let originalDiagonal = sqrt(pow((levelObjectImageWidth), 2) + pow((levelObjectImageHeight), 2))
                    let newDiagonal = sqrt(pow((width), 2) + pow((height), 2))

                    let newScale = newDiagonal / originalDiagonal
                    let clampedScale = min(max(newScale, 1.0), 4.0)

                    Logger.log("New scale is \(clampedScale)", self)

                    viewModel.handleLevelObjectMagnification(self, scale: clampedScale)

                    let center = levelObject.centerPosition // Example center, adjust as needed
                    let startAngle = atan2(value.startLocation.y - center.y, value.startLocation.x - center.x)
                    let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x)
                    let angleDifference = currentAngle - startAngle

                    let rotationAngle = Angle(radians: Double(angleDifference))

                    viewModel.handleLevelObjectRotation(self, angle: rotationAngle)
                })
    }
}
