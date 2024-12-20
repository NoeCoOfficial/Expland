<h1 align="center">Expland Changelog</h1>

# v0.6.0 (unreleased)

---

<!--
## Player

### Added:
- Added a minimal alert UI (triggered when you try to sleep in the day)

### Changed:
- Modified player pickup range to be slightly larger for 3D inventory pickup items
- Increase range of 3D inventory pickup item drop position from the player

### Fixed:
- Fixed being able to pause the game while dead
-->

## Inventory

### Added:
- Yellow flower pickup item (currently can't obtain) (#46)
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
