## 1. Scene Structure Setup

- [x] 1.1 Create directory structure for battle scenes (`scenes/battle/`) and battle scripts (`scripts/battle/`)
- [x] 1.2 Create BattleMap scene file (`scenes/battle/battle_map.tscn`) with base node structure
- [x] 1.3 Add GridMapSystem, TileMapLayer, and GridVisualization nodes to BattleMap scene
- [x] 1.4 Add UnitsLayer (Node2D) container node for unit rendering
- [x] 1.5 Add placeholder CanvasLayer node for HUD structure

## 2. BattleCamera Implementation

- [x] 2.1 Create BattleCamera script (`scripts/battle/battle_camera.gd`) extending Camera2D
- [x] 2.2 Implement @export variables for zoom limits (min_zoom, max_zoom) and pan speed
- [x] 2.3 Implement single-finger drag pan gesture using InputEventScreenDrag
- [x] 2.4 Implement camera boundary clamping based on GridMapSystem bounds
- [x] 2.5 Implement two-finger pinch zoom using InputEventMagnifyGesture or touch tracking
- [x] 2.6 Implement grid cell selection detection from screen touch position
- [x] 2.7 Add grid_cell_selected signal emission with GridCoord parameter
- [x] 2.8 Implement focus_on_position() function for smooth camera transition
- [x] 2.9 Attach BattleCamera script to Camera2D node in BattleMap scene

## 3. UnitPlacement Implementation

- [x] 3.1 Create UnitPlacement script (`scripts/battle/unit_placement.gd`) extending Node
- [x] 3.2 Implement unit_registry Dictionary to track UnitInstance by GridCoord
- [x] 3.3 Implement place_player_units() function to load placement data and create UnitRenderer instances
- [x] 3.4 Implement generate_enemy_units() function for dynamic enemy placement
- [x] 3.5 Implement get_unit_at(coord) query function returning UnitInstance or null
- [x] 3.6 Implement get_all_units() and get_units_by_faction() query functions
- [x] 3.7 Implement dynamic Y-sorting for UnitsLayer children based on grid coordinates
- [x] 3.8 Implement remove_unit() function for unit destruction handling
- [x] 3.9 Add unit_placed and unit_removed signals for system integration
- [x] 3.10 Attach UnitPlacement script to BattleMap scene and connect to GridMapSystem

## 4. BattleHUD Implementation

- [x] 4.1 Create BattleHUD script (`scripts/battle/battle_hud.gd`) extending CanvasLayer
- [x] 4.2 Create UnitInfoPanel UI structure with labels for name, HP, EN, pilot
- [x] 4.3 Create ActionButtons UI structure with Move, Attack, Wait buttons
- [x] 4.4 Implement touch-friendly button sizing (minimum 48x48 pixels)
- [x] 4.5 Implement show_unit_info() function to display selected unit data
- [x] 4.6 Implement hide_unit_info() function for empty selection state
- [x] 4.7 Implement show_action_buttons() and hide_action_buttons() functions
- [x] 4.8 Connect action button signals to placeholder handlers
- [x] 4.9 Implement responsive layout using Container nodes and anchors
- [x] 4.10 Attach BattleHUD script to CanvasLayer node in BattleMap scene

## 5. Integration and Testing

- [x] 5.1 Connect BattleCamera grid_cell_selected signal to UnitPlacement and BattleHUD
- [x] 5.2 Connect UnitPlacement unit_placed signal to BattleHUD for potential updates
- [x] 5.3 Create test MapData Resource with sample terrain and player unit positions
- [x] 5.4 Create placeholder UnitData and PilotData Resources for testing
- [x] 5.5 Configure BattleMap scene with test map data and verify scene startup
- [x] 5.6 Verify camera pan and zoom work correctly with test map
- [x] 5.7 Verify grid cell selection triggers correct HUD updates
- [x] 5.8 Verify player and enemy units render at correct positions
- [x] 5.9 Run gdlint on all new script files and fix any issues
- [x] 5.10 Set battle_map.tscn as project main scene for testing