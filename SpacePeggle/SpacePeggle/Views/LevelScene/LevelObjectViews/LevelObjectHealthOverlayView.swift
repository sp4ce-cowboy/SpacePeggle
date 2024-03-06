import SwiftUI

struct LevelObjectHealthOverlayView: View {
    /// Despite its non-usage, having the viewModel here is important to
    /// allow for the view to refresh and redraw every time the viewModel is
    /// refreshed.
    @EnvironmentObject var viewModel: LevelSceneViewModel
    var levelObject: any GameObject
    var current: Double { Double(levelObject.hp) }
    var minValue: Double { Double(Constants.MIN_HP_VALUE) }
    var maxValue: Double { Double(Constants.MAX_HP_VALUE) }

    var body: some View {
        ZStack {
            Gauge(value: current, in: minValue...maxValue) {
                Image(systemName: "heart")
                    .foregroundStyle(Color.red)
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundStyle(Color.green)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .foregroundStyle(Color.green)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .foregroundStyle(Color.red)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .scaleEffect(0.6)
        }
    }
}
