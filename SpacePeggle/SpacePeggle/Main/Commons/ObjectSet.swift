import Foundation

/// The universal game object set determinant. This can allow for setting custom themes
/// and handles all liasion with visual representation. A NormalPeg can look like a GoalPeg, a
/// cannon, or a crocodile. The Game logic will function the same. Each image can also
/// specify its own width and height set, which the renderer can choose to implement
/// or override.
///
/// At the moment, all size specifications are standardized, but this is an extensible
/// implementation to allow customizing game objects
class ObjectSet {

    /// For cases where images can go missing. The Peggle app icon nicely serves this purposes.
    static let DEFAULT_IMAGE_STUB: String = "peggle"

    static var currentBackground: String = "background"

    static let CONSTANT_SIZE = CGSize(width: Constants.UNIVERSAL_LENGTH,
                                      height: Constants.UNIVERSAL_LENGTH)

    /// A dictionary of gameObjectTypes and their corresponding visual imagery.
    /// The keys represent the gameObjectTypes as Strings, and the values represent
    /// the images that they correspond to. This can very easily be converted to
    /// a discrete class of its own if custom GameObject sets are needed.
    ///
    /// Inside each value, there is a triplet consisting of an image name, a width and a height.
    /// This use case is better than an enum as dictionaries conform better to OCP and thus,
    /// cyclomatic complexity is reduced as dictionaries are more scalable.
    ///
    /// Note that the while primarily used to specify gameObjectTypes for GameObjects, the
    /// real purpose of this class is to liaise with the Renderer in rendering UI elements
    /// together with the corresponding images. Thus, images for ball and cannon are also
    /// included, even though they are not gameObjectTypes.
    private(set) static var defaultGameObjectSet: [String: (name: String, size: CGSize)] = [
        "NormalPeg": ("peg-blue", CONSTANT_SIZE),
        "DefaultPeg": ("peg-blue", CONSTANT_SIZE),
        "GoalPeg": ("peg-orange", CONSTANT_SIZE),
        "NormalPegActive": ("peg-blue-glow", CONSTANT_SIZE),
        "GoalPegActive": ("peg-orange-glow", CONSTANT_SIZE),
        "Ball": ("ball", CONSTANT_SIZE),
        "Launcher": ("cannon", CGSize(width: Constants.UNIVERSAL_LAUNCHER_HEIGHT,
                                      height: Constants.UNIVERSAL_LAUNCHER_HEIGHT)),
        "LauncherActive": ("active-cannon", CGSize(width: Constants.UNIVERSAL_LAUNCHER_HEIGHT,
                                                   height: Constants.UNIVERSAL_LAUNCHER_HEIGHT)),
        "SpookyPeg": ("peg-green", CONSTANT_SIZE),
        "SpookyPegActive": ("peg-green-glow", CONSTANT_SIZE),
        "KaboomPeg": ("peg-purple", CONSTANT_SIZE),
        "KaboomPegActive": ("peg-purple-glow", CONSTANT_SIZE),
        "StubbornPeg": ("delete", CONSTANT_SIZE),
        "StubbornPegActive": ("delete", CONSTANT_SIZE),
        "Remove": ("delete", CONSTANT_SIZE),
        "BlockPeg": ("block", CONSTANT_SIZE),

        /// Pre-defined ratio according to actual dimensional ratio of the image used
        "Bucket": ("bucket-square", CGSize(width: Constants.UNIVERSAL_LAUNCHER_HEIGHT * 3.0,
                                           height: Constants.UNIVERSAL_LAUNCHER_HEIGHT))
    ]

    /// A dictionary of available game objects and closures that create default instances
    static var gameObjectCollection: [Enums.SelectedMode: (Vector) -> any GameObject] = [
        .NormalPeg: { center in NormalPeg(centerPosition: center) },
        .GoalPeg: { center in GoalPeg(centerPosition: center) },
        .BlockPeg: { center in BlockPeg(centerPosition: center) },
        .SpookyPeg: { center in SpookyPeg(centerPosition: center) },
        .KaboomPeg: { center in KaboomPeg(centerPosition: center) },
        .StubbonPeg: { center in StubbornPeg(centerPosition: center) }
    ]

    /// A dictionary of available game objects and closures that create them
    static var gameObjectCreation: [Enums.SelectedMode: (Vector) -> any GameObject] = [
        .NormalPeg: { center in NormalPeg(centerPosition: center) },
        .GoalPeg: { center in GoalPeg(centerPosition: center) },
        .BlockPeg: { center in BlockPeg(centerPosition: center) },
        .SpookyPeg: { center in SpookyPeg(centerPosition: center) },
        .KaboomPeg: { center in KaboomPeg(centerPosition: center) },
        .StubbonPeg: { center in StubbornPeg(centerPosition: center) }
    ]

    /*/// A dictionary of available game objects and closures that execute an action
     /// on a scoreboard
     static var gameObjectProcessing: [Enums.GameObjectType: () -> ScoreBoard] = [
     .NormalPeg: { scores.clearedNormalPegsCount += 1 },
     .GoalPeg: { scores.clearedGoalPegsCount +=1 },
     .NormalPegActive: { scores.clearedNormalPegsCount += 1 },
     .GoalPegActive: { scores.clearedGoalPegsCount +=1 }
     ]*/

    /// A dictionary of available game objects and closures that create full instances
    static var fullGameObjectCreation: [Enums.GameObjectType: (Vector, UUID, UniversalShape) -> any GameObject] = [
        .NormalPeg: { center, id, shape in NormalPeg(centerPosition: center, id: id, shape: shape) },
        .GoalPeg: { center, id, shape in GoalPeg(centerPosition: center, id: id, shape: shape) },
        .SpookyPeg: { center, id, shape in SpookyPeg(centerPosition: center, id: id, shape: shape) },
        .KaboomPeg: { center, id, shape in KaboomPeg(centerPosition: center, id: id, shape: shape) },
        .BlockPeg: { center, id, shape in BlockPeg(centerPosition: center, id: id, shape: shape) },
        .StubbornPeg: { center, id, shape in BlockPeg(centerPosition: center, id: id, shape: shape) }
    ]

    static var fullShapeCreation: [Enums.ShapeType: (Double, Double, Double, Double) -> any UniversalShape] = [
        .circle: { height, _, angle, scale in
            CircularShape(diameter: height, rotation: angle, scale: scale)},
        .rectangle: { height, width, angle, scale in
            RectangularShape(height: height, width: width, rotation: angle, scale: scale)}
    ]

    /// Returns a closure that takes in a vector and creates a default game object.
    static var defaultGameObject: (Vector) -> any GameObject = { center in NormalPeg(centerPosition: center) }

    /// The physics object set is essentially exactly the same as the default game object set
    /// for this problem set and most cases. However, having them separated ensures that the
    /// physics shape of a physics object is not dependent on the visual shape of an object.
    /// This means that theoretically, it would be possible to have a circular object that
    /// looks like a circle but acts like a bigger circle for e.g. a scenario where Pegs have
    /// a field around them that repel balls such that collisions occur on a large circular
    /// imprint or something.
    ///
    /// The image name is also retained if a custom physics shape is to be generated
    /// (from let's say, a vector or raster image file)
    private(set) static var defaultPhysicsObjectSet: [String: (name: String, size: CGSize)] = [
        "NormalPeg": ("peg-blue", CONSTANT_SIZE),
        "DefaultPeg": ("peg-blue", CONSTANT_SIZE),
        "GoalPeg": ("peg-orange", CONSTANT_SIZE),
        "NormalPegActive": ("peg-blue-glow", CONSTANT_SIZE),
        "GoalPegActive": ("peg-orange-glow", CONSTANT_SIZE),
        "Ball": ("ball", CONSTANT_SIZE),
        "SpookyPeg": ("peg-green", CONSTANT_SIZE),
        "SpookyPegActive": ("peg-green-glow", CONSTANT_SIZE),
        "KaboomPeg": ("delete", CONSTANT_SIZE),
        "KaboomPegActive": ("delete", CONSTANT_SIZE),
        "StubbornPeg": ("delete", CONSTANT_SIZE),
        "StubbornPegActive": ("delete", CONSTANT_SIZE),
        "BlockPeg": ("block", CONSTANT_SIZE)
    ]

    // GameObjectSet related function, can be replicated for PhysicsObjectSet as well.

    /// This static func allows for more gameObjectTypes to be added into the game,
    /// which can be done so via the App's entry point. With set stubs, this can be
    /// used to configure a unified visual representation for all gameObjects, for
    /// example, using a different image set for different game themes.
    static func setGameObjectSet(to objectSet: [String: (String, CGSize)]) {
        assert(validateGameObjectSet(objectSet: objectSet))
        ObjectSet.defaultGameObjectSet = objectSet
    }

    /// Returns all the available keys for the current gameObjectSet
    static func getAvailableGameObjects() {
        print(ObjectSet.defaultGameObjectSet.keys)
    }

    /// A function to add game objects to the defined GameObjectSet, and this helps to explicitly
    /// allow adding more GameObjects. Existing game objects can also be overridden.
    static func addToGameObjectSet(gameObjectName: String,
                                   gameObjectImageName: String,
                                   gameObjectRenderSize: CGSize) {

        ObjectSet.defaultGameObjectSet[gameObjectName] = (gameObjectImageName,
                                                          gameObjectRenderSize)
    }

    /// Placeholder validation, can be used to implement level checking if
    /// custom themes or image sets are to be implemented. Can be used to ensure
    /// that no game objects are riduculously sized, etc.
    private static func validateGameObjectSet(objectSet: [String: (String, CGSize)]) -> Bool {
        true
    }
}
