[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/BAJPqr99)
# CS3217 Problem Set 4

**Name:** Rubesh

**Matric No:** A0253146J

### Part 1 Contents
1. Rules of the Game
2. Bells and Whistles
3. Reflection

### Part 2 Contents
1. Architecture Overview
2. Files organization
3. Some design choices
4. Some demos
5. Known Issues
6. Test plan

### Part 3 Contents
1. PS2 DG
2. PS3 DG


# PART 1


### 1. Rules of the Game

**App Usage**
**Start Game:** Choose one of three predesigned levels

**Load Level:** Choose a previously saved level

**Design Level:** Design your own level and play your own game

**Settings:** Choose between 4 environment and 2 power-ups

**How to win:**
- Only 5 balls available, clear all goal pegs to win (i.e. “orange” peg)
- Get more balls by aiming for the bucket and successfully entering it
- Goal pegs can be cleared indirectly (by knocking other movable pegs)

**Scoring system:**
- Each ball entering the bucket will add 10000 points and will add 1 more available ball
- Each goal peg (orange) hit will increase the score by 2000
- Each special peg hit will increase the score by 1000 points and activate a certain effect
- Each normal peg cleared will add 500 points
- Points are updated in the scoreboard after the ball exits the current gameboard, and displayed at the scoreboard view at the bottom.
- Attaining a score of 10,000 or more in one go will add 10,000 points as a combo bonus

**Gameplay Instructions**
- Drag the launcher cannon at the top of the screen to aim in the direction. (because tapping in a direction would be too easy! :)
- Tap on the cannon to release the ball in the direction
- Cannon will look flat and “empty” once a ball has been launched onto the game screen.
- Once the ball has exited the game area, cannon will “inflate” to indicate that a ball is now available.
- Balls can be fired until there are none left.

**Special Pegs**
**- Spooky peg:** Will show active state in the scoreboard when activated - “Domain Expansion”
    - Spooky Peg being active will cause the bottom of the screen to become a “portal” to the top of the screen. 
    - During this time period, the ball will not exit the screen. Instead, it will appear at the top with the same velocity as it exited.
    - Spooky pegs and domain expansion effect will disappear once the ball enters the bucket again.
**- Kaboom peg:** Will dissipate with an invisible explosion radius of up to 4 times its own radius.
   - Any movable object inside its explosion radius will feel a force according to their velocity vector, and moving accordingly.
   - **Bells and Whistles upgrade:** The force they feel is proportional to their proximity to the the exploding peg, zeroing at a maximum of 4 radii.
   - Any object in the blast radius will be activated (hitpoints depending), and will be removed upon ball exit.
**- Block:**
   - Will not move, no effect on gameplay except for affecting movement of movable objects
**- Stubborn Peg:**
   - Will move according to laws of physics, can move and collide into other objects and activate them as well.
   - Stubborn pegs can be used to strategically clear other pegs by setting them in the direction of other pegs.


**Level Designing Instructions**
- Choose a power up from the settings menu
- Design a level with the “Design Level” feature available at the start menu
- Power up will determine either kaboom peg or spooky peg available in the level designer (as per the PS requirements)
   - But loading a game with a previously saved power up will activate that power up, even if current game master is different
- Resizing: Rotate or scale an object by tapping on it and moving the edge around.
    - Note: The shape will default to its original position after a drag event, but will continue to follow your finger regardless
- Tapping also brings up the health bar. When the health bar is active, you can increase the object’s hit points from a minimum of 1 to a maximum of 10. See below for more details.
- Long pressing on an object will remove it, even if the remove button is not active.

Hitpoints
- For every peg, you can choose to assign hitpoints. 
- Hitpoints corresponds to the number of times that the game object can be hit before it becomes “active”. 
- For example, an exploding peg (purple) will need to be hit a said number of times before it can be “activated”
- Hitpoints can be applied to all game objects with the exception of blocks.
- Hits are counted regardless of the object that hit them, and regardless of the force with which they are hit.
    - Not only is this implementation simple and effective to implement, it also provides a consistent gaming experience across different “planets”. Different gravitational velocities mean that different
- By default, all objects have a hit point of 1. When the hit point reaches this level, 

## Bells and Whistles
Bells and Whistles
- Space theme: Choose your planet in the settings menu (Changes scenery and also gravity!)
- Background music: Music plays when game begins and ends
- Sound effects: When objects collide, upon winning and losing, and when ball enters bucket
- All sound effects are programmed to respect current sound mode (i.e. silent mode) with .ambient setting
- Custom gravity: Change gravity live in-game to 3 different settings. The trajectory and gravity effect on the ball will be immediate.
- Simultaneous power-ups: While game master allows for the choice of a specific power up to be used in the designing of a level, loading a previously saved level with a different power still allows for that power-up to be used in game! All power-ups will affect each other - An exploding peg can activate a spooky peg in its vicinity. 
- Launcher projectile path: Launcher will display the path that the ball is going to take, taking into consideration the preset launch velocity and preset gravity.
- Scoring system (see above) with combo bonus
- Space-themed loading screen
- Randomized resitution range to simulate natural physics
- Level designer has a counter that indicates the number of types of pegs present on the board
- Swipe to delete on the board

## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

* Do you think you have designed your code in the previous problem sets well enough?
    * I definitely used the best practices I was aware of at the moment of completing my problem sets, only to realize that my notion of best practice was far from what was actually the best practice. I honestly didn’t understand the MVVM/MVC pattern until PS3, and even then I had some overlaps and confusions. However, working through PS4 (and undoing all the previous mistakes to the best of my ability) allowed me to understand the significance of the common software engineering practices and the reasons they exist (things like the delegate pattern, double dispatch, etc) - especially why something that might be easy to code might not be as easy to maintain. As much as I spent cleaning up some poor design choices from my previous problem sets, I was glad that I did choose the more verbose but more scalable and maintainable ways to accomplish certain functions whereever I did, as it made my life a lot easier when I had to make some drastic changes. Nonetheless, I could have designed my code a lot better as that would have allowed my to spend less time on correcting those errors.


* Is there any technical debt that you need to clean up in this problem set?
    * Similar to the previous question, I had to spend quite a bit of time separating the various layers of the application (though I’m still not sure if I did but I tried my best), the parts where the physics engine and the game engine crossed each other’s layers. I realized that instinctively I chose the easier way to access certain information without taking into consideration the overlaps I might have made. Additionally, I also had to spend some time making my views more isolated and making my viewmodels do even more of the work, even in aspects I hadn’t considered before like function names (i.e. viewModel.launchBall() vs viewModel.handleLongPress()). As my codebase got larger, I found more of these inconsistencies from before and tried my best (which took quite a bit of time) to change them. Additionally, as I had not used SwiftUI before, I realized that at certain points of the application I had just used certain properties (like @EnvironmentObject, @Published, @ObservedObject, Observable, etc) without fully understanding their implications, and that had resulted in me having to reconfigure entire parts of it to get certain methods and views to work properly again. 


* If you were to redo the entire application, is there anything you would have done differently?
    * I think one think I would definitely do is use UIKit instead of SwiftUI. I had initially felt that SwiftUI was more relevant, especially give the recent announcement of SwiftData it seems that Apple is moving towards pure-Swift frameworks for all aspects of an application’s development, from the previous UIKit and CoreData that are a mix of Objective-C and Swift. Additionally, I was interested in cross-platform programming for the entire Apple ecosystem as having one codebase that would run on all platforms by default was appealing. Thus, I wanted to invest my time in learning the newer and what I had perceived to be more relevant. However, I had to learn first hand that SwiftUI is still not as powerful and all-encompassing as UIKit. UIKit is part of Cocoa Touch, the abstraction layer over iOS itself, based on the Cocoa API (itself . SwiftUI itself is an abstraction layer over UIKit, and while it was simple to get started with declarative code (the sheer amount of boilerplate code that comes with a Storyboard default Xcode project was off-putting, as opposed to the 4 or 5 lines of code it takes to get a preview with SwiftUI) it was very difficult to debug later on. Almost all the error messages thrown by SwiftUI were foundationally based in UIKit, and the view hierarchy debug is not friendly at all to someone without UIKit experience. And by then, I was too invested to migrate to UIKit. Some of the issues (especially with the keyboard and ignoring safe areas) were practically impossible to debug and correct throught SwiftUI alone. At the later stage of my app, I had to use a UIApplicationDelegateAdaptor with my SwiftUI app. I also realized how easy it was to use storyboard to apply a background image (for the loading screen) with Storyboard, as compared to SwiftUI (or at least for a Swift beginner) in the later part of my application ( bells and whistles). WIth that being said, I don’t regret learning SwiftUI at all as once it made sense, everything just worked and sometimes I didn’t even have to use the preview to ensure the correctness of my views due to the concise and predictable nature of declarative code.

