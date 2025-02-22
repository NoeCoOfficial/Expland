<h1 align="center">Expland Changelog</h1>

# v0.6.5 (unreleased)

---

yellow flower text inside inventory is now "Yellow Flower" instead of "Yellowflower"
fixed a bug where you could close the workbench by pressing "E", then being able to open it again by pressing "E"
fixed 3d inventory pickup items noclipping through the ground
there are now 16 slots in inventory pockets instead of 9 to store items
there are now 49 slots in the chest instead of 25 to store items
there are now 9 slots in the workbench instead of 5 to craft items
an all new crafting system which can be accessed by interacting with the workbench in the testing area
change player collision shape to reduce lag
new stone inventory item
new wood plank inventory item
an all new explorer notes system, with the ability to collect notes and view them in your inventory
removed the old hand item system
changed the FOV cap from 60-120 to 90-120
[added a hotbar to the player, where you can quickly access and hold items]
[added the ability to build]


---

# v0.6.0 (released)

---

## Core

### Changed:
- Changed default Linux driver to Wayland instead of XWayland, which is hard to maintain (#74)
- Changed save file location, so save files are not in the same folder as the executable.

## Settings

### Added:
- Pretty shadows option
- Autosave interval option

## Main Menu

### Added:
- You can now create Island save files with names, load save files, rename the save files, and delete them

### Changed:
- Background camera animation now loops instead of stopping when returned to original position
- Black screen fade-out time is now 3 seconds instead of 5

## The Island

### Added:
- Functionality and saving to the Chest, which consists of 25 slots to store items
- The all-new Item Workshop™ located in the testing area, where you can obtain any item you want!
- Water to the lake and around The Island
- Dynamic clouds in the sky that move
- A very simple weather system that is yet to be improved
- Added Tree2 wind swaying animation
- Added Tree3 wind swaying animation
- Added Tree4 wind swaying animation
- Added Tree5 wind swaying animation
- Added Tree6 wind swaying animation
- Added Tree7 wind swaying animation
- Added Tree8 wind swaying animation
- Added Tree9 wind swaying animation
- Added Tree10 wind swaying animation
- Added PineTree2 model with wind swaying animation
- Added PineTree3 model with wind swaying animation
- Added PineTree4 model with wind swaying animation
- Added PineTree5 model with wind swaying animation

### Changed:
- Revamped the entire Day/Night cycle system, making it more optimized and less buggy. Also, the sunrise is beautiful
- Refined Tree1 wind swaying animation
- Refined PineTree1 wind swaying animation

## Environment

### Removed:
- Removed motion blur effect (#79)

## Audio

### Added:
- Background music to both the Main Menu and The Island with interactive controls

## Player

### Added:
- Health value is now a bar
- Added a hunger bar
- Introduced a stamina bar to monitor player endurance
- Implemented an autosave feature with customizable intervals in the settings

### Changed:
- Inventory clears upon dying

### Fixed:
- Fixed being able to pause the game while dead

## Inventory

### Added:
- The ability to hold items (Sword, Pickaxe, Axe) in your hand
- The ability to eat items
- The ability to quickly drop items while hovering over them (Key X)
- The ability to quickly switch items from pockets to chest slots and vice versa while hovering over them (Key Q)
- Axe
- Sword
- Coconut
- Efficiency Potion
- Haste Potion
- Health Potion
- Luck Potion
- Night Vision Potion
- Regenerating Potion
- Stamina Potion
- Strength Potion
- Yellow flower (#46)

### Changed:
- The slot texture to a dashed rounded square

### Fixed:
- Fixed a bug where you could sometimes not place dropables down in empty slots (#81)

---

# v0.5.5 (released)

---

## Player

### Added:
- Added a minimal alert UI (triggered when you try to sleep in the day)

### Changed:
- Modified player pickup range to be slightly larger for 3D inventory pickup items
- Increase range of 3D inventory pickup item drop position from the player

### Fixed:
- Fixed being able to pause the game while dead
---
## Inventory

### Fixed:
- Fixed a bug where you could not pick 3D inventory pickup items up after trying to interact with them while the inventory was full
- Fixed Rock 3D pickup item mesh clipping into floor
---
## Settings

### Added:
- Mouse sensitivity slider
---
## Environment

### Added:
- Added day and night cycle with data persistence
- Added a bed that you can sleep in
- Added a chest that you can open and close, functionality coming later
- Added a workbench, functionality coming later
- Added collision to the tall white pillar supporting the black platform in the test area

---

# v0.5.0 (released)
Welcome to this huge release! We are already halfway there to v1.0.0. Look at the changelog below to see what was worked on from the last update (v0.4.7)!

---

## Player

### Fixed:

- Fixed health value not loading (#39)
- Fixed being able to interact with objects while paused, inside the inventory or dead
---
## Settings

### Added:
- Option to show the startup screen upon opening on or off
- Option to turn Motion Blur on or off
- Option to turn DOF effect on or off

### Changed:
- Modified UI
---
## Pause Layer

### Added:
- Added an extra button that takes you to the main menu
- Achievements button (with an interface upon being pressed, no achievements yet)
- Credits button (with an interface upon being pressed)
---
## Environment

### Added:
- Added a red spike to the test area, which when touched by the player, takes away 14 health
- Added some 3D pickup items to the testing area, which you can pick up
---
## Inventory

### Added:
- Data persistence (saving and loading of the inventory) (#38)
- Blue flower pickup item (#42)
- Pink flower pickup item (#45)
- Blank flower pickup item (#48)
- Pickaxe pick up item

### Changed:
- Modified UI

### Fixed:
- Fixed inventory pickup items not being able to be picked up in a cluster
- Fixed being able to dupe items when pickup up 3D object
---
## Main Menu

### Added:
- Game mode select menu upon pressing the play button
	- Story Mode (Locked)
	- Free Mode (Unlocked)
	- Parkour Mode (Locked)

- Fade out when transitioning to one of the game modes
- Achievements button (with an interface upon being pressed, no achievements yet)
- Credits button (with an interface upon being pressed)
