# Developer Guide
## Overview
This developer guide contains all relevant information for the CS3217 Problem Set 3, which entails implementing the Peggle gameplay mechanics, including the Physics Engine and the Game Engine. This developer guide contains both the answers for the relevant questions in Problem Set 3 as well as some other general information that would be useful to someone trying to understand the code base.

1. Gameplay Engine Overview
2. Architecture
3. Implementation
4. Code Organization
5. Design Considerations
6. Usage Instructions & Test Plan

My code is mostly well-documented, and this DG is partly meant to be a read alongside the code itself.

## 1. Peggle Gameplay
### Project Overview

**Project Name:** “PeggleGameplay”
**Project Tech Stack:** Swift, SwiftUI
**Application Display Name:** “Peggle” (AppIcon sourced from [here]())
**Supported Destinations: iPad only** 
**Minimum deployments:** iOS 17.0
- Some gestures require minimum iOS 17.0
**Supported iPads:** All iPads that can run iOS 17.0 as shown [here]()
**Supported iPad Screen Sizes:** All iPad screen sizes
**Orientations supported:** Portrait Only
**Requires full screen?:** Yes 
- To disable Split View and Slide Over functionalities as they do not make sense in the context of the game


## 2. Architecture

### Architecture Overview

* Physics Engine: Simulates the physics.
* GameEngine: Manages game logic and uses the Physics Engine
* MainViewModel: Orchestrates game updates and exposes state to the views.
* Views: Render the game objects on the screen.

The starting point of the app is the PeggleGameplayApp that conforms to the App protocol. It creates a root-level GeometryReader which is “a container view that defines its content as a function of its own size and coordinate space.” This allows for all children views to have the same coordinate space, which is important for vector calculations and object placement later on.

`PeggleGameplayApp` is the starting point.
`PeggleGameplayApp` creates a `MainView` which is the primary View of the App.

`MainView` is contained within a root-level `GeometryReader` that allows for unified geometry
`MainView` will render `SubViews` accordingly, like `GameAreaView`, `LauncherView`, etc

```swift
var body: some View {
        ZStack {
            GameAreaView()
            BallView()
            LauncherView()
            LevelView()
        }
        .background {
            BackgroundView()
        }
        .environmentObject(viewModel)
```
All `SubViews` will observed `MainViewModel` as an `@EnvironmentObject`. This allows for cleaner code and sub views do not each need to be initialised with a ViewModel instance, the `.environmentObject` modifier ensures that all contained views will be synchronised with the ViewModel.

`MainView` owns a `MainViewModel` as a `StateObject` to which all processing is delegated.

`MainViewModel` initiates the game loop to a delegate `DisplayLink` that contains `CADisplayLink`
`MainViewModel` contains an `AbstractGameEngine`, which is a specification for a game engine.

```swift
protocol AbstractGameEngine {
    var delegate: GameEngineDelegate? { get set }

    var launcher: Launcher { get set }
    var isBallLaunched: Bool { get set }
    var currentBallPosition: Vector { get }

    var currentLevel: any AbstractLevel { get }
    var gameObjects: [UUID: any GameObject] { get }
    var isGameActive: Bool { get set }

    mutating func startGame(with level: AbstractLevel)
    func stopGame()
    func updateGame(timeStep: TimeInterval)
    func loadLevel(with level: AbstractLevel)
    func handleGameObjectRemoval(id: UUID)

    func updateLauncherRotation(with dragValue: DragGesture.Value, for size: CGSize)
    func launchBall()

}
```

`MainViewModel` handles all UI interactions, allowing `GameEngine` to handle solely game logic.
`MainViewModel` also extends the `GameEngineDelegate` protocol. This allows for the contained game engine to communicate with the `MainViewModel` without knowing if it exists or what it is. It is also stored as a weak var inside the game engine to prevent cyclical reference.

```swift
protocol GameEngineDelegate: AnyObject {
    func processActiveGameObjects(withID id: UUID)
}

class MainViewModel: ObservableObject, GameEngineDelegate {
```

`GameEngine` is the concrete implementation of the `AbstractGameEngine`.
`GameEngine` contains all Game Models, like the `Level`, the `Launcher` and the `Ball`
`GameEngine` also contains an `AbstractPhysicsEngine`, the specification for a physics engine.

```swift
protocol AbstractPhysicsEngine {

    init(areaOfEffect: CGRect, physicsObjects: [UUID: any PhysicsObject])

    var physicsObjects: [UUID: any PhysicsObject] { get set }

    var domain: CGRect { get set }

    func addPhysicsObject(object: any PhysicsObject)

    func updatePhysics(timeStep: TimeInterval)
}
```

`PhysicsEngine` contains a collection of `PhysicsObject` upon which the `PhysicsEngine` will act.
`GameEngine` will handle the real-time translation between `PhysicsObjects` and `GameObjects`


### Game Sequence

The below sequence diagram shows the series of function calls made during the course of the game, in particular, the game loop.

<img width="904" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/eaf7e886-f8aa-4c1c-9489-8af0f06f2d26">


## 3. Code Organization

### Some key classes

1. **MainViewModel**
   - The Renderer - Connects the UI (SwiftUI Views) with the game logic contained within `GameEngine`.
   - Processes user inputs, updates the game state, and triggers physics simulations indirectly via the game engine.
   - The MainViewModel essentially delegates all non-UI related actions to the Game Engine.
   - The MainViewModel is also compartmentalized based on its different functions so as to better align with Protocol-Oriented programming.

  <img width="1128" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/87c42b26-d803-49c6-ac78-471142effcbc">

  These are the views contained within MainView that holds MainViewModel as a State Object.

  <img width="879" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/5aed889f-f53d-42c1-b187-d1a92dfe1d7c">

2. **GameEngine**
   - Central component that manages game states, level progression, and interactions between game objects and physics engine.
   - Interfaces with `MainViewModel` to update the UI based on game state changes.
   - Utilizes `PhysicsEngine` for physics simulations.
   - Translates in real time the changes in physics objects and represents them as game objects.
  
<img width="1374" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/7e8433d9-14e2-4ae4-ae52-556db6c4f5f0">

3. **PhysicsEngine**
   - Responsible for simulating physical interactions between `PhysicsObjects`.
   - Handles physics calculations, including collision detection and response. 
   - Updates `PhysicsObjects` positions and velocities based on physics simulations.
  
<img width="729" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/4d37774c-44ba-49fa-ba94-b78486357900">

4. **PhysicsObject**
   - Abstract representation of objects in the physics world that participate in physics simulations (e.g., Ball, Pegs).
   - Contains properties like mass, velocity, and a `PhysicsShape` to represent its physical characteristics, and determining overlaps and collisions.

5. **PhysicsShape**
   - Represents the shape of a `PhysicsObject` for collision detection purposes.
   - Supports different geometries (e.g., Circle, Polygon) to accommodate various `PhysicsObjects`.

6. **GameObject**
   - Abstract representation of objects in the game world. Do not directly participate in Physics, unless they also conform to `PhysicsObject`
   - Contains properties for rendering, such as position and visual state.


Both GameObject and PhysicsObject extend from a common `UniversalObject`. This way, the physics world and game world exist as separate layers but contain just enough in common to work together.
The following diagram shows the relationship between the above mentioned types.

<img width="1234" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/8fe00092-d018-4e74-a694-8a1f7d35d161">

## 4. Some Implementation & Design Details 

<img width="280" align="right" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/f857faaf-4f1b-4fec-a95d-fafb9860e468">

### Interface Segregation

In my implementation I have tried to follow the Interface Segregation Principle as much as possible. You can see that `AbstractGameEngine` does not specify the need for an `AbstractPhysicsEngine`. This means that under the hood, any concrete implementation of a game engine can have one, none, or many physics engines. Any client that uses an `AbstractGameEngine` does not need to know about the physics going on behind the scenes, only that they can interact with the implementation in the means specified. 

This approach decouples the Physics Engine  and the  Game Engine. Any Game Engine can contain any Physics Engine, any number of and whichever GameEngine contains whichever Physics Engine will be responsible for the liaising between the `GameObjects` and the `PhysicsObjects`. These 2 are the building blocks of this architecture, similar to nodes in other physics engine implementations and game engines require game objects while physics engines require physics objects. This segregation means that both the concepts are entirely decoupled from each other. Nice. 

In this context, the `MainViewModel` is interacting with the game engine, which it considers to be an `AbstractGameEngine`. It does not need to know what physics is going on inside, and thus it is completely decoupled from the physics part of the game. 

Similarly, the concrete `GameEngine` does not need to know about the inner workings of the physics engine and it specifies only that it needs an `AbstractPhysicsEngine`

```swift
extension GameEngine: AbstractGameEngine { }

final class GameEngine {
    weak var delegate: GameEngineDelegate?
    var physicsEngine: AbstractPhysicsEngine
```

Additionally, the same concept is also applied to level. In order to decouple game engine from the level, an abstract level specification is used instead.

```swift
protocol AbstractLevel {
    var name: String { get }
    var gameObjects: [UUID: any GameObject] { get set }

    init(name: String, gameObjects: [UUID: any GameObject])

    func getGameObject(id: UUID) -> (any GameObject)?
    func storeGameObject(_ gameObject: any GameObject)
}
```

### Open-closed principle

Since switches and enums violate OCP, in order to make my game as extensive as possible while being as decoupled as possible, I created an ObjectSet class that defines images specifications externally. Game objects that require a specific rendering style only need to be considered by the View, and the Game object (as a model) is not tied to information about the View. Basically what this means is that any game object will contain a certain unique value that allows for its distinct visual representation without being tied to it. Every game object has a property called "objectType". When required, the Renderer will determine what this property corresponds to by referring to an external standard called the `ObjectSet`.

```swift

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
        "NormalPeg": ("peg-orange", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "DefaultPeg": ("peg-orange", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "GoalPeg": ("peg-blue", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "NormalPegActive": ("peg-orange-glow", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "GoalPegActive": ("peg-blue-glow", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "Ball": ("ball", CGSize(width: Constants.UNIVERSAL_LENGTH, height: Constants.UNIVERSAL_LENGTH)),
        "Launcher": ("cannon", CGSize(width: 90.0, height: 90.0))
    ]
```

This can allow for setting custom themes and handles all liasion with visual representation. A NormalPeg can look like a GoalPeg, a
cannon, or a crocodile. The Game logic will function the same. Each image can also specify its own width and height set, which the renderer can choose to implement
or override. At the moment, all size specifications are standardized (`to Constants.UNIVERSAL_LENGTH`), but this is an extensible implementation to allow customizing game objects

This collection is private, but it allows for modifications via getters and setters. These can provide an interface between modifying the visual representations (for e.g. changing themes), 
while simultaneously ensuring that modifications are safe (like width and height being within a limit, etc). 

All of this can happen without the GameObject being affected at all. Whatever name is assigned as the `gameObjectType` for a game object has a meaning that is arbitrary and only makes sense
in the context of an interpreter (the renderer) and an external interpretation standard (the ObjectSet). Thus, the game object is decoupled from the view entirely.


## 5. Design Considerations

### 1. Game Layer - Physics Layer Segregation
The first design consideration was about the treatment of individual objects. In my implementation, at any given point in time I have 2 distinct "layers" - The Game Layer and the Physics Layer. The game layer pertains to the game engine, game objects, and game view. the physics layer pertains to the physics engine, physics objects, and collisions. My initial idea was to have a single object, one that can do collisions, has a shape, has an associated image to render, a center position, a velocity. Essentially the idea was to have every object contain physics properties and use the game engine to manipulate them directly (for the non-physics tasks like lighting up a peg) while delegating them to the physics engine for physics related tasks like collisions. 

However, I chose to separate the physics layer from the game layer entirely. What this means is that I chose to have a GameObject protocol that specifies "game" related information like the image shown on the game board (not directly, this refers to the ability to tie an object to an image as explained above) and a PhysicsObject protocol that specifies "physics" related information like velocity and position vectors. Consequently, each type is associated with an engine. The `AbstractPhysicsEngine` only depends on PhysicsObjects and `AbstractGameEngine` only cares about GameObjects. The two are entirely decoupled, practically unrelated for all intents and purposes. 

While conventionally this is usually the case for the Physics engine, where Physics engines can be used like standalone modules, it is not often the case where the reverse is true i.e. the Game Engine itself can be used as a standalone module. It is usually the case that at the core of a GameEngine exists a Physics engine, causing the GameEngine to be dependent on a physics engine. In my implementation, the Game Engine is entirely isolated as shown in `AbstractGameEngine` which does not require any Physics engine at all (although I did use a concrete Physics Engine within my concrete Game Engine - because the easiest way to get physics functionality is to use a Physics Engine. But the point still holds).

The GameObject and the PhysicsObject both conform to the UniversalObject protocol, which mandates a center point and a UUID. This faciliates an independent point of contact between the 2 which allows real time translation of objects between layers. In a single game loop, the game engine translates game objects to physics objects, afterwhich the physics engine processes physics objects and returns them back to the game engine to be translated back to game objects - made possible by the UUID. Being hashable as well, the UUID can be used as a unique key in 2 dictionary collections - one with game objects and one with physics objects, allowing for mimimal time complexity, O(1) average which recovers some performance overhead incurred during the translation. It must be noted however, that both refer to the same objects (mostly). For example, a Peg is both a GameObject (because it needs to be able to load and save its position) and a PhysicsObject (because it must interact with the ball). Depending on whichever layer it is on, it will be treated as either a game object or physics object. The translation layer is made such that no information is lost during the casting of objects back and forth. 

However, this architectural choice is not without its trade-offs. The complexity of the interface between the GameEngine and PhysicsEngine introduces challenges in ensuring seamless communication and data synchronization between them. Performance overhead is another concern, as the translation layer between game objects and physics objects could introduce latency, especially in a game with numerous objects and complex interactions. 


**Advantages**

- Modularity: By decoupling game logic from physics calculations, each engine can be developed, tested, and maintained independently, enhancing code modularity and readability.
- Simplified Debugging and Testing: Separating the engines simplifies debugging and testing by isolating physics issues from game logic issues.
- Enhanced Focus and Specialization: Each engine can focus on a specific set of tasks. The PhysicsEngine can evolve into a highly efficient and accurate simulation tool without being encumbered by game-specific logic or rules, which do not pertain directly to physics calculations.

- Improved Maintainability and Scalability: With clear boundaries between game logic and physics simulation, updating or expanding one aspect of the game does not necessitate widespread changes across the codebase. For instance, introducing a new physical effect or object type requires modifications only within the PhysicsEngine. Similarly, adding new game features or logic can often be achieved without touching the physics code, making the game more maintainable and scalable.
  
- Facilitates Reusability and Interchangeability: The PhysicsEngine can be reused across different games or simulations without modification, as it doesn't contain game-specific logic. The modular design enables the reuse of the PhysicsEngine in different projects or games that require physical simulation, providing significant time savings and consistency possibly across projects. Moreover, if the need arises to replace or upgrade the PhysicsEngine, it can be done with minimal impact on the GameEngine, provided the interfaces between them are well defined.


**Disadvantages**

- Interface Complexity: The need for a translation layer between game objects and physics objects adds complexity to the system architecture
- Performance Overhead: The translation between game objects and physics objects might introduce a performance overhead, especially in scenarios with a large number of objects.
  
Choice and Justification: The decision to implement separate Game and Physics layers (as opposed to GameEngine as encapsulating the PhysicsEngine layer which is conventionally the case) was driven by the desire for modularity and the flexibility to adapt the game for future expansions. Despite the potential for interface complexity and performance overhead, the benefits of having a reusable and independently testable physics engine outweigh these drawbacks. This design allows for easier updates, maintenance, and potentially integrating a different physics engine without overhauling the game logic. While the challenges of interface complexity and potential performance overhead are non-trivial, they are outweighed by the benefits of having a flexible, robust, and reusable architecture. This separation enables the game to evolve and expand over time, accommodating new physics simulations or game features with minimal disruption to the existing system


### 2. Integrating Gameloop (DisplayLink) vs Isolating it

Integrating CADisplayLink directly into the GameEngine versus managing it within the ViewModel presents a nuanced architectural decision with implications for the game's design and functionality. This consideration hinges on where to locate the responsibility for the game's rendering timing and how it interacts with the game's logic and UI layers.

#### DisplayLink Managed by GameEngine

Embedding CADisplayLink within the GameEngine centralizes control over the game's update cycle, closely tying game logic updates to the display's refresh rate. This integration means that the GameEngine directly manages when game states are updated and rendered, based on the screen's refresh dynamics.

**Advantages**

- Integrated Control: The GameEngine gains direct control over the timing of game updates, potentially simplifying the synchronization between game state changes and rendering.
- Performance Optimization: With direct access to display refresh events, the GameEngine can optimize processing and rendering tasks, potentially improving game performance and responsiveness.
- Simplified Architecture: This approach could streamline the game's architecture by reducing the layers through which update signals must pass, offering a more straightforward path from game logic to screen rendering.

**Disadvantages**

- Increased Complexity: Incorporating CADisplayLink into the GameEngine complicates its responsibilities, blending game logic with timing and rendering concerns.
- Tighter Coupling: This design tightly couples the game update mechanism with the GameEngine, making it more challenging to adapt or replace timing mechanisms in the future without impacting game logic.
- Potential MVVM Violation: It may blur the lines of the MVVM architecture by moving a traditionally view-related concern (frame rendering timing) into what could be considered part of the model or controller layer.

#### DisplayLink Managed by MainViewModel

Placing CADisplayLink within the ViewModel adheres to the MVVM architectural pattern, treating display refresh timing as a component of the UI layer. The ViewModel becomes the orchestrator of when the view should update, based on input from both the user and systematic processes like animations or game state changes initiated by the GameEngine.

**Advantages**

- Clear Separation of Concerns: This setup maintains a clean division between game logic and UI-related timing, aligning with the MVVM principle of separating the model (game logic) from the view (UI).
- Flexibility in UI Management: By controlling CADisplayLink in the ViewModel, different rendering or animation strategies can be implemented without altering the underlying game logic, offering flexibility in responding to UI design changes.
- Enhanced Testability: Separating the timing mechanism into the ViewModel simplifies testing the GameEngine's logic without the need to simulate display refresh cycles.

**Disadvantages**

- Indirect Control Over Rendering: The GameEngine has less direct control over the timing of updates, potentially introducing latency between game state changes and their reflection in the UI. Given the already existing physics-game translation layer incurring some performance overhead, this latency could potentially become significant.
- Complex Communication: Requires a robust communication mechanism between the GameEngine and ViewModel to ensure timely and accurate updates, which can add complexity to the system's design.

**Conclusion and Choice**

Given the trade-offs, I made the decision to manage CADisplayLink within the ViewModel, for its alignment with the MVVM architectural principles which fosters a clear separation between the game's logic and its presentation layer. This choice supports modularity, maintainability, and flexibility in developing and updating the game's UI independent of its core logic.

This approach, while potentially introducing challenges in ensuring tight synchronization between game updates and screen refreshes, offers significant benefits in architectural clarity, testability, and adherence to established software design patterns. It positions the ViewModel as a central coordinator, adeptly managing interactions between the user interface and the game's logic, thereby encapsulating display-related timing within the realm of UI management where it logically belongs.

By embracing this architecture, the game benefits from a well-organized structure that enhances its ability to evolve and adapt to future requirements, whether they entail changes to game mechanics or to the user interface, without compromising the integrity or performance of the game's core logic.

Taking this one step further, the Display Link functionality is abstracted into its own class, which additionally decouples the ViewModel from being dependent on an external framework. While the MainViewModel still is responsible for the game loop and synchronization, this reponsibility is simplied by abstracting out the Display link management into its own class.
```swift
class DisplayLink: NSObject {
    static let sharedInstance = DisplayLink()
    var displayLink: CADisplayLink?

    /// A closure type that includes the frame duration
    var onUpdate: ((_ frameDuration: TimeInterval) -> Void)?

    override private init() {
        super.init()
    }

    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc func updateDisplay(displayLink: CADisplayLink) {
        let frameDuration = displayLink.targetTimestamp - displayLink.timestamp
        onUpdate?(frameDuration)
    }

    func invalidate() {
        displayLink?.invalidate()
        displayLink = nil
    }

}
```

The MainViewModel also conforms to a protocol that mandates these features, in line with protocol-oriented programming.

```swift
protocol DisplayLinkManagement {
    func setupDisplayLink()
    func startGame()
    func stopGame()
    func updateGame(timeStep: TimeInterval)
}

extension MainViewModel: DisplayLinkManagement {

    func setupDisplayLink() {
        DisplayLink.sharedInstance.onUpdate = { [weak self] frameDuration in
            self?.updateGame(timeStep: frameDuration)
        }
    }

    func startGame() {
        peggleGameEngine.startGame(with: peggleGameEngine.currentLevel)
        DisplayLink.sharedInstance.setupDisplayLink()
    }

    func stopGame() {
        DisplayLink.sharedInstance.invalidate()
    }

    func updateGame(timeStep: TimeInterval) {
        peggleGameEngine.updateGame(timeStep: timeStep)
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
```


## 5. Usage Instructions

### Usage Instructions

<img width="400" align="right" alt="Screenshot 2024-02-21 at 9 20 23 PM jpeg" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/51c42f1e-eef3-4317-96b3-1f4e36b78143">

On the right is the UI and the UI elements.

#### Instructions:
1. To position the launcher: Drag the launcher (within a range of -89 degrees to 89 degrees with the y axis as 0 degrees) to the desired direction.
2. To shoot a ball: After the launcher has been positioned, tap and hold the launcher to shoot the ball.
    - The ball will now fly around, subject to the initial launch velocity, gravity, and resitution.
    - It is bound to the top, left and right of the screen boundaries and will exit from the bottom.
    - If the ball hits any pegs, the pegs will light up.
3. Ball reset: After the ball has exited the stage, the pegs will fade out. The ball will be reset, meaning that the launcher will be ready to fire again.
4. Repeat: The launcher can continue to fire more balls, even after all the pegs have been removed.


- At any given point in time, there can only be one ball. Thus, if a ball exists on screen, the launcher cannot be fired again. The ball must exit the game board before the launcher can fire again.
- After all pegs are cleared, the ball can still be fired. The board will remain empty.

#### Peg Removal
In some rare cases, it is possible for the ball to become stuck. When this happens, and the ball is within a certain threshold velocity for a certain period of time the ability for a peg to be removed opens up. Whichever peg is in contact with the ball (and getting in the way of it moving) can now be long pressed on. This would remove the peg from the game board. Note that this is the only situation where the pegs can be forcefully removed. In normal circumstances, the peg would not be affected by the long press gesture.


## 6. Test Plan

<img width="186" align="right" alt="image" src="https://github.com/cs3217-2324/problem-set-3-sp4ce-cowboy/assets/19762596/00f15de4-285a-4526-ad48-b746dac97d7b">

### Unit Tests
Some unit tests are written for components that can be tested manually, as shown on the right. 

### Integration Tests

Note: For all the below tests, consider each test as being tested for every available iPad size.

#### Start-up visual testing

Game screen
- The App should be in Vertical Orientation
- Rotating the iPad should not change the orientation
- The Background Image should be visible
- Some pegs must be loaded onto the board

Launcher Cannon
- The launcher must be present at the top center of the screen
- The launcher must be facing downwards at the start of opening the app.
- The launcher must rotate when dragged.
- The launcher must only rotate about its center,
- The launcher must not move out of place.
- The launcher, when dragging, must not move more than 89 degrees on each side, even if dragged.

Pegs
- The pegs should be completely stationary at all times

#### Gameplay testing

Ball Launching
- Tapping and holding the launcher must launch a ball
- Tapping and holding the launcher while a ball exists on screen must do nothing
- Dragging the launcher must still work even when a ball exists on screen, and all the above Launcher Cannon tests must hold true.
- The ball must launch at an angle (close to) where the launcher is pointing to.
- The ball must launch from "under" the cannon visually.

Ball Movement
- The ball must be subject to gravity at all times. This means a downward acceleration that causes vertical (downwards) velocity to increase over time, i.e. exponential increase in displacement.
- Launching the ball (almost) sideways must show a parabolic motion (caused by downward gravitational acceleration)

Boundary Collision
- The ball must collide and bounce naturally off of the top, left, and right boundaries of the screen.
- Post-boundary collision velocity must be visually coherent i.e angle of approach must be approximately the opposite of the angle of bounce-off

Pegs Collision
- Ball colliding with the peg must cause the peg to "glow"
- Once a peg is "glowing" it should remain that way
- If the ball hits the same peg multiple times, no change should occur as the peg should be glowing from the first hit.
- The ball should bounce of the peg in a reasonable manner. Given the vector calculation involved, it is hard to exactly determine the angle visually, however, it should be similar to real life physics.
- The ball should not visually intersect any peg at any point.
- The pegs should not move at any point.

Peg Removal (Ball Exit)
- Once and only once the ball has exited the game stage may the pegs that are glowing fade to disappear
- All pegs that are glowing must fade to disappear at the same time and at the same rate
- The pegs must begin the fade out animation a short moment after the ball exists, not simultaneously.
- During the fading out, the launcher cannon must not be "Active" i.e. long pressing should not release a ball (but otherwise it should still move around)
- After the pegs are removed, another launched ball flying thru the previously peg-occupied space should not be affected by any phantom physics objects.
- Once all the pegs on the board are removed, nothing should happen. (For now, in the future level loading can be added)

Peg Removal (Ball stuck)
- In the rare case that a ball is stuck, long pressing on the peg that is stopping it must remove that peg.
- The ball must fall naturally (i.e. initial velocity must be 0 and gravitational acceleration once the peg is removed.
- Long pressing the peg IN ANY OTHER CASE should do nothing.








