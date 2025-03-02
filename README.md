# Balda Classic

Balda Classic is a word game for iOS where players compete to form words on a grid by adding letters. This implementation includes single-player mode against computer opponents with varying difficulty levels.

## Game Description

Balda is a classic word game where players take turns to:
1. Add one letter to the grid
2. Form a new word using that letter along with letters already on the grid
3. Score points based on the length of the word created

The game continues until the grid is filled or no more valid moves can be made.

## Features

- Single-player mode against computer opponents with different difficulty levels (Easy, Medium, Hard)
- Grid size options: 5×5, 7×7, and 9×9
- Language support: Russian and Dutch
- User profiles with customizable avatars
- Score tracking and word history
- Special gameplay mechanics including a "bomb" feature
- Game state saving for resuming later
- Animated UI elements and visual feedback
- Localization support (English and Russian)

## Technical Details

### Architecture

The game follows the MVC (Model-View-Controller) design pattern:

- **Models**: `GameGridState`, `Game`, `SearchResult`, etc.
- **Views**: `GridView`, `LetterKeyboardView`, `BottomPanelView`, etc.
- **Controllers**: `GameViewController`, `StartMenuViewController`, etc.

### Key Components

- **Game Logic**: 
  - `Game.swift`: Main game controller that manages turns, scoring, and game state
  - `Search.swift`: Implements the search algorithm for finding valid words
  - `Words.swift`: Dictionary and word validation management

- **UI Components**:
  - `GridView.swift`: Renders the game grid and handles cell interactions
  - `LetterKeyboardView.swift`: Custom keyboard for letter input
  - `Score.swift`: Displays player scores and word history
  - `BottomPanelView.swift`: Control panel with game action buttons

- **Opponents**:
  - `Opponent.swift`: Base class for all opponent types
  - `LocalOpponent.swift`: Human player implementation
  - `CompOpponent.swift`: AI opponent with difficulty levels

### Dictionary System

The game uses a trie-based dictionary system for efficient word lookup and validation. Dictionary files are stored as assets and loaded based on the selected language and difficulty level.

### Future Game Center Integration

The codebase includes initial work for Game Center integration through the `GameCreator` class, though multiplayer functionality is not yet implemented.

## Installation

### Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

### Building

1. Clone the repository
2. Open `balda-2.xcodeproj` in Xcode
3. Select your target device
4. Build and run the project

## Game Controls

- **Skip Button**: Skip your turn
- **New Game Button**: Start a new game
- **Finish Step Button**: Complete your turn
- **Undo Selection Button**: Clear your current selection

## Development Notes

- UI is designed to work on both iPhone and iPad with appropriate scaling
- The game includes debug flags for testing purposes:
  - `UI_TEST_NINE`: Forces 9×9 grid
  - `UI_TEST_SEVEN`: Forces 7×7 grid
  - `UI_TEST_TRIGGER_GENERIC_EVENT`: Triggers computer moves with a delay

## Future Improvements

- Multiplayer functionality
- Online play via Game Center
- Additional languages
- More customization options
- Enhanced animations and visual effects
- Achievements and statistics tracking

## License

[Specify license information]

## Credits

[Add developer credits and acknowledgments]
