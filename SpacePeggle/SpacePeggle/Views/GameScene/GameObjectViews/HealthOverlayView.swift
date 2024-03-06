import SwiftUI

struct HealthOverlayView: View {
    @EnvironmentObject var viewModel: LevelSceneViewModel
    var levelObject: any GameObject
    var center: Vector { levelObject.centerPosition }

    var current: Double { Double(levelObject.hp) }
    var minValue: Double { viewModel.minHpValue }
    var maxValue: Double { viewModel.maxHpValue }

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
