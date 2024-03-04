import SwiftUI

struct LauncherStubView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel

    var screenWidthCenter: Double { Constants.UI_SCREEN_WIDTH.half }
    var launcherHeightCenter: Double { launcherHeight.half }

    var launcherWidth = Double(ObjectSet
        .defaultGameObjectSet["Launcher"]?.size.width ?? CGFloat(Constants.UNIVERSAL_LENGTH))

    var launcherHeight = Double(ObjectSet
        .defaultGameObjectSet["Launcher"]?.size.height ?? CGFloat(Constants.UNIVERSAL_LENGTH))

    var inactiveLauncherImageName = ObjectSet
        .defaultGameObjectSet["Launcher"]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB

    var body: some View {
        ZStack {
            Image(inactiveLauncherImageName)
                .resizable()
                .frame(width: launcherWidth, height: launcherHeight)
                .position(x: screenWidthCenter, y: launcherHeightCenter)
                .opacity(0.5)
        }
    }
}
