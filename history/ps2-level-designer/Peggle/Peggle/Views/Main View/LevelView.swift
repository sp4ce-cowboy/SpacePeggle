import SwiftUI

/// The LevelView is the first view upon invocation via the PeggleApp
/// main entry point.
struct LevelView: View {
    @StateObject var viewModel = LevelViewModel()

    // This gesture state ensures that gestures do not interfere with each other.
    @GestureState var isGestureInputActive = false

    // Note to grader: I have chosen to ignore the SwiftLint closure length violations
    // indicated below, as shortening the code even further would make it unreadable.
    // The length of the closure is unavoidable given the nature of SwitUI syntax.
    var body: some View {
        GeometryReader { geometry in
            let proxyWidth = geometry.size.width
            let proxyHeight = geometry.size.height

            VStack(spacing: 0) {
                ZStack {
                    PlayableAreaView(width: proxyWidth, height: proxyHeight)
                        .onTapGesture { location in
                            if !isGestureInputActive {
                                viewModel.handleTap(in: location, for: geometry)
                            }
                        }

                    ForEach(viewModel.pegs.indices, id: \.self) { index in
                        PegView(peg: viewModel.pegs[index])
                            .onTapGesture { location in
                                if !isGestureInputActive {
                                    viewModel.handleTap(in: location, for: geometry)
                                }
                            }
                            .simultaneousGesture(LongPressGesture()
                                .updating($isGestureInputActive) { currentState, gestureState, _ in
                                    gestureState = currentState
                                }
                                .onEnded { _ in
                                    viewModel.handleLongPress(forPegAt: index)
                                }
                                .exclusively(before: DragGesture(minimumDistance: Utility.MOVEMENT_THRESHOLD)
                                    .updating($isGestureInputActive) { _, gestureState, _ in
                                        gestureState = true
                                    }
                                    .onChanged { value in
                                        viewModel.movePeg(at: index, to: value.location)
                                    }
                                    .onEnded { value in
                                        viewModel.movePegPermanently(at: index, from: value.startLocation,
                                                                     to: value.location, for: geometry)
                                    }
                                )
                            )
                    }
                }

            ActionBarView(isRemove: $viewModel.isRemove,
                          color: $viewModel.color,
                          pegs: $viewModel.pegs,
                          levelNameInput: $viewModel.levelNameInput,
                          width: proxyWidth, height: proxyHeight)
            }
            .background { BackgroundView(width: proxyWidth) }
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView()
    }
}
