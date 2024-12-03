# CPE 487 Lab 5

**John Shea and Joris Wilson**  
**Professor Bernard Yett**  
**CPE 487**  
**18 November 2024**

## Lab 5

### Code Modifications

1. **New Pin Assignments**:  
   - Added pin assignments for `BTN0` and switches `SW0` to `SW7`.  
   - These changes allow the button and switches on the Nexys board to toggle the square wave and wailing speeds.

2. **New Signal Additions**:  
   - Added the signal `button_press`.  
   - Added `btn_press` in the `tone` component to make the input from the board recognizable.

3. **Waveform Representation**:  
   - Added signals `data_sq` and `data_tri` to represent signed waveform data for square and triangular waveforms.

4. **Tone Selection Process**:  
   - Added the `tone_select` process with the following logic:  
     - If the button is pressed (value = 1), the output switches to a square wave.  
     - Otherwise, the output remains a triangular wave.

5. **Behavioral Influence**:  
   - Integrated the button and switches inputs in `siren.vhd` to influence the siren or audio output behavior.

6. **Wailing Speed Mapping**:  
   - Mapped the wailing speed to switches `SW0` through `SW7`.

### Output Audio
- [Listen to Output 1](https://youtu.be/y-jfuzQGs14)  

### Original Doc
[View original Google Doc with screenshots](https://docs.google.com/document/d/1CUlVUBVd_gILIffb810iZs1zga4gk_hLlAP-UVj9vB0/edit?usp=sharing)
