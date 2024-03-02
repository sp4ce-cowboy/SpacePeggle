# DeveloperGuide

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

### Section header

Music: Field of Memories by "WaterFlame" (free for non-commercial use)
Music Credits: https://www.waterflame.com/contact-info
Background Image Credits: https://www.vecteezy.com/vector-art/1268880-a-galaxy-space-theme-background

## App Structure

The application's entry point is via the @main annotation in the root file,
`SpacePeggleApp`. At this point, the application is initialized with
an empty `SceneController`.

A `SceneController` is the communication interface between groups of various
views and the main renderer present at the root of the app. Note that I use
the term "Scene" differently from what is used by Apple in describing a "Scene"
in a Swift/SwiftUI app. I use the term "Scene" to refer to a collection of related 
views or view hierarchies that are displayed at any given instance. 

Scenes provide a logical separation within different 

The `StartScene` displays the start page of the application. In this page, the
user will be able to choose between loading a level, designing a level, and the
choosing app settings.

The `GameScene` consists of the launcher, the ball, the bucket, and
the game objects on screen. During this scene is where the gameplay occurs. 
Although it is titled a "Scene", it is essentially still a SwiftUI `View` and
still subject to the constraints of a "View" in the MVVM architecture. 

The `MenuView` is a special view that is part of the `GameScene` that contains
a "Transition Trigger". Each scene can be navigated between each other and all
scenes must contain a transition trigger so that at no point will the user be
stuck in any scene.

The `LevelScene` represents the Level designer interface, it contains the game objects,
the action bar and the file manager for storing and loading levels.


