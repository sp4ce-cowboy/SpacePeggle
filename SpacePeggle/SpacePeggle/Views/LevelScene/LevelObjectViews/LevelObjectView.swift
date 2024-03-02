import SwiftUI

struct LevelObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: LevelSceneViewModel
    var levelObject: any GameObject

    var isSelected: Bool { viewModel.currentGameObject == levelObject.id }
    var currentGameObject: UUID? { viewModel.currentGameObject }
    var rotation: Angle { levelObject.rotation }
    var center: Vector { levelObject.centerPosition }

    var levelObjectType: String { levelObject.gameObjectType }
    var levelObjectImageHeight: Double { levelObject.height }
    var levelObjectImageWidth: Double { levelObject.width }
    var levelObjectImage: String {
        ObjectSet.defaultGameObjectSet[levelObjectType]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var body: some View {
        ZStack(alignment: .center) {
            Image(levelObjectImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: levelObjectImageWidth, height: levelObjectImageHeight)
                .position(center.point)
                .rotationEffect(rotation, anchor: center.unitPoint)
                .onTapGesture { handleTap() }
                // .onLongPressGesture { viewModel.handleLevelObjectRemoval(levelObject) }
                .simultaneousGesture(handleLongPress.exclusively(before: handleDrag))
                .if(isSelected) { view in
                    view.overlay(getResizerView)
                }

            // if isSelected { getResizerView }
        }

    }

    private func handleTap() {
        if viewModel.selectedMode == .Remove {
            viewModel.handleLevelObjectRemoval(levelObject)
        } else {
            handleEditTap()
        }
    }

    private func handleEditTap() {
        if isSelected {
            viewModel.currentGameObject = nil
        } else {
            viewModel.currentGameObject = levelObject.id
        }
    }

    private var handleLongPress: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                viewModel.handleLevelObjectRemoval(levelObject)
            }
    }

    private var handleDrag: some Gesture {
        DragGesture(minimumDistance: Constants.MOVEMENT_THRESHOLD)
            .onChanged { value in
                viewModel.handleLevelObjectMovement(levelObject, with: value)
            }
    }

    private var getResizerView: some View {
        ZStack {
            getResizerViewOverlay
            getResizerViewIcon
        }
    }

    private var getResizerViewOverlay: some View {
        Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
            .frame(width: levelObjectImageWidth,
                   height: levelObjectImageHeight)
            .position(center.point)
            .rotationEffect(rotation, anchor: center.unitPoint)
    }

    /// The resizer view represents the corner of the size adjustment box.
    private var getResizerViewIcon: some View {
        Image(systemName: "arrow.down.right.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
            .position(x: center.x + (levelObjectImageWidth).half,
                      y: center.y + (levelObjectImageHeight).half)
            .rotationEffect(rotation, anchor: center.unitPoint)
            .foregroundColor(.red)
            .opacity(isSelected ? 1 : 0)
            .gesture(DragGesture().onChanged(handleDragGestureChange))
            .if(viewModel.isLevelDesignerPaused) { view in
                view.disabled(true)
            }
    }

    private func handleDragGestureChange(_ value: DragGesture.Value) {
        let width = levelObject.trueWidth + value.translation.width
        let height = levelObject.trueHeight + value.translation.height

        let newScale = calculateNewScale(width: width, height: height)
        Logger.log("New scale is \(newScale)", self)
        viewModel.handleLevelObjectMagnification(levelObject, scale: newScale)

        let rotationAngle = calculateRotationAngle(from: value)
        Logger.log("Rotation angle is \(rotationAngle)", self)
        viewModel.handleLevelObjectRotation(levelObject, angle: rotationAngle)
    }

    private func calculateNewScale(width: CGFloat, height: CGFloat) -> Double {
        let originalDiagonal = sqrt(pow(levelObject.trueHeight, 2) + pow(levelObject.trueWidth, 2))
        let newDiagonal = sqrt(pow(width, 2) + pow(height, 2))
        return min(max(newDiagonal / originalDiagonal, 1.0), 4.0)
    }

    private func calculateRotationAngle(from value: DragGesture.Value) -> Angle {
        let center = levelObject.centerPosition // Assuming this is a CGPoint
        let startAngle = atan2(value.startLocation.y - center.y, value.startLocation.x - center.x)
        let currentAngle = atan2(value.location.y - center.y, value.location.x - center.x)
        let angleDifference = currentAngle - startAngle
        return Angle(radians: Double(angleDifference))
    }
}
