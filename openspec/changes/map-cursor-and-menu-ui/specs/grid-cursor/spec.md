## ADDED Requirements

### Requirement: GridCursor displays selected grid cell
GridCursor SHALL render a visual indicator (border highlight) on the currently selected grid cell.

#### Scenario: Cursor shows on valid cell selection
- **WHEN** a valid grid cell is selected via touch or click
- **THEN** GridCursor SHALL render a border highlight at the selected cell's screen position

#### Scenario: Cursor hides when selection is cleared
- **WHEN** no grid cell is selected (deselection)
- **THEN** GridCursor SHALL hide the visual indicator

#### Scenario: Cursor updates on cell change
- **WHEN** selection moves to a different grid cell
- **THEN** GridCursor SHALL update its position to the new cell's screen position with smooth animation

### Requirement: GridCursor position conversion
GridCursor SHALL correctly convert grid coordinates to screen position for rendering.

#### Scenario: Isometric coordinate conversion
- **WHEN** GridCursor receives a GridCoord
- **THEN** GridCursor SHALL convert the coordinate to screen position using isometric projection (cell_size = Vector2(128, 64))

#### Scenario: Coordinate conversion via GridMapSystem
- **WHEN** GridCursor has a GridMapSystem reference
- **THEN** GridCursor SHALL use GridMapSystem.get_screen_from_coord() for accurate conversion

### Requirement: GridCursor visual styling
GridCursor SHALL provide configurable visual styling options.

#### Scenario: Configurable border color
- **WHEN** designer sets border_color export variable
- **THEN** GridCursor SHALL render border lines with the specified color

#### Scenario: Configurable border width
- **WHEN** designer sets border_width export variable
- **THEN** GridCursor SHALL render border lines with the specified width

#### Scenario: Selection state color change
- **WHEN** grid cell selection is confirmed (double tap or long press)
- **THEN** GridCursor SHALL change border color to indicate confirmed state

### Requirement: GridCursor animation
GridCursor SHALL support smooth animation for position changes.

#### Scenario: Smooth position transition
- **WHEN** GridCursor moves to a new grid cell
- **THEN** GridCursor SHALL animate position change over configurable duration (default 0.2 seconds)

#### Scenario: Animation respects frame rate
- **WHEN** GridCursor animation is active
- **THEN** animation SHALL use Tween for smooth interpolation without frame-by-frame updates

### Requirement: GridCursor signal integration
GridCursor SHALL respond to signals from BattleCamera for cursor movement.

#### Scenario: Subscribe to cursor_moved signal
- **WHEN** BattleCamera emits cursor_moved signal with GridCoord
- **THEN** GridCursor SHALL update its position to the new coordinate

#### Scenario: Subscribe to cursor_confirmed signal
- **WHEN** BattleCamera emits cursor_confirmed signal with GridCoord
- **THEN** GridCursor SHALL change visual state to confirmed (color change)