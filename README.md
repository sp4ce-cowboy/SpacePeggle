<div align="center">

# Space Peggle

**A Peggle-style physics game for iPad, built from scratch in Swift and SwiftUI.**<br>
A hand-written physics engine, game engine and level designer, with no SpriteKit and no game
framework. Built for NUS CS3217 over three problem sets that build on each other.

[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://www.swift.org/documentation/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?logo=swift&logoColor=white)](https://developer.apple.com/documentation/swiftui)
[![iPadOS](https://img.shields.io/badge/iPadOS-17.2+-000000?logo=ios&logoColor=white)](https://developer.apple.com/ipados/)
[![Xcode](https://img.shields.io/badge/Xcode-15+-147EFB?logo=xcode&logoColor=white)](https://developer.apple.com/documentation/xcode)
[![XCTest](https://img.shields.io/badge/XCTest-147EFB?logo=xcode&logoColor=white)](https://developer.apple.com/documentation/xctest)
[![AVFoundation](https://img.shields.io/badge/AVFoundation-000000?logo=apple&logoColor=white)](https://developer.apple.com/documentation/avfoundation)
[![SwiftLint](https://img.shields.io/badge/SwiftLint-F05138?logo=swift&logoColor=white)](https://realm.github.io/SwiftLint/)
[![App Store](https://img.shields.io/badge/App%20Store-publishing%20pending-lightgrey?logo=appstore&logoColor=white)](#app-store)

![Commits](https://img.shields.io/badge/commits-142-555?style=flat-square&logo=git&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-6.8k%20lines-555?style=flat-square)
![Docs](https://img.shields.io/badge/developer%20docs-14.8k%20words-555?style=flat-square)
[![WakaTime](https://img.shields.io/badge/WakaTime-270%20h-555?style=flat-square&logo=wakatime&logoColor=white)](https://wakatime.com)

</div>

> [!NOTE]
> This consolidated README page was added by
> [Claude Opus 5.5](https://docs.anthropic.com/en/docs/claude-code) in Nov 2026 using my
> [agentic-repo-analysis](https://github.com/sp4ce-cowboy/agentic-workflows) skill, from the
> project's code, git history and documentation. The project itself is from Jan – Mar 2024. The
> original README, my Problem Set 4 report and developer guide, is in
> **[README-ORIGINAL.md](README-ORIGINAL.md)**. The technical write-up is in
> **[ARCHITECTURE.md](ARCHITECTURE.md)**.

<p align="center">
  <img width="32%" alt="Start screen" src="docs/images/start-screen.png" />
  <img width="32%" alt="Gameplay: the ball in flight, lit pegs and the aim line" src="docs/images/gameplay.png" />
  <img width="32%" alt="Level designer with the peg palette and counters" src="docs/images/level-designer.png" />
</p>
<p align="center"><sub>Start screen · Gameplay · Level designer (iPad simulator)</sub></p>

## At a glance

| | |
|---|---|
| **What** | A complete iPad game: launch a ball from a cannon, clear the orange pegs, catch the ball in a moving bucket. It has special pegs, levels you design yourself, four planets with their own gravity, music and sound |
| **Built with** | Swift and SwiftUI only (plus AVFoundation for audio). The physics engine, collision system, game loop and level persistence are all written from scratch |
| **Context** | NUS [CS3217](https://cs3217.github.io/cs3217-docs/) *Software Engineering on Modern Application Platforms*, Problem Sets 2–4, Jan – Mar 2024 |
| **My role** | Sole developer: design, code, tests and developer documentation |
| **Status** | Complete; App Store publishing pending |

## The course

[CS3217](https://cs3217.github.io/cs3217-docs/) is NUS's course on software engineering for
modern application platforms, taught on iOS in Swift. It is known as one of the most demanding
software-engineering courses in the School of Computing. [Prof. Ben Leong](https://www.comp.nus.edu.sg/~bleong/)
ran its early editions (from 2011, when it was taught in Objective-C). In the course's own words
from that time: [*"CS3217 is really not for everyone. It's really quite hardcore and meant for the
most highly motivated to push themselves."*](https://comp.nus.edu.sg/~bleong/teaching/cs3217s11-midterm.htm)

The first half of the course is individual. Every student builds the same game, alone and from
scratch, through problem sets that stack on each other:

| Problem set | What it adds | Built |
|---|---|---|
| **[PS2: Level designer](history/ps2-level-designer)** | Place, move, resize and delete pegs; save and load levels; MVVM in SwiftUI ([developer guide](history/ps2-level-designer/Peggle/Peggle/DeveloperGuide.md)) | 23 Jan – 5 Feb 2024 |
| **[PS3: Game from scratch](history/ps3-game-engine)** | A physics engine and a game engine, written from first principles: integration, collision detection and response, the game loop ([developer guide](history/ps3-game-engine/PeggleGameplay/DeveloperGuide.md)) | 8 – 23 Feb 2024 |
| **PS4: Finalising the game** | The full game on top of both: special pegs, the bucket, scoring, hit points, planets, sound, and an integrated designer ([report](README-ORIGINAL.md)). This is the code at the root of this repo | 26 Feb – 6 Mar 2024 |

## Features

- **Physics from first principles.** Velocity and gravity integrated every frame, with
  circle–circle and circle–rectangle collisions. The response conserves momentum between
  movable bodies and reflects off fixed ones, followed by position correction and slightly
  randomised restitution.
- **Special pegs:**
  - **Kaboom:** an explosion whose force falls off with distance, out to 4 radii.
  - **Spooky:** "Domain Expansion" turns the floor into a portal to the top of the screen.
  - **Stubborn:** a peg with real mass that you can knock into other pegs.
  - **Block:** an immovable obstacle.
- **The bucket.** It moves along the bottom, bounces the ball off its rim and catches it
  inside. It is modelled as three physics bodies drawn as one sprite.
- **Hit points** from 1 to 10 per peg, set in the designer.
- **Scoring:** points per peg type, 10,000 for the bucket, plus a combo bonus.
- **Planets:** four themes with different gravity, which can also be changed live in a game.
- **Launcher:** aim by dragging the cannon, with a projected trajectory that accounts for
  gravity.
- **Level designer:** rotate and scale pegs, delete them with a long press, and save and
  load levels as JSON. Saving is validated: it needs a name and at least one goal peg.
- **Sound:** background music and effects through AVFoundation, which respect the iPad's
  silent mode.

## Architecture in brief

```mermaid
flowchart LR
    subgraph Views["SwiftUI views"]
        S[Start scene] --- G[Game scene] --- L[Level scene]
    end
    subgraph VMs["View models"]
        SVM[StartSceneVM] --- GVM[GameSceneVM] --- LVM[LevelSceneVM]
    end
    ASC["AppSceneController<br/>(presenter, scene transitions)"]
    DL[CADisplayLink game loop] --> GVM
    GVM --> GE["Game engine<br/>pegs · rules · score"]
    GE <-->|delegate| PE["Physics engine<br/>integration · collisions"]
    LVM --> LD[Level designer] --> ST[(JSON storage)]
    Views --> VMs --> ASC
```

- **MVVM with a presenter.** Three scenes (start, game, level) each have a view model.
  An `AppSceneController`, similar to a VIPER presenter, owns the transitions between them.
- **Two engines, one boundary.** The game engine knows pegs, rules and scoring. The physics
  engine knows only bodies, shapes and forces. They talk through `PhysicsEngineDelegate`, so
  the physics engine can be tested and reused alone.
- **Double dispatch for collisions.** Shapes resolve `intersects(with:)` by calling back into
  the other shape (a visitor pattern). An overlap is an optional `Double`: `nil` when apart,
  the penetration depth when touching. That depth also drives position correction.
- **A frame-driven loop.** A `CADisplayLink` wrapper calls the game view model each frame,
  and the view model steps the engines with the frame's duration.

More in [ARCHITECTURE.md](ARCHITECTURE.md), including the evolution from PS2 to PS4, the
physics maths, the bucket, persistence, testing and the trade-offs.

## Skills shown

| Skill | Where it shows (click the links for the code) | Docs |
|---|---|---|
| **SwiftUI app architecture**<br><img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-0D96F6?logo=swift&logoColor=white"> | Scene controller and view models: [`AppSceneController`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Main/MainApp/AppSceneController.swift), [`GameSceneViewModel`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/ViewModels/GameSceneVM/GameSceneViewModel.swift) | [SwiftUI](https://developer.apple.com/documentation/swiftui) |
| **Physics engine from scratch**<br><img alt="Swift" src="https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white"> | Integration step: [`updatePhysics`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/PhysicsModels/PhysicsEngine/PhysicsEngine.swift#L64-L72); collision response with conservation of momentum: [`calculateNewVelocities`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/PhysicsModels/PhysicsEngine/PhysicsEngine%2BCollision.swift#L139-L197) | [Elastic collision](https://en.wikipedia.org/wiki/Elastic_collision) |
| **Design patterns (double dispatch)** | Shape-to-shape intersection as a visitor: [`UniversalShape`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/Shapes/UniversalShape.swift), [`RectangularShape`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/Shapes/RectangularShape.swift#L39-L60) | [Double dispatch](https://en.wikipedia.org/wiki/Double_dispatch) |
| **Game loop**<br><img alt="CADisplayLink" src="https://img.shields.io/badge/CADisplayLink-000000?logo=apple&logoColor=white"> | A display-link wrapper driving the engines once per frame: [`DisplayLink`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Main/Utility/DisplayLink.swift), [`+DLM`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/ViewModels/GameSceneVM/GameSceneViewModel%2BDLM.swift) | [CADisplayLink](https://developer.apple.com/documentation/quartzcore/cadisplaylink) |
| **Protocol-oriented design** | `PhysicsObject`, `GameObject`, `Peg` and engine protocols with default implementations: [`PhysicsObject`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/PhysicsModels/PhysicsObjects/PhysicsObject.swift), [`AbstractGameEngine`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/GameModels/GameEngine/AbstractGameEngine.swift) | [Protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/) |
| **Gameplay systems** | Explosion falloff: [`applySpecialPhysicsOn`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/PhysicsModels/PhysicsEngine/PhysicsEngine%2BCollision.swift#L71-L98); the three-body bucket: [`Bucket`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/PhysicsModels/PhysicsObjects/Bucket.swift) | — |
| **Persistence**<br><img alt="Codable" src="https://img.shields.io/badge/Codable-F05138?logo=swift&logoColor=white"> | `Codable` levels and game objects saved as JSON in the app's documents: [`Storage`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Models/Storage/Storage.swift) | [Codable](https://developer.apple.com/documentation/swift/codable) |
| **Audio**<br><img alt="AVFoundation" src="https://img.shields.io/badge/AVFoundation-000000?logo=apple&logoColor=white"> | Cached players for music and effects, respecting silent mode: [`AudioManager`](https://github.com/sp4ce-cowboy/SpacePeggle/blob/2167e43069ef354a38f5b61d4369939aa6c73c4b/SpacePeggle/SpacePeggle/Main/Utility/AudioManager.swift) | [AVAudioPlayer](https://developer.apple.com/documentation/avfaudio/avaudioplayer) |
| **Testing**<br><img alt="XCTest" src="https://img.shields.io/badge/XCTest-147EFB?logo=xcode&logoColor=white"> | Unit tests for vectors, the physics engine and the launcher ([SpacePeggleTests](SpacePeggle/SpacePeggleTests)), and written test plans in the developer guides | [XCTest](https://developer.apple.com/documentation/xctest) |
| **Technical writing** | About 14,800 words of developer guides across PS2–PS4: [README-ORIGINAL.md](README-ORIGINAL.md) | — |

## Assessment

Each problem set was graded by the course's teaching team, against a rubric covering the
developer guide, the requirements, code quality, tests and a playtest. Some nice comments
from the graders:

> *"Overall, your PS was very well done and I really enjoyed playing and testing your game. I
> particularly appreciated the UI for resizing and rotating game elements, as well as the
> choice of circular health bars."*<br>
> <sub>PS4 · the final game</sub>

> *"Very intuitive choice of UI for level designer for both resizing and rotation. Well done!"*<br>
> <sub>PS4 · the final game</sub>

> *"Very smooth testing experience, no noticeable issues!"*<br>
> <sub>PS4 · playtest</sub>

> *"Comprehensive and very well organised."*<br>
> <sub>PS2 · on the developer guide</sub>

> *"Generally smooth experience testing your app. Swipe to delete and delete all button are a
> nice touch."*<br>
> <sub>PS2 · playtest</sub>

## Coding stats

Tracked with [WakaTime](https://wakatime.com). For scale, NUS's standard workload is 2.5 hours
a week per unit, so 12.5 hours a week for a 5-unit course like CS3217.

| | |
|---|---|
| **Total** | **270 h** of coding: PS2 55 h · PS3 103 h · PS4 112 h |
| **Peak week** | **93 h** (29 Feb – 6 Mar 2024), about 7.4× the standard workload |
| **Peak day** | **19.9 h** (6 Mar 2024, PS4 deadline day) |
| **Longest push** | **41.7 h** without a break longer than 3 h (Tue 5 Mar 08:20 → Thu 7 Mar 01:59), 33.4 h of it coding |
| **Commits** | 142 across PS2–PS4, 12 merged pull requests |
| **Code** | about 6,800 lines of Swift in the final game |
| **Writing** | about 14,800 words of developer guides (PS2 6,900 · PS3 4,700 · PS4 3,200) |

> *"107h for this PS? You're a strong one."*<br>
> PS4's grader, on the hours reported in the reflection form.

```text
Hours per week (2024)                The last 7 days before the PS4 deadline
22 Jan  ████                14.0     Thu 29 Feb  ████████████        12.9
29 Jan  ███████████         40.4     Fri 01 Mar  █████████            9.8
05 Feb  █████████           32.1     Sat 02 Mar  █████████            9.7
12 Feb  ██████              21.2     Sun 03 Mar  █████████████       14.2
19 Feb  ██████████████      50.2     Mon 04 Mar  ████████████        13.2
26 Feb  ██████████████████  63.9     Tue 05 Mar  ████████████        13.2
04 Mar  █████████████       47.5     Wed 06 Mar  ██████████████████  19.9
```

```text
My commits per week (2024, merges excluded)
22 Jan  █                       2
29 Jan  █                       3
05 Feb  ███████                19
12 Feb                          0
19 Feb  █                       1
26 Feb  ████████████           33
04 Mar  ██████████████████     51
```

## On my resume

**Skills:** Swift · SwiftUI · MVVM · protocol-oriented programming · game and physics engines · collision detection · CADisplayLink · Codable and JSON persistence · gestures · AVFoundation · XCTest · technical writing

- Built Space Peggle, a complete iPad physics game in Swift and SwiftUI with no game framework: a from-scratch physics engine (integration, circle–rectangle collision detection, momentum-conserving response), a game engine, a level designer and JSON persistence. About 6,800 lines of Swift.
- Architected the app in MVVM, with a VIPER-style presenter coordinating three scenes, and split the game and physics engines behind delegate protocols. A CADisplayLink loop in the view model drives both, so the physics engine runs and is unit-tested with no game or UI code. The final submission was graded with zero code-quality deductions.
- Implemented collision detection with protocol-oriented double dispatch across circle and rectangle shapes. Each check returns the penetration depth as an optional `Double`, which also drives position correction, so the collision path has no type switches and new shapes slot in.
- Built a SwiftUI level designer with drag, rotate and resize gestures, long-press deletion, per-peg hit points (1–10) and save validation. Levels persist as Codable JSON, with swipe-to-delete level management.
- Shipped gameplay systems on top of the engine: exploding pegs with linear force falloff to 4 radii, a portal floor, a three-body bucket that deflects and catches the ball, live gravity switching across 4 planets, a gravity-aware aiming trajectory, and AVFoundation music and effects that respect silent mode.
- Wrote 14,800 words of developer guides across three cumulative NUS CS3217 problem sets, setting design decisions such as engine separation and game-loop placement against their alternatives, alongside XCTest unit tests and written test plans.

## App Store

Publishing on the App Store is **pending**. The game is complete and runs on iPad
(iPadOS 17.2+). The release is planned once an Apple Developer Program membership is in place.

## Getting started

1. Open `SpacePeggle/SpacePeggle.xcodeproj` in Xcode 15 or later.
2. Pick an iPad simulator or device on iPadOS 17.2+, and run.
3. Optional: install [SwiftLint](https://realm.github.io/SwiftLint/), which the build phase runs.

Music: *Field of Memories* by WaterFlame (free for non-commercial use). Sound effects: [Pixabay](https://pixabay.com/service/license-summary/).
