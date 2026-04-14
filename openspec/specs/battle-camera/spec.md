# BattleCamera Specification

## Requirements

### Requirement: Camera pan with touch drag
BattleCamera SHALL support single-finger drag gesture to pan the camera view across the battle map.

#### Scenario: Pan camera with finger drag
- **WHEN** user touches the screen with one finger and drags
- **THEN** camera position SHALL move in the opposite direction of the drag, respecting map boundaries

#### Scenario: Camera stops at map boundary
- **WHEN** user drags camera towards the edge of the map
- **THEN** camera SHALL stop moving when reaching the map boundary and SHALL not show areas outside the map

### Requirement: Camera zoom with pinch gesture
BattleCamera SHALL support two-finger pinch gesture to zoom in and out of the battle map.

#### Scenario: Zoom in with pinch gesture
- **WHEN** user performs pinch-in gesture (two fingers moving apart)
- **THEN** camera zoom level SHALL increase (view gets closer), bounded by max zoom level

#### Scenario: Zoom out with pinch gesture
- **WHEN** user performs pinch-out gesture (two fingers moving closer)
- **THEN** camera zoom level SHALL decrease (view gets farther), bounded by min zoom level

#### Scenario: Zoom level clamped to limits
- **WHEN** user attempts to zoom beyond configured limits
- **THEN** camera SHALL maintain zoom level at the nearest limit value

### Requirement: Grid cell selection with touch
BattleCamera SHALL detect and report the grid cell coordinates when user touches the map.

#### Scenario: Touch selects grid cell
- **WHEN** user touches a valid grid cell on the map
- **THEN** BattleCamera SHALL emit a signal with the selected GridCoord coordinates

#### Scenario: Touch outside map is ignored
- **WHEN** user touches an area outside the valid map grid
- **THEN** BattleCamera SHALL NOT emit any selection signal

#### Scenario: Touch selection tolerance
- **WHEN** user touches near a grid cell boundary (within tolerance radius)
- **THEN** BattleCamera SHALL select the nearest valid grid cell

### Requirement: Camera focus on unit
BattleCamera SHALL provide ability to focus the camera view on a specific unit.

#### Scenario: Focus on unit centers view
- **WHEN** camera focus is requested for a unit at specific grid coordinates
- **THEN** camera SHALL smoothly move to center the unit's position in the viewport

#### Scenario: Focus respects map boundaries
- **WHEN** focus target is near map edge
- **THEN** camera SHALL position to show the unit while staying within map boundaries

### Requirement: Camera configuration via export variables
BattleCamera SHALL expose configuration options as @export variables for editor customization.

#### Scenario: Configurable zoom limits
- **WHEN** designer sets min_zoom and max_zoom export variables
- **THEN** camera SHALL respect these limits during pinch zoom operations

#### Scenario: Configurable pan speed
- **WHEN** designer sets pan_speed export variable
- **THEN** camera drag response SHALL scale accordingly