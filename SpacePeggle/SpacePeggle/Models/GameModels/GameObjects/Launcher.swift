import SwiftUI
import Foundation

/// The launcher model models the cannon launcher itself, and defines the layout 
/// of the launcher
class Launcher {
    var id = UUID()
    var centerPosition: Vector

    /// Launcher height is needed to establish a proper positioning system.
    /// Launcher height has both mathematical value important to the Launcher model
    /// and visual value important to the View renderer. In order to decouple these,
    /// the height is externally established within the universal game object set.
    let launcherHeight: Double =
    Double(ObjectSet.defaultGameObjectSet["Launcher"]?.size.height ?? CGFloat(Constants.UNIVERSAL_LENGTH))

    private let maxAngle = Angle(degrees: 89.0)
    private let minAngle = Angle(degrees: -89.0)
    private(set) var rotationAngle = Angle(degrees: .zero)
    private(set) var launcherVelocity: Double // Allows for custom launch values.

    var launchVelocityVector: Vector { Vector(magnitude: launcherVelocity, angle: rotationAngle) }

    var launcherTipPosition: Vector {
        let hypotenuse = launcherHeight.half
        return Vector(x: centerPosition.x + (hypotenuse * sin(rotationAngle.radians)),
                      y: centerPosition.y + (hypotenuse * cos(rotationAngle.radians)))
    }

    var getadjustedRotationAngle: Angle {
        Angle(radians: atan((tan(rotationAngle.radians)).twice))
    }

    init(layoutSize: CGSize,
         rotationAngle: Angle = Angle(degrees: .zero),
         launcherVelocity: Double = Constants.UNIVERSAL_LAUNCH_FORCE) {

        self.rotationAngle = rotationAngle
        self.launcherVelocity = launcherVelocity
        self.centerPosition = Vector(x: layoutSize.width.half, y: launcherHeight.half)
    }

    // Internal method to safely set the angle
    func setRotationAngle(to angle: Angle) {
        guard angle <= maxAngle && minAngle <= angle else {
            return
        }
        rotationAngle = angle
    }

    func updateRotation(with dragValue: DragGesture.Value, for size: CGSize) {
        let center = CGPoint(x: size.width.half, y: size.height.half)
        // let tip = CGPoint(x: launcherTipPosition.x, y: launcherTipPosition.y)
        let start = dragValue.startLocation
        let current = dragValue.location
        var newAngle = calculateAngle(center: center, start: start, current: current)

        let xDirectionIsNegative = (dragValue.location.x - centerPosition.x) < 0
        let yDirectionIsNegative = (dragValue.location.y - centerPosition.y) < 0

        if xDirectionIsNegative && !yDirectionIsNegative {
            newAngle = max(newAngle, minAngle)
            setRotationAngle(to: newAngle)
        }

        if !xDirectionIsNegative {
            newAngle = min(newAngle, maxAngle)
            setRotationAngle(to: newAngle)
        }

        // newAngle = max(min(newAngle, maxAngle), minAngle)
        // setRotationAngle(to: newAngle)

    }

    private func calculateAngle(center: CGPoint, start: CGPoint, current: CGPoint) -> Angle {
        let startAngle = atan2(start.y - center.y, start.x - center.x)
        let currentAngle = atan2(current.y - center.y, current.x - center.x)
        let rotationAngle = Angle(radians: (startAngle - currentAngle))
        return rotationAngle
    }
}
