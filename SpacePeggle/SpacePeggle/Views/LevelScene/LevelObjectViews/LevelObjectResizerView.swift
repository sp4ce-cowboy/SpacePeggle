import SwiftUI

struct LevelObjectResizerView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel
    var levelObject: any GameObject

    var levelObjectImageHeight: Double { levelObject.height }
    var levelObjectImageWidth: Double { levelObject.width }
    var rotation: Angle { levelObject.rotation }
    var center: Vector { levelObject.centerPosition }

    var body: some View {
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
            .frame(width: Constants.UNIVERSAL_LENGTH,
                   height: Constants.UNIVERSAL_LENGTH)
            .position(x: center.x + (levelObjectImageWidth).half,
                      y: center.y + (levelObjectImageHeight).half)
            .rotationEffect(rotation, anchor: center.unitPoint)
            .foregroundColor(.red)
            .gesture(DragGesture()
                .onChanged { value in
                    viewModel.handleDragGestureChange(value, levelObject)
                })
    }
}
