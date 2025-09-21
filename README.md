# Dice Roller - SwiftUI App

## Overview

Dice Roller is a single-screen SwiftUI app that simulates rolling two dice with smooth animations, haptic feedback, and optional sound effects. Designed with a clean, Apple-polished interface, this app is perfect for showcasing SwiftUI skills, animations, and interactive UI elements.

## Features

* **Animated Dice Roll**: Dice numbers change rapidly while spinning and scaling, simulating a real dice roll.
* **Haptic Feedback**: Subtle vibration enhances the rolling experience.
* **Sound Effects**: Optional dice-roll sound (add `dice-roll.wav` to bundle).
* **Polished UI**: Rounded dice with pip-style faces, gradient background, and spring animations.
* **Responsive Design**: Works on multiple devices, supporting light and dark modes.


## Installation

1. Clone or download the repository.
2. Open in Xcode (version 15+ recommended).
3. Ensure `ContentView.swift` contains the Dice Roller code.
4. (Optional) Add `dice-roll.wav` to your app bundle for sound effects.
5. Build & run on an iPhone or simulator.

## Usage

1. Launch the app.
2. Tap the **Roll** button to roll the dice.
3. Watch the dice animate with spin and scale effects.
4. Feel haptic feedback as the dice roll.
5. Hear optional dice-roll sound if included.
6. The dice settle on final numbers after the animation.

## Code Structure

* `ContentView.swift`: Main view containing UI layout and rolling logic.
* `DieView`: Custom SwiftUI view representing a single die with pip-style dots.
* `rollDice()` function: Async logic to animate dice rolling, haptics, and final result.
* Sound handling: `AVAudioPlayer` optional setup for dice-roll sound.

## Customization

* Change dice colors, background gradient, or dice size.
* Adjust animation speed and spring damping for different roll effects.
* Replace pip-style dice with image assets if desired.

## Requirements

* Xcode 15+
* iOS 15+ (for async/await usage)
* Swift 5.8+

## Future Improvements

* Shake gesture to roll dice.
* Pass-and-play multiplayer mode.
* Dice trail animation for more dynamic rolls.
* High-resolution dice image assets for realism.

## License

This project is open-source for personal and educational use.
