## ADDED Requirements

### Requirement: UnitPlacement loads initial player unit positions
UnitPlacement SHALL place player units at predefined grid positions loaded from MapData or placement configuration.

#### Scenario: Player units placed at configured positions
- **WHEN** battle scene initializes with placement data
- **THEN** UnitPlacement SHALL create UnitRenderer instances for each player unit at specified GridCoord positions

#### Scenario: Invalid placement positions are skipped
- **WHEN** placement data contains positions outside map bounds
- **THEN** UnitPlacement SHALL skip invalid positions and log a warning

#### Scenario: Duplicate positions are handled
- **WHEN** placement data assigns multiple units to same grid position
- **THEN** UnitPlacement SHALL place only one unit at the position and log a conflict warning

### Requirement: UnitPlacement generates enemy units dynamically
UnitPlacement SHALL dynamically generate enemy units based on battle configuration at runtime.

#### Scenario: Enemy units generated from configuration
- **WHEN** battle starts with enemy configuration
- **THEN** UnitPlacement SHALL create enemy UnitRenderer instances at dynamically determined positions

#### Scenario: Enemy positions avoid player units
- **WHEN** placing enemy units
- **THEN** UnitPlacement SHALL not place enemies on grid cells occupied by player units

#### Scenario: Enemy count configurable
- **WHEN** battle configuration specifies enemy count
- **THEN** UnitPlacement SHALL generate exactly the specified number of enemy units

### Requirement: UnitPlacement manages unit instances
UnitPlacement SHALL maintain a collection of all active unit instances for battle systems to query.

#### Scenario: Query all units
- **WHEN** battle system requests all unit instances
- **THEN** UnitPlacement SHALL return an array of all UnitInstance objects (player and enemy)

#### Scenario: Query units by faction
- **WHEN** battle system requests units by faction type (player/enemy)
- **THEN** UnitPlacement SHALL return filtered array containing only units of requested faction

#### Scenario: Query unit at position
- **WHEN** battle system requests unit at specific GridCoord
- **THEN** UnitPlacement SHALL return the UnitInstance at that position or null if empty

### Requirement: UnitPlacement updates unit rendering order
UnitPlacement SHALL manage rendering order of unit sprites for correct isometric depth sorting.

#### Scenario: Units sorted by Y coordinate
- **WHEN** units are placed or moved on the map
- **THEN** UnitPlacement SHALL sort unit sprites by their grid Y coordinate for proper depth display

#### Scenario: Units at same Y sorted by X
- **WHEN** multiple units share the same Y coordinate
- **THEN** UnitPlacement SHALL sort by X coordinate to determine rendering order

### Requirement: UnitPlacement handles unit removal
UnitPlacement SHALL remove unit instances when units are destroyed or battle ends.

#### Scenario: Unit removal clears renderer
- **WHEN** a unit is destroyed (HP reaches 0)
- **THEN** UnitPlacement SHALL remove the UnitRenderer node and clear the position reference

#### Scenario: Position becomes available after removal
- **WHEN** unit is removed from a grid position
- **THEN** that grid position SHALL become available for subsequent queries (returns null)