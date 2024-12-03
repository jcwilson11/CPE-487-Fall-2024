# CPE 487 Lab 1

**John Shea and Joris Wilson**  
**Professor Bernard Yett**  
**CPE 487**  
**9 October 2024**

## Lab 1

### Code Modification - Slow Down
- **Change Made:**  
  Changed `(28 downto 25)` and `(28 downto 0)` to `(29 downto 26)` and `(29 downto 0)`.  
- **Explanation:**  
  This changes which bits are used for the count output, and the higher bits toggle less frequently, causing the counter to update about half as fast.

### Code Modification - Change Location
- **Signals Added:**  
  `S`, `switch`, and `digLocation`:
  - `S`: Holds the 4-bit count value from the counter.
  - `switch`: Points to switch between digit locations.
  - `digLocation`: Selects which digit location to display and allows for the location to change.

- **Explanation:**  
  When `S` is `"0000"`, the `switch` signal toggles its state, so it changes periodically.  
  - If `switch` is `0`, `digLocation` is set to `"000"`.  
  - If `switch` is not `0`, `digLocation` is set to `"111"`.  

  Then, `digLocation` is fed into `leddec` to physically change the location of the light. Since this area of the code determines where the light is shown, we modified it to achieve the goal of having the light change location. Using `S = "0000"`, the light has a specific point at which it should change.

### Project 1 and 2 Results
- [Watch Video 1](https://youtu.be/FjeI1ry-u2o)  
- [Watch Video 2](https://youtu.be/FjeI1ry-u2o)

### Original Doc
[View original Google Doc with screenshots](https://docs.google.com/document/d/your-doc-id)
