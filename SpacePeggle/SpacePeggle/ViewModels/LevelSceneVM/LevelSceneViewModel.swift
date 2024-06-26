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

    func triggerRefresh() {
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

    func handleUpdatePresented() {
        triggerRefresh()
        options.isPresented = false
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

    var deletionAlertTitle: String { "Confirm Deletion" }
    var deletionAlertMessage: String { "Are you sure you want to delete all files? This action cannot be undone." }
    var deletionAlertButtonText: String { "Delete All" }

    var saveAlertTitle: String {"Level Saved"}
    var saveAlertMessage: String {"Level successfully saved"}
    var saveAlertButtonText: String {"OK"}

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

    func updateDeleteAllAlertToFalse() {
        triggerRefresh()
        options.showingDeleteAllAlert = false
    }

    func updateDeleteAllAlertToTrue() {
        triggerRefresh()
        options.showingDeleteAllAlert = true
    }

    func handleLoad() {
        triggerRefresh()
        currentGameObjectId = nil
        options.files = Storage.listSavedFiles()
        clearEmptyTextFieldAndDismissKeyboard()
        updateShowingFileListToTrue()
    }

    func isStartEnabled() -> Bool {
        !levelDesigner.levelIsEmpty
    }

    func handleStart() {
        triggerRefresh()
        clearEmptyTextFieldAndDismissKeyboard()
        // sceneController.transitionToGameScene(with: options.level)
        handleTransitionToGameSceneWithLevel()
    }

    func handleDeleteAllFiles() {
        triggerRefresh()
        options.showingDeleteAllAlert = false
        Storage.deleteAllFiles(options.files)
        options.files.removeAll()
        // updateShowingFileListToFalse()
    }

    /// Helper function to facilitate the swipe to delete functionality.
    /// The communication required between the VM's encapsulated file list and the
    /// actual file storage means that while normally this would be inside the Storage Model
    /// it makes sense to make this exception in the interest of hiding VM implementation details
    /// from a model
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

    func getNormalPegCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().normalPegCount
    }

    func getGoalPegCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().goalPegCount
    }

    func getSpookyPegCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().spookyPegCount
    }

    func getKaboomPegCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().kaboomPegCount
    }

    func getBlockCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().blockCount
    }

    func getStubbornPegCount() -> Int {
        triggerRefresh()
        return levelDesigner.getCounter().stubbornPegCount
    }

    func getSpecialPegCount() -> Int {
        triggerRefresh()
        switch getCurrentSpecialPeg() {
        case .KaboomPeg:
            return getKaboomPegCount()
        case .SpookyPeg:
            return getSpookyPegCount()
        default:
            return 0
        }
    }

}
