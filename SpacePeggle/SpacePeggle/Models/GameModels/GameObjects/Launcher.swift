import SwiftUI
import Foundation

/// The launcher model models the cannon launcher itself, and defines the layout 
/// of the launcher
class Launcher: UniversalObject {
    var id = UUID()
    var centerPosition: Vector

    /// Launcher height is needed to establish a proper positioning system.
    /// Launcher height has both mathematical value important to the Launcher model
    /// and visual value important to the View renderer. In order to decouple these,
    /// the height is externally established within the universal game object set.
    let launcherHeight: Double =
    Double(ObjectSet.defaultGameObjectSet["Launcher"]?.size.height ?? CGFloat(Constants.UNIVERSAL_LENGTH))

    let maxAngle = Angle(degrees: 89.0)
    let minAngle = Angle(degrees: -89.0)
    var rotationAngle = Angle(degrees: 0.0)
    var launcherVelocity: Double
    var launcherVelocityVector: Vector {
        Vector(magnitude: launcherVelocity, angle: rotationAngle)
    }
    var launcherBasePosition: Vector {
        Vector(x: centerPosition.x, y: centerPosition.y - launcherHeight / 2.0)
    }

    var launcherTipPosition: Vector {
        let hypotenuse = launcherHeight / 2.0
        return Vector(x: centerPosition.x + (hypotenuse * sin(rotationAngle.radians)),
                      y: centerPosition.y + (hypotenuse * cos(rotationAngle.radians)))
    }

    var getadjustedRotationAngle: Angle {
        Angle(radians: atan((tan(rotationAngle.radians)) * 2))
    }

    init(layoutSize: CGSize,
         rotationAngle: Angle = Angle(degrees: 0.0),
         launcherVelocity: Double = Constants.UNIVERSAL_LAUNCH_FORCE) {

        self.rotationAngle = rotationAngle
        self.launcherVelocity = launcherVelocity
        self.centerPosition = Vector(x: layoutSize.width / 2, y: launcherHeight / 2)
    }

    func setRotationAngle(to angle: Angle) {
        rotationAngle = angle
    }

    func updateRotation(with dragValue: DragGesture.Value, for size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
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
