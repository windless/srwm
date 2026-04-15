## 1. GridCursor Implementation

- [x] 1.1 Create GridCursor script at `scripts/ui/grid_cursor.gd` with Node2D base class
- [x] 1.2 Implement border rendering using Line2D nodes (4 lines for isometric cell)
- [x] 1.3 Add @export variables: border_color, border_width, animation_duration, grid_map_system
- [x] 1.4 Implement set_coord() method for GridCoord to screen position conversion
- [x] 1.5 Implement smooth position animation using Tween
- [x] 1.6 Add set_confirmed_state() method for visual state change (color)
- [x] 1.7 Create GridCursor scene at `scenes/ui/grid_cursor.tscn` with Line2D children

## 2. MenuPanel Implementation

- [x] 2.1 Create MenuPanel script at `scripts/ui/menu_panel.gd` with PanelContainer base class
- [x] 2.2 Add @export variables: option_font_size, panel_background, animation_duration
- [x] 2.3 Implement set_options() method accepting Array[Dictionary] with name and enabled fields
- [x] 2.4 Implement button list generation using VBoxContainer
- [x] 2.5 Add option_selected signal emission on button press
- [x] 2.6 Implement disabled option visual style (grayed out, non-interactive)
- [x] 2.7 Implement show/hide animation using Tween
- [x] 2.8 Create MenuPanel scene at `scenes/ui/menu_panel.tscn`

## 3. ActionMenu Implementation

- [x] 3.1 Create ActionMenu script at `scripts/ui/action_menu.gd` extending MenuPanel
- [x] 3.2 Define ActionType enum: MOVE, ATTACK, SPIRIT, WAIT
- [x] 3.3 Implement set_unit() method to generate appropriate action options
- [x] 3.4 Add action_selected signal with ActionType parameter
- [x] 3.5 Implement action availability check based on unit state (moved, has_targets)
- [x] 3.6 Create ActionMenu scene at `scenes/ui/action_menu.tscn`

## 4. BattleCamera Signal Extension

- [x] 4.1 Add cursor_moved signal to BattleCamera script
- [x] 4.2 Add cursor_confirmed signal to BattleCamera script
- [x] 4.3 Modify _handle_touch() to distinguish cursor movement vs confirmation
- [x] 4.4 Implement touch duration check for confirmation (short tap vs drag)
- [x] 4.5 Emit cursor_moved on initial touch position
- [x] 4.6 Emit cursor_confirmed on touch release if not dragging

## 5. BattleHUD Refactoring

- [x] 5.1 Remove hardcoded Move/Attack/Wait button references from BattleHUD
- [x] 5.2 Add ActionMenu component reference as @export variable
- [x] 5.3 Modify on_unit_selection_changed() to show/hide ActionMenu
- [x] 5.4 Add action_requested signal forwarding from ActionMenu
- [x] 5.5 Update BattleHUD scene to use ActionMenu instead of button HBoxContainer

## 6. BattleMapController Integration

- [x] 6.1 Add GridCursor node reference to BattleMapController
- [x] 6.2 Connect BattleCamera.cursor_moved to GridCursor.set_coord()
- [x] 6.3 Connect BattleCamera.cursor_confirmed to GridCursor.set_confirmed_state()
- [x] 6.4 Connect BattleHUD.action_requested to controller action handler
- [x] 6.5 Implement placeholder action handlers (print debug message)

## 7. Scene Integration

- [x] 7.1 Update battle_map.tscn to add GridCursor node
- [x] 7.2 Update battle_map.tscn BattleHUD structure to include ActionMenu
- [x] 7.3 Verify all node paths and export references are correct
- [x] 7.4 Run scene and verify cursor movement, menu display, and signal flow

## 8. Testing

- [x] 8.1 Create test file `test/ui/test_grid_cursor.gd` for GridCursor functionality
- [x] 8.2 Create test file `test/ui/test_menu_panel.gd` for MenuPanel functionality
- [x] 8.3 Create test file `test/ui/test_action_menu.gd` for ActionMenu functionality
- [x] 8.4 Run all tests and verify passing