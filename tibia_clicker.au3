;
; Tibia clicker
;
; This is a script that adds some tweaks to the tibia desktop client.
;
;               end = toggles attacking the first enemy in the enemy list
;         page down = toggles attacking the second enemy in the enemy list
;           page up = toggles attacking the third enemy in the enemy list
;               end = toggles attacking the third enemy in the enemy list
;  single quote (') = toggles pressing the hotkey "F4" constantly with a cooldown period
;        hyphen (-) = wear invisibility ring from the first inventory slot
;         alt + esc = exits the script
;
; Prerequisites:
;
; Tibia client must be active.
; The order of windows on the right side panel must be the following:
; First the battle window with the default height, about 4 enemies.
; Below it must be the inventory where the first item must be an invisibility ring.



const $battle_pos_x = 1204 ; battle window x position on screen
const $battle_pos_y = 435 ; first enemy position on screen
const $battle_gap_y = 23 ; relative next enemy position
const $mouse_move_speed = 2 ; speed 0-100 of moving mouse to attack
AutoItSetOption("MouseClickDelay", 25) ; delay in ms when clicking attack

const $ring_slot_pos_x = 1215 ; ring slot position on screen
const $ring_slot_pos_y = 282
const $backpack_first_pos_x = 1215 ; first inventory slot position on screen
const $backpack_first_pos_y = 558
AutoItSetOption("MouseClickDragDelay", 25) ; delay in ms when dragging the ring to ring slot

const $spell_button = "{F4}" ; https://www.autoitscript.com/autoit3/docs/appendix/SendKeys.htm
const $spell_casting_cooldown = 2000 ; in ms



const $title_of_this_robot = "tibia clicker"
const $splash_pos_x = 1000 ; Location of info messages. 100 for left, 1000 for right
const $splash_pos_y = 550 ; 150 for top, 550 for bottom
global $attack_spell_on = false
global $already_pressing = false

HotKeySet("{HOME}", "keypress_hook_attack_enemy_4")
HotKeySet("{PGUP}", "keypress_hook_attack_enemy_3")
HotKeySet("{PGDN}", "keypress_hook_attack_enemy_2")
HotKeySet("{END}", "keypress_hook_attack_enemy_1")
HotKeySet("'", "keypress_hook_spell_attack_toggle")
HotKeySet("-", "keypress_hook_put_ring_on");
HotKeySet("^!{ESC}", "msg_and_terminate") ; quit





; --- main loop start -------------------------------------------------------------------

print_with_splash("Started...", 500)

While True
  If IsPressed('04') Then ; 04 = middle mouse button
    send("{CTRLDOWN}")
    MouseClick("left")
    send("{CTRLUP}")
  ElseIf IsPressed('02') Then ; 02 = right mouse button
    MouseClick("left")
    send("{SHIFTDOWN}")
    sleep(50)
    MouseClick("left")
    sleep(50)
    send("{SHIFTUP}")
  EndIf
  Sleep(100)
Wend

terminate()

; --- main loop end ---------------------------------------------------------------------



Func keypress_hook_attack_enemy_1()
  click_attack_enemy(1)
EndFunc

Func keypress_hook_attack_enemy_2()
  click_attack_enemy(2)
EndFunc

Func keypress_hook_attack_enemy_3()
  click_attack_enemy(3)
EndFunc

Func keypress_hook_attack_enemy_4()
  click_attack_enemy(4)
EndFunc



Func click_attack_enemy($enemy_number)
  If winactive("Tibia") Then
    $starting_point_x = MouseGetPos(0)
    $starting_point_y = MouseGetPos(1)
;    print_with_splash("Clicked enemy " & $enemy_number, 200)
    MouseClick("left", $battle_pos_x, $battle_pos_y + $battle_gap_y * ($enemy_number - 1), 1, $mouse_move_speed)
    MouseMove($starting_point_x, $starting_point_y, $mouse_move_speed)
  Else
    HotKeySet(@HotKeyPressed)
    Send(@HotKeyPressed)
    HotKeySet(@HotKeyPressed, "keypress_hook_attack_enemy_" & $enemy_number)
  EndIf
EndFunc



Func keypress_hook_put_ring_on()
  If winactive("Tibia") Then
    MouseClickDrag("left", $backpack_first_pos_x, $backpack_first_pos_y, $ring_slot_pos_x, $ring_slot_pos_y, 0)
  Else
	HotKeySet(@HotKeyPressed)
    Send(@HotKeyPressed)
    HotKeySet(@HotKeyPressed, "keypress_hook_put_ring_on")
  EndIf
EndFunc



Func keypress_hook_spell_attack_toggle()
  If winactive("Tibia") Then
    If $attack_spell_on Then
      $attack_spell_on = False
      print_with_splash("Attack spell off", 1000)
    Else
      $attack_spell_on = True
      print_with_splash("Attack spell on", 1000)
    EndIf
    While $attack_spell_on
      Send($spell_button)
      Sleep($spell_casting_cooldown)
    WEnd
  Else
    HotKeySet(@HotKeyPressed)
    Send(@HotKeyPressed)
    HotKeySet(@HotKeyPressed, "keypress_hook_spell_attack_toggle")
  EndIf
EndFunc



; --- helper functions begin ---
Func terminate()
  Exit 0
EndFunc

Func msg_and_terminate()
  print_with_splash("Bye!", 300)
  Exit 0
EndFunc

Func print_with_splash($input_text, $delay)
  SplashTextOn($title_of_this_robot, $input_text, 300, 100, $splash_pos_x, $splash_pos_y)
  sleep($delay)
  SplashOff()
EndFunc

Func IsPressed($hexKey)
  Local $aR, $bO
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
    $bO = 1
  Else
    $bO = 0
  EndIf
  Return $bO
EndFunc  ;==>_IsPressed

#cs
  01 Left mouse button
  02 Right mouse button
  04 Middle mouse button (three-button mouse)
  05 Windows 2000/XP: X1 mouse button
  06 Windows 2000/XP: X2 mouse button
  08 BACKSPACE key
  09 TAB key
  0C CLEAR key
  0D ENTER key
  10 SHIFT key
  11 CTRL key
  12 ALT key
  13 PAUSE key
  14 CAPS LOCK key
  1B ESC key
  20 SPACEBAR
  21 PAGE UP key
  22 PAGE DOWN key
  23 END key
  24 HOME key
  25 LEFT ARROW key
  26 UP ARROW key
  27 RIGHT ARROW key
  28 DOWN ARROW key
  29 SELECT key
  2A PRINT key
  2B EXECUTE key
  2C PRINT SCREEN key
  2D INS key
  2E DEL key
  30 0 key
  31 1 key
  32 2 key
  33 3 key
  34 4 key
  35 5 key
  36 6 key
  37 7 key
  38 8 key
  39 9 key
  41 A key
  42 B key
  43 C key
  44 D key
  45 E key
  46 F key
  47 G key
  48 H key
  49 I key
  4A J key
  4B K key
  4C L key
  4D M key
  4E N key
  4F O key
  50 P key
  51 Q key
  52 R key
  53 S key
  54 T key
  55 U key
  56 V key
  57 W key
  58 X key
  59 Y key
  5A Z key
  5B Left Windows key
  5C Right Windows key
  60 Numeric keypad 0 key
  61 Numeric keypad 1 key
  62 Numeric keypad 2 key
  63 Numeric keypad 3 key
  64 Numeric keypad 4 key
  65 Numeric keypad 5 key
  66 Numeric keypad 6 key
  67 Numeric keypad 7 key
  68 Numeric keypad 8 key
  69 Numeric keypad 9 key
  6A Multiply key
  6B Add key
  6C Separator key
  6D Subtract key
  6E Decimal key
  6F Divide key
  70 F1 key
  71 F2 key
  72 F3 key
  73 F4 key
  74 F5 key
  75 F6 key
  76 F7 key
  77 F8 key
  78 F9 key
  79 F10 key
  7A F11 key
  7B F12 key
  7C-7F F13 key - F16 key
  80H-87H F17 key - F24 key
  90 NUM LOCK key
  91 SCROLL LOCK key
  A0 Left SHIFT key
  A1 Right SHIFT key
  A2 Left CONTROL key
  A3 Right CONTROL key
  A4 Left MENU key
  A5 Right MENU key
#ce

; --- helper functions end ---
