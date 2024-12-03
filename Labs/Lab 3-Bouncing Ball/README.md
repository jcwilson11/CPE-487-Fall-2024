# CPE 487 Lab 3

**John Shea and Joris Wilson**  
**Professor Bernard Yett**  
**CPE 487**  
**28 November 2024**

## Lab 3

### Code Modifications

1. **Signal Addition and Size Change**:  
   - Added the signal `ball_x_motion`.  
   - Increased its size from 8 to 32 to make it larger.

2. **Color Change and Circle Equation**:  
   - Changed the color of the ball from red to blue.  
   - Added variables to solve the circle equation.

3. **Ball Movement Behavior**:  
   - Added the same behavior for `ball_x_motion` as for `ball_y_motion`, allowing the ball to move side-to-side as well as up and down.  
   - Rearranged the following lines to compute the next ball position:  
     ```
     ball_y <= ball_y + ball_y_motion;
     ball_x <= ball_x + ball_x_motion;
     ```

### VGA Videos
- [Watch Video 1](https://youtu.be/xrt0AXfFmtM)  

### Original Doc
[View original Google Doc with screenshots](https://docs.google.com/document/d/1ROy8CPTgUZUbSV76cZOaLqMLRypXB0nCyCbcdEzuMKU/edit?usp=sharing)
