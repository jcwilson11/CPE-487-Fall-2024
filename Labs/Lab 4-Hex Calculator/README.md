# CPE 487 Lab 4

**John Shea and Joris Wilson**  
**Professor Bernard Yett**  
**CPE 487**  
**25 November 2024**

## Lab 4

### Code Modifications
1. Uncommented the BTND button, and assigned it to 'bt_sub'. This button will serve as the 'minus' operator.
2. Added `bt_sub` to the `hexcalc.vhd` port list so it could be recognized as the 'minus' operator when pressed.
3. The `operation` signal is used to track which arithmetic operation (addition or subtraction) the calculator should perform when the equal button (`bt_eq`) is pressed. A value of ‘1’ is for addition, while ‘0’ is for subtraction.
4. `ENTER_ACC` was modified to add a subtraction operator, which is responsible for detecting when `bt_sub` is pressed, similar to the existing `bt_plus` button.
5. `ENTER_OP` was modified to perform subtraction if the `bt_sub` button was pressed earlier. If the condition is true, then the code `nx_acc <= acc - operand;` will handle the subtraction.
6. By checking the higher-order bits of the data, the display only turns on the digits that are non-zero or have significant values.

### Output Video
- [Watch Video 1](https://youtu.be/VckqlzMYJr8)

### Original Doc
[View original Google Doc with screenshots](https://docs.google.com/document/d/1Rd_SyJPM5wVIUDwk3gdu4AJ8rke1ucFBlFvMzZ3ITNQ/edit?usp=sharing)