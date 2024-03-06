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
                    .foregroundColor(.red)
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundColor(Color.green)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .foregroundColor(Color.green)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .foregroundColor(Color.red)
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .scaleEffect(0.8, anchor: center.unitPoint)
        }
    }
}
