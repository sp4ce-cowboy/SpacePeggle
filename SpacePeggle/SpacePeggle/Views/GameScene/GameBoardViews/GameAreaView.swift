import SwiftUI

/// This View presents a transparent, rectangular overlay that can
/// defining the bounds for the gameplay area independently of other views.
///
/// The GameAreaView can be individually modified to fit within a particular
/// aspect ratio, or can follow the aspect ratio specified by the parent
/// geometry.
struct GameAreaView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var size: CGSize {
        viewModel.geometryState.size
    }

    var width: Double {
        size.width
    }
    var height: Double {
        size.height
    }

    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            // .padding()
            .frame(width: width, height: height)
            .contentShape(Rectangle())
            .onAppear {
                Logger.log("Game Area size is \(size)", self)
            }
    }
}
