import SwiftUI

/// This extension adds the ability to handle modifications to hit points of objects
extension LevelSceneViewModel {

    var minHpValue: Double {
        Double(Constants.MIN_HP_VALUE)
    }

    var maxHpValue: Double {
        Double(Constants.MAX_HP_VALUE)
    }

    func updateCurrentGameObjectId(_ view: LevelObjectView) {
        currentGameObjectId = view.levelObject.id
    }

    func isSelected(_ view: LevelObjectView) -> Bool {
        triggerRefresh()
        return currentGameObjectId == view.levelObject.id
    }

    func isDisplayHpOverlay(_ view: LevelObjectView) -> Bool {
        triggerRefresh()
        switch view.levelObject.gameObjectType {
        case .BlockPeg, .StubbornPeg:
            return false
        default:
            break
        }

        return isSelected(view) || view.levelObject.hp > 1
    }

    func handleIncrement() {
        triggerRefresh()
        Logger.log("Increment handled", self)
        if let currentObjectId = currentGameObjectId {
            levelDesigner.updateObjectHitPoints(withId: currentObjectId,
                                                and: .unit)
        }
    }

    func handleDecrement() {
        triggerRefresh()
        if let currentObjectId = currentGameObjectId {
            levelDesigner.updateObjectHitPoints(withId: currentObjectId,
                                                and: .negativeUnit)
        }
    }

    // Helper function to determine the opacity of a button
    func getOpacity(for button: Enums.SelectedMode) -> Double {
        selectedMode == button ? StyleSheet.FULL_OPACITY : StyleSheet.HALF_OPACITY
    }

    // Helper function to determine the opacity of HP modifiers
    func getHpOpacity() -> Double {
        if let currentId = currentGameObjectId {
            return levelDesigner.getOpacity(for: currentId)
        }
        return StyleSheet.HALF_OPACITY
    }

    // Helper function to determine the image name based on the selected object's type.
    func buttonImage(for buttonName: Enums.SelectedMode) -> some View {
        let imageName = ObjectSet
            .defaultGameObjectSet[buttonName.rawValue]?.name ?? ObjectSet.DEFAULT_IMAGE_STUB

        let DIAMETER = Constants.UNIVERSAL_LENGTH * 1.3

        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: DIAMETER, height: DIAMETER)
    }

    /// Allows for the hp buttons to be disabled when inactive
    func isButtonDisabled() -> Bool {
        self.getHpOpacity() == StyleSheet.HALF_OPACITY
    }
}
