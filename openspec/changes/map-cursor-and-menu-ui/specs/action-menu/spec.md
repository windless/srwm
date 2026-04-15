## ADDED Requirements

### Requirement: ActionMenu displays unit action options
ActionMenu SHALL display a list of available actions for the selected unit.

#### Scenario: Menu shows when player unit selected
- **WHEN** a player-controlled unit is selected
- **THEN** ActionMenu SHALL display action options: Move, Attack, Spirit, Wait

#### Scenario: Menu hides when no unit selected
- **WHEN** no unit is selected or an enemy unit is selected
- **THEN** ActionMenu SHALL hide all action options

#### Scenario: Menu shows for enemy unit selection
- **WHEN** an enemy unit is selected
- **THEN** ActionMenu SHALL display limited options: Attack (if in range), Wait

### Requirement: ActionMenu action selection
ActionMenu SHALL emit signals when user selects an action.

#### Scenario: Action selection emits signal
- **WHEN** user taps on an action option
- **THEN** ActionMenu SHALL emit action_selected signal with action type enum

#### Scenario: Menu closes after action selection
- **WHEN** user selects an action
- **THEN** ActionMenu SHALL automatically hide after selection

### Requirement: ActionMenu action availability
ActionMenu SHALL mark actions as unavailable based on unit state.

#### Scenario: Move action disabled after movement
- **WHEN** selected unit has already moved this turn
- **THEN** Move action SHALL be displayed as disabled (grayed out)

#### Scenario: Attack action disabled when no targets
- **WHEN** selected unit has no valid attack targets in range
- **THEN** Attack action SHALL be displayed as disabled

#### Scenario: Disabled action cannot be selected
- **WHEN** user taps on a disabled action
- **THEN** ActionMenu SHALL NOT emit action_selected signal

### Requirement: ActionMenu touch-friendly layout
ActionMenu SHALL use touch-friendly sizing for mobile accessibility.

#### Scenario: Action button minimum size
- **WHEN** ActionMenu renders action buttons
- **THEN** each button SHALL have minimum touch area of 48x48 pixels

#### Scenario: Vertical layout for portrait mode
- **WHEN** device is in portrait orientation
- **THEN** ActionMenu SHALL arrange options in vertical list layout

### Requirement: ActionMenu integration with BattleHUD
ActionMenu SHALL be managed by BattleHUD for display positioning.

#### Scenario: ActionMenu positioned near selected unit
- **WHEN** ActionMenu is displayed for a selected unit
- **THEN** ActionMenu SHALL be positioned near the unit's screen location or at screen bottom

#### Scenario: BattleHUD controls ActionMenu visibility
- **WHEN** BattleHUD receives unit_selection_changed signal
- **THEN** BattleHUD SHALL show or hide ActionMenu based on unit type