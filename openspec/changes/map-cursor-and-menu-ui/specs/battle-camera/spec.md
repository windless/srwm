## ADDED Requirements

### Requirement: Camera cursor movement signal
BattleCamera SHALL emit cursor movement signal when user indicates interest in a grid cell.

#### Scenario: Cursor moved on touch hover
- **WHEN** user touches a valid grid cell (before confirmation)
- **THEN** BattleCamera SHALL emit cursor_moved signal with GridCoord

#### Scenario: Cursor moved ignored outside map
- **WHEN** user touches outside valid map grid
- **THEN** BattleCamera SHALL NOT emit cursor_moved signal

### Requirement: Camera cursor confirmation signal
BattleCamera SHALL emit cursor confirmation signal when user confirms grid cell selection.

#### Scenario: Cursor confirmed on tap release
- **WHEN** user releases touch on a valid grid cell (short touch, not drag)
- **THEN** BattleCamera SHALL emit cursor_confirmed signal with GridCoord

#### Scenario: Cursor confirmation requires non-drag touch
- **WHEN** user was dragging camera during touch
- **THEN** BattleCamera SHALL NOT emit cursor_confirmed signal (drag ends without selection)

#### Scenario: Cursor confirmed only once per touch
- **WHEN** user touches and releases on same cell
- **THEN** BattleCamera SHALL emit cursor_confirmed signal exactly once

## MODIFIED Requirements

### Requirement: Grid cell selection with touch
BattleCamera SHALL detect and report the grid cell coordinates when user confirms selection (renamed from selection to confirmation).

#### Scenario: Touch confirms grid cell
- **WHEN** user confirms a valid grid cell selection via cursor_confirmed signal
- **THEN** the GridCoord SHALL be available for unit selection or action menu display

#### Scenario: Touch outside map is ignored
- **WHEN** user touches an area outside the valid map grid
- **THEN** BattleCamera SHALL NOT emit any cursor signals

#### Scenario: Touch selection tolerance
- **WHEN** user touches near a grid cell boundary (within tolerance radius)
- **THEN** BattleCamera SHALL select the nearest valid grid cell for cursor signals