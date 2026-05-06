# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test

This is a pure Xcode project — no Makefile, Fastfile, or package.json. All builds and tests go through `xcodebuild`.

```bash
# Build
xcodebuild -scheme HexaCalc -project HexaCalc.xcodeproj build

# Run all UI tests
xcodebuild -scheme HexaCalc -project HexaCalc.xcodeproj test

# Run only UI tests (unit test target HexaCalcTests is a template stub, not used)
xcodebuild -scheme HexaCalc -project HexaCalc.xcodeproj test -only-testing HexaCalcUITests

# Run a single UI test class
xcodebuild -scheme HexaCalc -project HexaCalc.xcodeproj test -only-testing HexaCalcUITests/SettingsHexaCalcUITests

# Run a single test method
xcodebuild -scheme HexaCalc -project HexaCalc.xcodeproj test -only-testing HexaCalcUITests/SettingsHexaCalcUITests/testClearLocalHistory
```

- Swift 5.0, iOS 13.0 deployment target
- No linter is configured

## Architecture

HexaCalc is a UIKit tab-bar calculator app for decimal, hexadecimal, and binary arithmetic. The four tabs are: Hexadecimal, Binary, Decimal, Settings.

### State sharing between tabs

`HexaCalcTabBarController` (the root) loads `UserPreferences` from disk and populates a `StateController` before any child VC appears. It passes `StateController` to each child via `StateControllerProtocol`. This means child VCs can read the current colour, tab visibility flags, and converted numeric values from `stateController?.convValues` — they do not load preferences themselves.

`StateController.convValues` carries the live cross-tab numeric state:
- `hexVal`, `binVal`, `decimalVal` — the same number in each base, kept in sync
- `largerThan64Bits` — overflow flag used by all three calculator tabs
- `colour`, `setCalculatorTextColour`, `copyActionIndex`, `pasteActionIndex`, `historyButtonViewIndex`, `defaultTabIndex`, `clearLocalHistory`

`clearLocalHistory` is a 3-bit flag (bit 0 = decimal, bit 1 = binary, bit 2 = hex). Each calculator VC checks its bit in `viewWillAppear` and clears its local `calculationHistory` array if set.

### Calculator base class

`CalculatorViewController` is the abstract base for all three calculator tabs. It holds:
- Shared instance state: `runningNumber`, `leftValue`, `rightValue`, `result`, `currentOperation`, `calculationHistory`
- `HistoryButtonHost` conformance: programmatic history button wired in `setupCommonViewWillAppear()`
- Gesture setup, clipboard copy/paste, and the history sheet presentation
- `setupCommonViewDidLoad()` — call at end of subclass `viewDidLoad`; applies theme colour from `stateController` (not from disk)
- `setupCommonViewWillAppear()` — call at end of subclass `viewWillAppear`; updates history button, gesture recognizers, history flag, text colour

Subclasses must override: `telemetryTab`, `historyFlagReadMask/Shift/ClearMask`, `outputLabelAccessibilityIdentifier`, `defaultLabelValue`, `deleteLastDigit()`, `pasteFromClipboard()`, `copyTextFromLabel()`, `updateThemeColour(_:)`.

### Persistence

`UserPreferences` (NSSecureCoding) is the on-disk model. `DataPersistence.loadPreferences()` / `savePreferences(_:)` handle archiving. `HexaCalcTabBarController` loads preferences at launch and on every tab switch; `SettingsViewController` saves after every change.

### Calculation history

Each calculator VC maintains a local `calculationHistory: [CalculationData]` array (not persisted). `CalculationData` stores left/right values, the `Operation`, result, and whether it was unary. New entries are `insert`ed at index 0 (newest first). The history sheet is a `CalculationHistoryViewController` wrapped in a `UINavigationController` and presented modally. Tapping a cell copies the result to the clipboard.

### History button

`HistoryButtonHost` (protocol + extension) manages the floating history button that appears on each calculator tab. `updateHistoryButton(stateController:)` drives three modes via `historyButtonViewIndex`: icon-only (0), text label (1), hidden (2).

### UI tests

All UI tests are in `HexaCalcUITests/`. `UITestHelper` contains static helpers for tapping operator buttons by name. Key accessibility identifiers used in tests: `"Hexadecimal Output Label"`, `"Binary Output Label"`, `"Decimal Output Label"`, `"History Button"`. Tests that disable tabs must re-enable them in `tearDownWithError` (not `tearDown`).
