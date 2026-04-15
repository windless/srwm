## MODIFIED Requirements

### Requirement: HUD displays selected unit information
BattleHUD SHALL display detailed information about the currently selected unit when a unit is selected, and SHALL manage ActionMenu display.

#### Scenario: Unit selection shows unit info
- **WHEN** a unit is selected via touch or click
- **THEN** BattleHUD SHALL display unit name, current HP/max HP, current EN/max EN, and pilot name

#### Scenario: No selection hides unit info
- **WHEN** no unit is selected (empty grid or deselection)
- **THEN** BattleHUD SHALL hide or clear the unit information panel AND hide ActionMenu

#### Scenario: Enemy unit selection shows limited info
- **WHEN** an enemy unit is selected
- **THEN** BattleHUD SHALL display unit name and HP only (no detailed stats for enemies) AND show limited ActionMenu options

### Requirement: HUD provides action menu system
BattleHUD SHALL provide ActionMenu component for player unit operations instead of hardcoded buttons.

#### Scenario: ActionMenu visible when player unit selected
- **WHEN** a player-controlled unit is selected
- **THEN** BattleHUD SHALL show ActionMenu with Move, Attack, Spirit, Wait options

#### Scenario: ActionMenu hidden when no player unit selected
- **WHEN** no player unit is selected or enemy unit is selected
- **THEN** BattleHUD SHALL hide ActionMenu

#### Scenario: Action selection callback
- **WHEN** user selects an action from ActionMenu
- **THEN** BattleHUD SHALL emit action_requested signal with action type

## REMOVED Requirements

### Requirement: HUD provides action buttons
**Reason**: Replaced by dynamic ActionMenu system for full action flow support
**Migration**: Use ActionMenu component instead of hardcoded Move/Attack/Wait buttons. ActionMenu provides extensible action options with availability states.

## ADDED Requirements

### Requirement: HUD action signal forwarding
BattleHUD SHALL forward action selection signals to BattleMapController.

#### Scenario: Action signal forwarded to controller
- **WHEN** ActionMenu emits action_selected signal
- **THEN** BattleHUD SHALL emit action_requested signal with action type and selected unit reference

#### Scenario: Action signal includes unit context
- **WHEN** action_requested signal is emitted
- **THEN** signal SHALL include selected unit reference for controller processing