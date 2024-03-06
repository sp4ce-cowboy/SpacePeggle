import SwiftUI

struct LevelObjectView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: LevelSceneViewModel
    var levelObject: any GameObject

    var isSelected: Bool { viewModel.currentResizingGameObject == levelObject.id }
    var currentGameObject: UUID? { viewModel.currentResizingGameObject }
    var rotation: Angle { levelObject.rotation }
    var center: Vector { levelObject.centerPosition }

    var levelObjectType: String { levelObject.gameObjectType.rawValue }
    var levelObjectImageHeight: Double { levelObject.height }
    var levelObjectImageWidth: Double { levelObject.width }
    var levelObjectImage: String {
        ObjectSet.defaultGameObjectSet[levelObjectType]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB
    }

    var current: Double { Double(levelObject.hp) }
    var minValue: Double { Double(0) }
    var maxValue: Double { Double(10) }
    @State var isTapped = false

    var body: some View {
        ZStack(alignment: .center) {
            Image(levelObjectImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .if(isTapped) { view in
                    view.overlay(HealthOverlayView(levelObject: levelObject))
                        .environmentObject(viewModel)
                }
                .scaledToFit()
                .frame(width: levelObjectImageWidth, height: levelObjectImageHeight)
                .position(center.point)
                .rotationEffect(rotation, anchor: center.unitPoint)
            // .onTapGesture { handleTap() }
                .onTapGesture(count: 2) { isTapped.toggle() }
                .gesture(TapGesture().onEnded { _ in handleTap() })
                .simultaneousGesture(handleLongPress.exclusively(before: handleDrag))
                .if(isSelected) { view in
                    view.overlay(LevelObjectResizerView(levelObject: levelObject))
                        .environmentObject(viewModel)
                }
                .if(viewModel.isLevelDesignerPaused) { view in
                    view.disabled(true)
                }
        }
    }

    // if isSelected { getResizerView }

    private func handleTap() {
        if viewModel.selectedMode == .Remove {
            viewModel.handleLevelObjectRemoval(levelObject)
        } else {
            handleEditTap()
        }
    }

    private func handleEditTap() {
        if isSelected {
            viewModel.currentResizingGameObject = nil
        } else {
            viewModel.currentResizingGameObject = levelObject.id
        }
    }

    private func handleDoubleTap() {
        if isSelected {
            viewModel.currentResizingGameObject = nil
        } else {
            viewModel.currentResizingGameObject = levelObject.id
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
            .onEnded { value in
                viewModel.handleLevelObjectMovement(levelObject, with: value)
            }
    }
}
