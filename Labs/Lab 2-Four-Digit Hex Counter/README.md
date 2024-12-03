# CPE 487 Lab 2

**John Shea and Joris Wilson**  
**Professor Bernard Yett**  
**CPE 487**  
**28 October 2024**

## Lab 2

### Board Behavior After Upload
After successfully uploading the code to the board:
- The counter started at `1` and progressed to `F`.
- When the FSM recognized the predefined sequence `11110`, it output a signal `Z` that toggled the direction register (`dir_reg`), causing the counter to switch between counting up and counting down.

### Code Modifications

1. **FSM Integration**:  
   This section of the code sets up the necessary infrastructure to integrate an FSM into the counter design. By:
   - Declaring the FSM's states and signals.
   - Assigning an input from the counter.
   - Introducing a direction register.  

   This enabled the FSM to influence the counter's operation based on detected input patterns.

2. **Clock and Update Process**:  
   - Updated the present state (`PS <= NS;`) on each rising edge of the clock to synchronize the FSM's state transitions.
   - Added logic to toggle `dir_reg` when the FSM's output `Z` is `'1'`, ensuring the counter's counting direction is based on the FSM's output.

3. **FSM Logic Process**:  
   - Implemented the FSM's state transition and output logic for the sequence `11110`.
   - Determined the next state (`NS`) and output `Z` based on the current state (`PS`) and input `X`.
   - Defined how the FSM moves through states A to F, setting `Z` appropriately to detect specific input patterns and influence the counter's behavior.

### Other Observations
The "only flip between `0` and `1` one time" requirement ensures:
- The FSM's output `Z` changes state only once per detection of the specific input pattern.
- This prevents multiple toggles of the counter's direction during a single occurrence of the pattern.  
- By allowing `Z` to flip only once per pattern detection, stable operation is maintained, ensuring the counter completes a full counting sequence in one direction before changing direction upon the next valid pattern.

### Board Videos
- [Watch Video 1](https://youtu.be/yk2_WGGwr_U)  

### Original Doc
[View original Google Doc with screenshots](https://docs.google.com/document/d/1GqubGTIyKJm3QomBfpseqcerr7aCv2zogg8wi0C5C2M/edit?usp=sharing)
