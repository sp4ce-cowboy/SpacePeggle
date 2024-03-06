import SwiftUI

class LevelSceneViewModel: ObservableObject {
    var sceneController: AppSceneController

    @Published var isLevelDesignerPaused = false
    @Published var isLevelObjectSelected = false
    @Published var currentGameObjectId: UUID?
    @Published var selectedMode: Enums.SelectedMode = .NormalPeg
    @State var options = Options()

    var hasCollided = false
    var levelDesigner: AbstractLevelDesigner = LevelDesigner()

    var geometryState: GeometryProxy

    init(_ geometryState: GeometryProxy, _ sceneController: AppSceneController) {
        self.geometryState = geometryState
        self.sceneController = sceneController
    }

    deinit {
        Logger.log("ViewModel is deinitialized from \(self)", self)
    }

    private func triggerRefresh() {
        DispatchQueue.main.async { self.objectWillChange.send() }
    }

    var levelObjects: [UUID: any GameObject] {
        levelDesigner.levelObjects
    }

    var levelDomain: CGRect {
        levelDesigner.domain
    }

    func handlePause() {
        triggerRefresh()
        isLevelDesignerPaused.toggle()
    }

    func handleReturnButton() {
        triggerRefresh()
        isLevelDesignerPaused.toggle()
    }

    func handleExitButton() {
        triggerRefresh()
        handleReturnButton()
        sceneController.transitionToStartScene()
    }

}

/// This extension adds basic level object management abilities.
extension LevelSceneViewModel {

    func handleAreaTap(in location: CGPoint) {
        triggerRefresh()

        let locationVector = Vector(with: location)
        // var gameObject: any GameObject = NormalPeg(centerPosition: locationVector)
        guard selectedMode != .Remove else {
            levelDesigner.handleObjectRemoval(locationVector)
            return
        }

        let gameObject = ObjectSet.gameObjectCollection[selectedMode]?(locationVector)
                                ?? ObjectSet.defaultGameObject(locationVector)

        levelDesigner.handleObjectAddition(gameObject)
    }

    func handleLevelObjectRemoval(_ object: any GameObject) {
        triggerRefresh()
        Logger.log("LevelObject \(object.id) removed", self)
        levelDesigner.handleObjectRemoval(object)
    }

    func handleLevelObjectMovement(_ object: any GameObject,
                                   with drag: DragGesture.Value) {
        triggerRefresh()
        levelDesigner.handleObjectMovement(object, with: drag, and: &hasCollided)
    }
}

/// This extension adds the ability for the rotation and scaling functionality.
extension LevelSceneViewModel {
    func handleDragGestureChange(_ value: DragGesture.Value, _ levelObject: any GameObject) {
        triggerRefresh()
        levelDesigner.handleObjectResizing(value, levelObject)
    }
}

/// This extension adds the ability to handle functions from the function bar,
/// including file storage and management.
extension LevelSceneViewModel {

    func handleSave() {
        triggerRefresh()
        guard options.isFileNameValid else {
            return
        }
        saveLevel()
        clearEmptyTextFieldAndDismissKeyboard()

    }

    /// Helper function to consolidate the save file sequence of operations
    private func saveLevel() {
        triggerRefresh()
        let name = options.levelNameInput
        let trimmedFileName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let level = Level(name: trimmedFileName, gameObjects: levelDesigner.levelObjects)
        Storage.saveLevel(level, withName: trimmedFileName)
        options.showingSuccessAlert = true
        options.levelNameInput = ""
        options.files = Storage.listSavedFiles() // Update the file list
    }

    /// A helper function to faciliate a more seamless
    /// UX by auto-dimissing the keyboard and text field as needed.
    func clearEmptyTextFieldAndDismissKeyboard() {
        triggerRefresh()
        // Clear out the text field before dismissing the keyboard
        if !options.isFileNameValid {
            options.levelNameInput = ""
        }

        Constants.dismissKeyboard()
    }

    func handleTransitionToGameSceneWithLevel() {
        sceneController.transitionToGameScene(
                                with: Level(name: levelDesigner.levelName,
                                            gameObjects: levelDesigner.levelObjects))
    }

    func handleReset() {
        triggerRefresh()
        levelDesigner.clearLevel()
        clearEmptyTextFieldAndDismissKeyboard()
    }

    func updateLevel(with level: AbstractLevel) {
        triggerRefresh()
        levelDesigner.loadLevel(with: level)
    }

}

/// This extension contains specfically constructed information required to
/// liaise with the Function bar
extension LevelSceneViewModel {

    var showingFileListBinding: Binding<Bool> {
        triggerRefresh()
        return Binding<Bool>(
            get: {
                self.triggerRefresh()
                return self.options.showingFileList
            },
            set: {
                self.triggerRefresh()
                self.options.showingFileList = $0
            }
        )
    }

    var showingSuccessAlertBinding: Binding<Bool> {
        triggerRefresh()
        return Binding<Bool>(
            get: {
                self.triggerRefresh()
                return self.options.showingFileList
            },
            set: {
                self.triggerRefresh()
                self.options.showingFileList = $0
            }
        )
    }

    var showingDeleteAllAlertBinding: Binding<Bool> {
        Binding<Bool>(
            get: {
                self.triggerRefresh()
                return self.options.showingDeleteAllAlert
            },
            set: {
                self.triggerRefresh()
                self.options.showingDeleteAllAlert = $0
            }
        )
    }

    var levelNameInputBinding: Binding<String> {
        triggerRefresh()
        return Binding<String>(
            get: {
                self.triggerRefresh()
                return self.options.levelNameInput
            },
            set: {
                self.triggerRefresh()
                self.options.levelNameInput = $0
            }
        )
    }

    func updateShowingFileListToTrue() {
        triggerRefresh()
        options.showingFileList = true
    }

    func updateShowingFileListToFalse() {
        triggerRefresh()
        options.showingFileList = false
    }

    func updateShowingFileList() {
        triggerRefresh()
        options.showingFileList.toggle()
    }

    func handleLoad() {
        triggerRefresh()
        currentGameObjectId = nil
        options.files = Storage.listSavedFiles()
        clearEmptyTextFieldAndDismissKeyboard()
        options.showingFileList = true
    }

    func handleStart() {
        triggerRefresh()
        clearEmptyTextFieldAndDismissKeyboard()
        // sceneController.transitionToGameScene(with: options.level)
        handleTransitionToGameSceneWithLevel()
    }

    func handleDeleteAllFiles() {
        triggerRefresh()
        Storage.deleteAllFiles(options.files)
        options.files.removeAll()
    }

    /// Helper function to facilitate the swipe to delete functionality
    func deleteSingleFile(at offsets: IndexSet) {
        triggerRefresh()
        // Find files to delete using the offsets
        let filesToDelete = offsets.compactMap { options.files[$0] }

        for fileName in filesToDelete {
            // Construct the URL for the file to delete
            do {
                let folderURL = try Storage.createFolderIfNeeded(folderName: Constants.STORAGE_CONTAINER_NAME)
                let fileURL = folderURL.appendingPathComponent(fileName)
                try FileManager.default.removeItem(at: fileURL)

                // Remove the file name from the internal files array
                options.files.removeAll { $0 == fileName }
                Logger.log("Deleted file: \(fileName)")
            } catch {
                Logger.log("Error deleting file: \(error)")
            }
        }
    }
}

/// This extension adds handling abiities for the function bar
extension LevelSceneViewModel {
    func getCurrentSpecialPeg() -> Enums.SelectedMode {
        switch Constants.UNIVERSAL_POWER_UP {
        case .Kaboom:
            return .KaboomPeg
        case .Spooky:
            return .SpookyPeg
        }
    }
}

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
