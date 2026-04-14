# BattleHUD Specification

## Requirements

### Requirement: HUD displays selected unit information
BattleHUD SHALL display detailed information about the currently selected unit when a unit is selected.

#### Scenario: Unit selection shows unit info
- **WHEN** a unit is selected via touch or click
- **THEN** BattleHUD SHALL display unit name, current HP/max HP, current EN/max EN, and pilot name

#### Scenario: No selection hides unit info
- **WHEN** no unit is selected (empty grid or deselection)
- **THEN** BattleHUD SHALL hide or clear the unit information panel

#### Scenario: Enemy unit selection shows limited info
- **WHEN** an enemy unit is selected
- **THEN** BattleHUD SHALL display unit name and HP only (no detailed stats for enemies)

### Requirement: HUD provides action buttons
BattleHUD SHALL provide touch-friendly action buttons for player unit operations.

#### Scenario: Action buttons visible when player unit selected
- **WHEN** a player-controlled unit is selected
- **THEN** BattleHUD SHALL show Move, Attack, and Wait action buttons

#### Scenario: Action buttons hidden when no player unit selected
- **WHEN** no player unit is selected or enemy unit is selected
- **THEN** BattleHUD SHALL hide all action buttons

#### Scenario: Touch-friendly button sizing
- **WHEN** HUD renders action buttons
- **THEN** each button SHALL have minimum touch area of 48x48 pixels for mobile accessibility

### Requirement: HUD adapts to mobile screen sizes
BattleHUD SHALL adapt its layout to different mobile screen dimensions and orientations.

#### Scenario: Portrait orientation layout
- **WHEN** device is in portrait orientation
- **THEN** HUD SHALL arrange unit info panel at top and action buttons at bottom

#### Scenario: Landscape orientation layout
- **WHEN** device is in landscape orientation
- **THEN** HUD SHALL arrange unit info panel at left/right side with action buttons adjacent

#### Scenario: Safe area margins
- **WHEN** HUD renders on device with notches or rounded corners
- **THEN** HUD SHALL respect device safe area margins to avoid occlusion

### Requirement: HUD signal-based updates
BattleHUD SHALL respond to signals from battle systems to update display state.

#### Scenario: Unit selection signal triggers update
- **WHEN** unit_selection_changed signal is received with unit data
- **THEN** HUD SHALL update unit info panel with new unit information

#### Scenario: Unit HP change signal triggers update
- **WHEN** unit_hp_changed signal is received
- **THEN** HUD SHALL refresh HP display for the affected unit if it is currently selected