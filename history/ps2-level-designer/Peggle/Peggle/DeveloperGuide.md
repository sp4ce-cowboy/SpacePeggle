# Developer Guide

## Overview
This developer guide contains all relevant information for CS3217 Problem Set 2, the Peggle Level Designer. This problem set required the implementation of a simple application for the purposes of understanding the MV\* design pattern, gesture handling, and file operations with persistent storage.

## Contents
This developer guide contains both the answers for the relevant questions in Problem Set 2 as well as some other general information that would be useful to someone trying to understand the code base

1. Level Designer Overview
2. Code Organization
3. Architecture
4. Design Considerations
5. Persistence Model
6. Test Plan

## 1. Level Designer Overview
### Project Overview

**Project Name:** “Peggle”

**Project Tech Stack:** Swift, SwiftUI

**Application Display Name:** “Peggle” (AppIcon sourced from [here])

**Supported Destinations: iPad only** 
    - Theoretically possible to extend to iPhone and Apple Silicon Macs

**Minimum deployments:** iOS 17.0
    - Some gestures require minimum iOS 17.0

**Supported iPads:** All iPads that can run iOS 17.0 as shown [here]

**Supported iPad Screen Sizes:** All iPad screen sizes

**Orientations supported:** Portrait Only

**Requires full screen?:** Yes 
    - To disable Split View and Slide Over functionalities as they do not make sense in the context of the game

**Customised Target Properties:** (For persistence and file-operations)
     - Application supports iTunes file sharing: Yes (To access “On My iPad” folder)
    - Supports opening documents in place: Yes (To load levels in-app)


### UI Overview
Upon start-up, the User Interface for the level builder looks as shown below. The playable area is constrained to exclude the device status bar and the Action Bar at the bottom. 

<img width="500" align="right" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/1268e651-840f-4fb9-b0ff-499388d08803">
<img width="500" align="right" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/01cc8adf-9da1-4cde-ba8d-ccc33f3da482">

#### Components
- The Action Bar consists of the Peg Selection Bar and the Function Bar.
- The Peg Selection Bar consists of the Peg buttons on the left and the delete button on the right.  
- The Function Bar consists of the Load, Save, Reset buttons on the left, a TextField in the middle, and the Start button on the right.
- Each button will appear “faded” when not active. Tapping on a button will make it “active”.

#### Loading and Saving
**Saving**
- All levels require a name to be saved, and this name cannot contain only white-spaces. All leading and trailing white spaces in a level’s name will be trimmed upon saving the level.
- The Save button will remain disabled (i.e. greyed out) as long as the text input into the `TextField` is invalid (i.e. all white-space)
- A successful save alert will be displayed if the level has been saved.
- After saving, the `TextField` will be cleared out and will return to its default state.

**Loading**
- Tapping the Load button will bring up a list of previous saved files, or an empty list of files if no levels are currently saved. 
- Tapping on a level will cause the level to be loaded and the current palette will be populated with pegs as saved prior.
- Unlike Saving, no success message will be displayed for a successful save. The palette being populated with the pegs is the success indicator. 

**Re-saving**
- File overwriting is not prohibited. Thus, to re-save a level, the user can simply load the level, rearrange the pegs, and save the level again with the same name to update that level.

#### User Interaction
- The user can tap on a peg button in the left side of the selection area to set that specific peg to be active. Afterwards, tapping inside the playable area will create a peg center at the location of the tap, given that no other peg exists at that location.
    - If a peg exists at the location of the tap, then the no new peg will appear. 
    - If the tap is outside the playable area, no new peg will appear  
- The user can also tap on the delete button on the right to activate deletion mode. 
    - Tapping on an existing peg with deletion mode active will remove that peg.
    - Tapping on an empty area will not do anything. 
- The user can tap on a different peg button to resume adding pegs, and doing so will set deletion mode to be inactive.

#### Long Press and Drag Gestures
- Regardless of the current state, long pressing on a peg will remove it.
- Regardless of the current state, dragging on a peg will move the peg following the user’s finger. 
    - During the movement of the peg, the constraints are ignored. The pegs can pass through other pegs and can move out of the game area temporarily. 
    - This is intentional behaviour, the rationale is to not restrict the user’s range of movement. For example, if the game area consists of many pegs, the user should not have to be forced to carefully manoeuvre through and avoid collision with each existing peg, as long as that peg ends up in a valid region.
    - However, the final location of the peg (i.e. when the finger is released after a dragging event) should abide by all constraints (i.e. no overlap or out-of-bounds). If the constraints are violated at the final location, then the peg is returned back to its initial location.
- The Drag gesture follows exclusively after the Long press gesture. This prevents any unintended dragging of a peg after it has been subject to the long press. This is an additional layer of safety as the long press gesture would remove the peg and thus there will be no dragging occurring anyway, but the “exclusively” method ensures that the drag gesture does not execute at all. 

#### Drag Gesture Collision-Resolution
- As an added safety measure, if the drag gesture’s auto-return itself violates constraints, (i.e. if the peg is moved to a invalid area, it should return back to its original location, but if during the dragging this original location becomes invalid due) then the peg is removed entirely to ensure compliance with the constraints. 

#### Multi-Touch
- My implementation of gestures made it, albeit unintentionally, for multi-touch to work. This means that multiple Pegs can be dragged at the same time. However, this behaviour is not fully defined and SwiftUI does not provide an explicit means for universal disabling of multi-touch, even with UIKit wrappers.  


#### Text Input
The TextField in the toolbar, when selected, would prompt SwiftUI’s natural keyboard overlay to allow for the input of text. One of the specified constraints is the Pegs do not overlap with any other components, and it is possible that the keyboard can be considered a “UI Component.” However, the alternative here is to either have a permanently visible keyboard or move the entire palette up every time the keyboard is invoked. The former is clearly not an option as constraining the game area to a small subsection would waste valuable screen real estate. The latter is not UX-intuitive, as the user’s experience of designing a level might be interrupted if the whole level starts moving.

The constrain for non-overlap exists simply because game objects should stay within the game area and not overlap other game objects. The temporary overlay of the keyboard does not violate (the spirit of) this constrain as the keyboard exists on a separate layer and does not interfere with the game objects. 


## 2. Code Organization & Architecture
I’ve used the Model-View-ViewModel Pattern in implementing the LevelDesigner. Thus, my files are split into Models, Views, and ViewModels (i.e. Controllers) amongst some other miscellaneous utility classes. Within these general categories, there are also sub-folders that logically group some related files together, according to the project file structure shown below.

<img width="302" align="right" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/2cb3aa9c-a24e-49b7-9fd7-6bbd955479ea">

Some of the classes are explained below, with more detailed explanations present as documentation comments within the code itself.

### Models (and some other classes)
#### GameObject
While not exactly a model, all objects in the game must conform to this protocol, which itself conforms to the `Identifiable` protocol and specifies `UUID` as the required `ObjectIdentifer`. This ensures that all objects in the game can be uniquely identified without having to rely on other attributes which might not be entirely reliable for uniqueness assurance. For this problem set, `Peg` is the only conforming class.

#### CodableGameObject
This protocol conforms to the `Codable` and `GameObject` protocol, which ensures that all conforming types can support file operations. I implemented this protocol to differentiate between regular game objects (perhaps randomly/programmatically generated generic pillar/bridges/walls etc.) that do not need to be saved or loaded from those game objects that do (like Pegs which can be user defined/created).

This way, only those game objects that absolutely need to have their states saved have to support file operations, reducing the complexity of file IO and saving a bit of space, while all game objects retain the ability to be uniquely identified.

#### Peg
`Peg` models - as you might have guessed - a Peg. It contains information about a Peg such as its identifier `id` as required by `CodableGameObject`, its center position as a `CGPoint`, its color as a `PegColor.RawValue` (of String type, for ease of encoding/decoding). (The choice to exclude radius will be explained as one of the design considerations later in this DG.)

`Peg` also implements the `encode` and `decode` functions as required by `CodableGameObject`, using a custom internal `CodingKeys` enum.

#### Peg+Storage
This extension to the Peg struct/model allows for Pegs to be supported in Level saving and loading operations.

#### Storage
The Storage is a pseudo-model/utility class that provides methods for the saving to and loading from files using FileManager. 

### Views
#### LevelView
This is the main view that is invoked by the entry point `PeggleApp`. This view presents the starting point for the Application and is the root of all other views. The LevelView also contains a `@GestureState` intended to indicate the presence of any active gestures input, to prevent such input from interfering with each other. 

#### PlayableAreaView
The `PlayableAreaView` overlays a transparent rectangle in the `MainView` that is used to detect user input gestures, and it is used for defining the bounds for the playable area independently of other views.

#### BackgroundView
The `Background` View presents the backdrop of the playable area, and is internally adjusted to account for the Action bar at the bottom, depending on the distribution of content in the background image. Since the image provided for this problem set had more content at the bottom, shifting the image upwards seemed more appropriate. Additionally, the width of the background image can also be adjusted and this would allow for dynamic adjustment of the background if landscape orientation were to be supported in the future.

#### PegView
Displays the Peg, and selects the appropriate image file to display, given the Peg’s color value

#### ActionBarView
A View encapsulating `PegSelectionBarView` and `FunctionBarView` in the appropriate positions.

#### PegSelectionBarView
A View that contains the Peg “buttons” and the delete button that the user can select, as explained above in the UI Section.

#### FunctionBarView
A View that contains the Function bar with the “Start”, “Load”, “Save” and “Reset” buttons as explained above in the UI Section.

#### FileListView
This view presents the File selection menu during the selection of levels to load. This View also presents the ability to delete all saved levels (with a warning) with a “Delete All” button. The ability to swipe left on a file row to delete individual saved levels is implemented as a private helper function, which would conventionally be encapsulated within an associated ViewModel. 

### Controllers (ViewModels)
#### LevelViewModel
This View Model handles the majority of the logic of the app. Conforming to Observable Object, the properties of `LevelViewModel` are  `@Published` . The `LevelView` contains a `LevelViewModel` instance as a `@StateObject`, and the properties contained within the View Model are accessed with Bindings in sub-views.

Information Flow: The ViewModel exposes @Published properties that the View observes. Whenever the ViewModel updates these properties, the View reacts by updating the UI.

Implementation: The @ObservedObject or @StateObject property wrapper in the View can hold an instance of the ViewModel. When @Published properties change, SwiftUI automatically updates the views that depend on them.

#### LevelViewModel+CheckRep
A means for checking that the game constraints are always fulfilled is implemented with a CheckRep function, added as a logical extension to the LevelViewModel since the ViewModel handles all modifications to the models. 

Check Representation assertions are commented out (to ensure proper functioning)
of the App and can be uncommented for debugging/analysis purposes.

The first constraint is that the Pegs do not interfere with any other pegs (in their final positions) and the second constraint is that the Pegs do not exceed the playable area and interact with other UI Components.

The assertions are added at the locations where pegs can change location, such as dragging to a final location and 


### Miscellaneous Classes
#### Utility
The `Utility` class consists of some commonly required configurations and properties that can be used universally, such at height modifiers and other adjustments. It also includes some helper functions that can be used universally, such as a keyboard dismissing function that invokes some UIKit elements. The purpose of having such a class is that not only does it provide a single source of truth for app configurations (especially UI configurations) but  it allows provides a quick and easy ad-hoc preferences panel for the entire application.

#### PegColor
An enum that encapsulates all available Peg Colors. This enum exists because all Pegs are represented by their corresponding images (as opposed to SwiftUI circles), and having this enum as an intermediary guards against invalid Peg Colors which do not have a corresponding Image Set available.


## 3. Architecture
The Entry point `@main` of the application is at PeggleApp.swift. This would call LevelView, which is the “Main” View of the application. The LevelView would be instantiated with a `LevelViewModel` as a `@StateObject` and all sub-views will be rendered subsequently 

### Class Diagram

Below is a simple pseudo-class diagram showing the MVVM pattern. From the class diagram, you can see that the View (LevelView) delegates processing to the ViewModel (LevelViewModel).

<img width="966" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/1ee40499-b49a-4ab0-93cd-50ff71c0835d">

### UI Hierarchy
- LevelView
    - GeometryReader
        - VStack
            - ZStack
                - PlayableArea
                - PegView and Gesture Recognition: “ForEach”
            - ActionBarView: VStack
                - PegSelectionBarView: HStack
                - FunctionBarView: HStack
                    - FileListView
        - BackgroundView (wraps the parent VStack) 

In the ZStack, the playable area is at the “lower” layer and the PegView/Gesture Recognition is at the “higher” layer. This means that initial user input gestures will pass through to the PlayableArea layer while subsequent inputs at that same area will be “stopped” by the overlayed PegView.

To elaborate this, a pseudo-sequence diagram is shown below. Note that this is not exactly a sequence diagram, but the view arrangement helps to show the hierarchy of Views.

<img width="1515" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/33a96fb1-ac8b-4a98-8d26-31cf20f1d13c">

### Time Complexity
Each PegView, upon the creation of a Peg, is presented as it’s own “layer”, as shown below, taken from the XCode debugger. 

<img width="1008" alt="image" src="https://github.com/cs3217-2324/problem-set-2-sp4ce-cowboy/assets/19762596/d6d6a547-8be0-4063-bfdf-82abdd5eee76">

Given the many stack views and particularly the PegView being created for every peg, there was naturally a need to consider the time complexity that could be incurred for maintaining a large number of PegViews at a time.

However, having a fixed radius for a Peg together with the bounds of the gameplay area, together with the no-overlap constrain would mean that only a fixed and finite number of pegs (and PegViews) can exist at any given time. The diameter of each Peg is fixed at 40.0: CGFloat. The geometry reader indicates that (for an iPad Pro 11”) the playable area is around 1150 x 850 CGFloat units.  This gives a theoretical maximum of around 600 Peg Views. Given that this number is < 1000, I believe that the iPad should be able to render the views effortlessly (from a source online that I can’t seem to find right now).

## 4. Design Considerations

### Design Consideration 1 - Gesture Layering

This design consideration is about whether to allow gestures to be directly “attached” to a game object or to present a control layer abstraction that mediates between outer-level gesture input and inner-level game object manipulation.

Gestures in SwiftUI are not as extensive as their pure UIKit counterparts. There are some issues with concurrent handling of gestures, such as tapping, dragging and long pressing that need to be addressed in order for these gestures to function properly. All gestures involve contact but varying values of motion and duration.
 
 Where 0 is minimum and 1 is maximum,
 
 - For tapping, motion = 0 and duration = 0
 - For drag initiation, motion = 1 and duration = 0
 - For drag completion, motion = 0 and duration = 1 (eventually)
 - For pressing, motion = 0 and duration = 1
 
First, we need to define all interaction vectors before we can code for them.
 - Tap 1: To place a Peg on an empty space
 - Tap 2: To remove an existing peg
 - Long Press: To remove a peg
 - Drag: To move a peg around
 
But before the specific gestures can be considered, we need to ensure that the interaction occurs in the correct "Layer". Simply, when the game starts, the Peg must be placed in a "empty" space. This space consists of the background image and the actual interaction layer in whatever defined order. That is to say that while it might seem like the user is tapping the background "canvas" and the pegs are appearing "on" it, this need not be the case necessarily. The "tapping" can occur at any position in the Z axis, and the presenting of PegViews as well.
 
The consideration of separating the background and the PegViews was relatively straight forward, in fact I am not sure if the contrary is even possible at all (i.e. Peg and Background as the same "image layer")
 
The first actual design consideration I had was: I can either define my own control layer that mediates all interaction, or I can split up the interaction based on the natural layer upon which said interaction occurs, which of course is the PegView itself
 
To demonstrate - Imagine the game starts up. The user taps on an abstract invisible layer above the image, and the pegs appear somewhere with the same x,y coordinates but a different z coordinate i.e. either below or above the touch layer. This is standard for both designs, because you can't tap on a Peg that doesn't exist to create it. The difference comes about once the Pegs have already appeared.
 
When any user interaction occurs, it occurs on this active control layer. This layer then "transmits" the information of that interaction to either a controller or another intermediary that is capable of "traversing" through the Z-axis bridging the control layer and the layer that contains the PegView, after which each PegView can be interacted with.
 
On the other hand, the control layer can also remain dormant (only activating during the process of PegView creation) which would mean that all user input - i.e. gestures - are "attached" to the PegViews themselves.
 
The direct control comes at the cost of not having a unified, centralized touch layer, one which can be later subject to generalizations if necessary, for example like size contraints, velocity calculations, etc. However, a control layer comes at the cost of having to retrieve and relay information frequently and possibly overly complicated-ly. One of the reasons why I went with the direct control was the limitations of SwiftUI in recognizing gestures properly.
 
The Long Press gesture is recognized before the Drag gesture, which would naturally terminate the gesture if the PegView were to be removed, given that a sequence of exclusive gestures is also set up.
 
However, such a distinction would not be possible so easily with an abstract control layer. Many additional components would need to be mounted to retrieve information, and that information needs to be processed together with other constraints (such as coordinates of a detected tap and the radius of the peg, etc). While it is not entirely impossible, having such an abstraction layer is not very useful, in that the 3-dimensional (z-axis) element will be entirely lost. For example, if later on the project specifications were changed such that Game Objects were allowed to overlap each other, such an abstraction layer would have to add an additional layer of complexity - The gesture after being recognized must then determine which layer this gesture corresponds to, which would require more information about the layer upon which a game object exists in.

Thus, I have decided to go with attaching gestures directly to the representation of game objects (which is currently only the PegView, but to allow for expansion in the future to other GameObjects as well) as this reduces the complexity by a large margin as opposed to having an abstract layer for mediating touch interactions. (For input, the gesture will be attached to the `PlayableAreaView` as per normal.) 

Additionally, the `.onTapGesture` is only available for the latest iOS version (i.e. it is one of the latest additions to SwiftUI), it seems that Apple is headed in this direction of development as well, as opposed to the previous `SpatialTapGesture()`. The former is a view modifier which must be attached to a view and the latter is a Gesture that exists standalone and passed into the `gesture(..` modifier. A minor difference and virtually no difference in the discrete functionality but the intention to move to a “view-modifier-based gesture-schema” is quite tangible.
 

### Design Consideration 2 - Peg Radius Delegation

The second design consideration was about the distribution of information that could be considered common to both a View and a Model. 

I wanted to consider having each Peg contain information about its own radius. This would allow for the user to have control over each peg inside the game area, and resize the peg, if such a feature were to be made possible in the future.

This would require that all pegs are encoded with their radius internally, and thus stored on file with their specific radius as well.

The alternative was to let PegView decide how to size the Pegs, and as it stands, I have the universal diameter for a peg stored inside the Utility Class. This allows me to resize the pegs as needed (i.e. by adjusting the universal diameter) and that would allow me to ensure that all Pegs are consistent across the Level Designer. Things like checking for collision, image resolution difference (i.e. different pegs on the same board having different image sizes due to difference in radii) would be much more reliable due to the lack of added complexity, and this also means that more extensive (both unit/integration) testing can be done on smaller, fixed range of Peg Views. Furthermore, it would also be more complicated to ensure proper functionality across all iPad sizes since that is one of the requirements.

Additionally, having a internal specification of size for a game object would mean that other game objects (in the future) would also have to be encoded with their sizes during file IO, adding more unneeded complexity to file IO operations and taking up more space, especially if some game objects are supposed to all be of the same size in-game (for example, walls or other obstacles).

Thus, I chose to enforce a universally constant diameter for the Pegs, and thus I did not have to encode/decode each peg size, and the size of each Peg will be determined by PegView at the point of creation of that View.

### Not-Really-A-Design Consideration 3
I’m not sure if this counts as a design consideration, but it was quite a significant initial consideration that I feel is important to include nonetheless.

The first consideration, before all else, was either to use Storyboard or SwiftUI. After quite a bit of deliberation, I chose SwiftUI.

SwiftUI:

- Version Control: SwiftUI's declarative syntax is very concise and is represented in code, which is excellent for version control systems. Merge conflicts can be more easily resolved compared to Storyboards, which are XML-based.
- Team Collaboration: The ease of reading and writing SwiftUI code can facilitate better collaboration among team members, especially for code reviews.
- Future-Proof: Apple is investing heavily in SwiftUI (and Swift), making it the future of iOS development. Starting with SwiftUI now can be a good investment. The possibility of imminent deprecation of Storyboard must be taken into account.
- Rapid Prototyping: SwiftUI makes it easy to build interfaces quickly with live previews, reducing the time from design to implementation. Additionally, having an iPad with Developer Settings enabled allows for Xcode to use the device for the SwiftUI preview much faster than the regular SwiftUI preview. Storyboard does not have this hot-reload feature.
- Cross-Platform: SwiftUI is designed to work across all Apple platforms, making it easier to share code if I ever decide to expand to other devices in the apple ecosystem, like macOS (and maybe visionOS?)

In the context of the Peggle clone, not all of these above-mentioned benefits can apply. Team collaboration is very clearly one of the benefits that are not very relevant, especially given that this is an individual project submission. However, I personally find that justification to be lacklustre. While it might be true that right now, I'm solely working on this project, who's to say that this Peggle clone will be entirely abandoned afterwards? The biggest premise of Software Engineering is that things change, expectations, project scope, implementation, target audience, just about everything that can change will be subject to change. Thus, future-proofing, in order to be done right, must be done for a future not yet conceivable, and that leads me to choose SwiftUI over Storyboard, to accommodate for even the slightest possibility that I might continue working on this even after the course ends.

UIKit, however, is not going anywhere [anytime soon]. There is also the problem of something not yet being ported over to SwiftUI, according to the problem set’s author’s [personal experience]. Apple makes this a non-issue by allowing UIKit elements to be [wrapped] and usable in SwiftUI.

Thus, these benefits of SwiftUI lead me to choose SwiftUI over UIKit/Storyboard.


## 5. Persistence Model

### Implementation
For this problem set, the default FileManager is used to save the levels on device storage. An array of Pegs is directly encoded for now, and later on this encoding can be extended to include `CodableGameObjects` with minimal modifications to the existing code. 

The Levels are also saved in a user-accessible manner. This means that the levels that are saved in game can also be found in the local device storage, under the “Levels” folder inside the “Peggle” app folder inside the “On My iPad” location in the native iOS/iPadOS Files app.

As JSON is intended to be in a user-readable format, a user is able to open the .json file and read the contents of the level. A possible future extension to this can be the sharing of level data between multiple players without having to rely on any complex in-game implementation and custom data encoding. 

Furthermore, the user is also able to backup levels and store them safely in an external location in the same way that they can backup other regular documents and files. Since the encoding is handled in-app, and the .json level file is a standalone file with no dependency on the Application itself, this also means that accidental deletion of the App would not affect previously saved levels as they will be stored safely on the user’s device locally (or inside an iCloud Container if CloudKit is to implemented in the future)

Given the reliability and simplicity of this method, I have chosen to implement it this way. There is the concern of data corruption (i.e. user manually modifying an entry, causing illegal levels to be loaded) however, this can be averted with a simple modification to the existing `checkRepresentation` methods inside LevelViewModel prior to their being loaded. Thus, the overall simplicity, reliability, accessibility and file transparency of this method compel me to implement it over the other options, primarily SQL databases and Core Data.

### Comparison and Justification

#### FileManager Encoding and Decoding

Pros:

- Simplicity: Utilizing FileManager with Codable for encoding and decoding is straightforward and doesn't require a steep learning curve, and thus it is quick to implement.

- Direct File Access: Files can be directly accessed, viewed, and shared via the Files app, providing transparency and easy sharing options for the user.

- No External Libraries: No need to integrate external libraries or frameworks, which reduced app complexity and size.

- Data Portability: Data saved as files can easily be exported, backed up, or migrated.

- Format Flexibility: Supports various data formats like JSON, XML, etc., offering flexibility in how data is serialized.

Cons:

- Scalability: Not ideal for large datasets or complex queries. As data grows, reading and writing operations may become slow. This should not be an issue for my use case as each level information

- Lack of Relationships: Managing relationships between objects can be cumbersome as it requires custom coding. This is also not an issue as there are no relationships between game objects at the point of implementation.

- Concurrency: Handling concurrent read/write operations requires manual management. This is not a big issue as levels will be loaded and saved individually.

- Data Integrity: Ensuring data integrity and validation must be handled manually. This can be done by checking representation in-app


#### CoreData

Pros:

- Rich Model Definitions: Allows for complex data models with relationships, inheritance, and more.

- Performance: Optimized for performance with large datasets, including lazy loading of objects. (I don’t need to deal with large datasets at the moment, and I doubt it will be required in the later stages).

- Data Consistency: Built-in validation tools to maintain data integrity. (I am able to accomplish this with the existing checkRepresentation alone. The added maintenance efforts brought by the added complexity would offset the benefit of additional validation tools)

- Graph Management: Manages an object graph, which can be persisted with minimal code. (I don’t really need an object graph here for a singular data structure here)

- Integration with UIKit: Easily integrates with UITableView and UICollectionView via NSFetchedResultsController. (But I am using SwiftUI)

Cons:

- Complexity: Has a steeper learning curve and can be overkill for simple data persistence needs, which I believe is the case here with the Level Designer.

- Less Transparency: The data is stored in a database file, which is not as easily accessible or shareable as individual files.

- Boilerplate Code: Requires more setup and boilerplate code compared to simple file storage solutions.

- Less Portable: CoreData's database files are less portable compared to plain files, and therefore less accessible. 

Additionally, attempting to implement CoreData prompted Xcode to add an unreasonable amount of boilerplate code, part of which was still using legacy Objective-C code (Another level of complexity). CoreData, while powerful, precedes the Swift Language itself and it seems that Apple is intending for SwiftData to replace CoreData in the distant future.

#### SQL Databases (SQLite)

Pros:

- Structured Data: Ideal for complex queries and managing structured data efficiently.

- Scalability: Can handle large amounts of data and complex data models.

- ACID Compliance: Ensures database transactions are processed reliably (Atomicity, Consistency, Isolation, Durability).

- Portability: The database file can be accessed by any system with an SQLite library, and iOS has one built in, which would be convenient.

Cons:

- Learning Curve: Requires knowledge of SQL for database operations.

- Direct File Access: Unlike FileManager, files are not as easily browsable or shareable through the Files app.

- No Direct Integration with SwiftUI: Requires additional layers or wrappers to integrate smoothly with SwiftUI views.

- Concurrency Management: Concurrent access to the database file needs to be manually handled, however this is not really relevant the Level Designer as the user is constrained

Generally the same as CoreData, I don’t need the extensive functionality offered by these databases. I believe that being able to implement a simple but efficient data storage means is much better than a complex but inefficient one.


## 6. Test Plan

### Tests Plan
Some of the models that can be tested have some unit tests written for them. Additionally, I would also test each component as specified in this test plan. Where-ever applicable, I have written Unit Test for specific Models already (for Storage, Peg and Peg+Storage extension).

### Unit Tests
#### Models
- Peg -> Unit tests present in the PegTests file
- Storage -> Unit tests present in the StorageTests file
- Peg+Storage -> Unit tests present in the PegStorageTests file

### Integration Tests
Integration tests are more applicable especially for Views, as it makes more sense for the UI features to be laid out and tested together, isolating them might not provide appropriate test coverage.

#### Start-Up Visual UI Testing 
- The App should be in Vertical Orientation
    - Rotating the iPad should not change the orientation
- The Background Image should be visible
- The bottom of the board should contain the Action board
    - The PegSelection bar should contain the blue peg, orange peg, and delete button
    - The Function bar should contain the buttons “Load”, “Save”, “Reset” on the left, an empty TextField with the default “Level Name”
    - The “Save” button should be greyed out by default
- The Blue Peg button should be highlighted (active)
- The Orange Peg button and the delete button should be faded (inactive)

#### Start-up non-game elements interaction
- Tapping the TextField should bring up the keyboard (if no other external or virtual keyboard mechanisms are present)
    - The keyboard should be overlayed on all UI elements
    - The keyboard should not have text suggestions displayed i.e. auto correction must be disabled
     - Tapping the return button should minimize the keyboard
- The entire Action Bar should move up along with the keyboard
    - This includes both the Peg Selection bar and the Function Bar
    - No buttons on the entire Action Bar should be covered by the keyboard
    - The motion of the ActionBar and the Keyboard should not interfere wth any existing pegs on the board
- Writing into the text field with any non-whitespace characters should set the Save button to be active (i.e turns blue color and becomes tap-able)
- Tapping any buttons on the function bar (Load, Save (when active), Reset, Start) should minimize the keyboard

#### Level load interaction
- Tapping the load button should bring up the file manager as an overlay window
- The file manager window appearance should not affect the positions of any other pegs or game objects
    - The files shown in the file manager should also be present inside the “On My iPad” > “Peggle” > “Levels” directory.
    - These files should have the same name in both the Files App and the File manager window
- The file manager should have a “Delete All” red button on the top left and a  “Done” button on the top right. 
- Tapping the Done button should dismiss the File manager window
- Tapping the Delete All button should prompt a confirm delete warning.
    - Tapping the Delete All confirmation button should dismiss the warning and delete all files in the file manager
        - This should also delete all the files inside the above mentioned directory.
    - Tapping the cancel button should dismiss the warning and the state of the files on the File Manager should not change
- Swiping on any file row toward the left should present the delete button on the right as a slideover. 
    - Tapping this button should remove the file from the file manager
    - The underlying file should also be removed from the above-mentioned directory
    - Swiping on any file toward the left all the way should delete the file similarly. 
- Tapping the Delete All button with no files saved should follow the same process and confirmation dialog, although no files will be delete since there are no files to delete.

#### Level Designer Interaction

Adding a Peg:
- Tap on an empty area in the playable area: It should create the active peg
- The peg should be added to the internal pegs array
- Tapping on an area containing other pegs should not add another peg. 
- Tapping on an area outside the playable area, such as the Action bar, iOS status bar, should not creat

Removing a Peg:
- Enable remove mode (isRemove = true).
- Tapping on a peg should remove the Peg from the Game board
- The peg should also be removed from the internal pegs array

Reset a level
- Tapping the “RESET” button should remove all pegs on the playable area
- This should also set the internal pegs array to an empty array.

Long Pressing a Peg
- Regardless of the selected state, long pressing on a peg should remove the Peg from the Game board. 
- The peg should also be removed from the internal pegs array

Dragging a Peg
- Regardless of the selected state, dragging a peg should move it around the game board.
- Releasing the peg at a valid area should move the peg to that location
- The peg’s internal centerPosition should be changed accordingly
- Releasing the peg at an invalid area, such as above another peg, should return the peg to its initial center position
- The peg, as long as the drag gesture is still active (i.e. finger hasn’t been lifted off the screen) should follow the finger around even if the finger travels into an invalid area.
    - Only once the drag gesture ends (i.e. finger lifted) then the collision resolution should take place - that is, determining if the new location of the peg is valid or not.
- During dragging, no other properties of the peg can change, such as the radius or the color

Collision Resolution:
- If while a peg is being dragged, its original location becomes invalid (due to UI elements moving in or other game objects being created), and the peg cannot return to its original state, it should disappear from the board completely.

#### Possible tests for LevelViewModel

Test Setup
- Create a LevelViewModel instance with a mock GeometryProxy or its size parameters.
- Initialize an array of Peg objects with varying positions and colors.
- Set up scenarios for pegs within the playable area, pegs at the edge of the playable area, and pegs outside the playable area.

Tests for handleTap(in:for:)

- Test tapping within the playable area while isRemove is false should add a peg.
- Test tapping on a peg while isRemove is true should remove the peg.
- Test tapping outside the playable area should not add a peg.
- Test tapping on a peg's edge should correctly determine if the peg should be added or removed.

Tests for handleLongPress(forPegAt:)
- Test that long-pressing on a peg index that exists removes the peg.

Tests for addPeg(at: …)
- Test adding a peg within the playable area adds the peg to pegs.
- Test adding a peg outside the playable area does not add the peg.
- Test adding a peg where another peg exists does not add the peg.
- Test that the peg added has the correct color.

Tests for movePeg(at:to:)

- Test moving a peg to a valid new location updates its position.
- Test moving a peg to an invalid location still changes its location, as long as the drag gesture is not stopped i.e. “finger” lifted off the screen.

Tests for movePegPermanently(at:from:to:for:)

- Test moving a peg to a valid location moves the peg.
- Test moving a peg to an invalid location returns it to the start location.
- Test moving a peg to an invalid location where the start is also invalid removes the peg.

Tests for removePeg(at:)

- Test removing a peg at a valid index removes the peg.
- Test removing a peg at an invalid index does not affect pegs.

Tests for removePeg(ifTappedAt:)

- Test tapping directly on a peg removes it.
- Test tapping near but not on a peg does not remove it.

Tests for isValidLocation(_:_)

- Test that a location within the playable area returns true.
- Test that a location outside the playable area returns false.

Tests for isWithinPlayableArea(_:_)

- Test locations at various points within the playable area.
- Test boundary conditions right at the edge of the playable area.

Tests for isOverlapping(_:)

- Test that a new location overlapping with an existing peg returns true.
- Test that a new location not overlapping with any existing pegs returns false.

Tests for isOverlappingExclusively(_:index:)

- Test that moving a peg to a location overlapping with another peg, excluding itself, returns true.
- Test moving a peg to a non-overlapping location returns false.

Tests for distanceBetween(peg:point:)

- Test that the distance calculation is accurate.
- Test edge cases where the point is on the peg's edge.
- Test with a point located at the peg's center.

Tests for checkRepresentation(_:)

- Test with all pegs within the playable area and not overlapping, should return true.
- Test with at least one peg outside the playable area, should return false.
- Test with at least two pegs overlapping, should return false.


