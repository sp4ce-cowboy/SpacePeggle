import SwiftUI

/// This View presents a transparent, rectangular overlay that can
/// defining the bounds for the gameplay area independently of other views.
///
/// For Problem Set 3 this is a stub, as no GameLoading is required.
struct GameAreaView: View {
    @EnvironmentObject var viewModel: MainViewModel

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
            .padding()
            .frame(width: width, height: height)
            .ignoresSafeArea()
            .contentShape(Rectangle())
    }
}
