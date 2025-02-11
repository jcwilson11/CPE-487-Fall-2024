LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY leddec16 IS
    PORT (
        dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);      -- which digit to currently display (0 to 7)
        data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);    -- 32-bit (8-digit) data
        anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);   -- which anode to turn on
        seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)      -- segment code for current digit
    );
END leddec16;

ARCHITECTURE Behavioral OF leddec16 IS
    SIGNAL data4 : STD_LOGIC_VECTOR (3 DOWNTO 0); -- binary value of current nibble
BEGIN
    -- Select 4-bit nibble based on dig
    data4 <= data(3 DOWNTO 0)       WHEN dig = "000" ELSE  -- digit 0 (least significant nibble)
             data(7 DOWNTO 4)       WHEN dig = "001" ELSE  -- digit 1
             data(11 DOWNTO 8)      WHEN dig = "010" ELSE  -- digit 2
             data(15 DOWNTO 12)     WHEN dig = "011" ELSE  -- digit 3
             data(19 DOWNTO 16)     WHEN dig = "100" ELSE  -- digit 4
             data(23 DOWNTO 20)     WHEN dig = "101" ELSE  -- digit 5
             data(27 DOWNTO 24)     WHEN dig = "110" ELSE  -- digit 6
             data(31 DOWNTO 28);                          -- digit 7 (most significant nibble)

    -- Segment decoding (assuming active low segments, adjust if needed)
    -- The codes below are standard 7-segment encodings for 0-F.
    seg <= "0000001" WHEN data4 = "0000" ELSE -- 0
           "1001111" WHEN data4 = "0001" ELSE -- 1
           "0010010" WHEN data4 = "0010" ELSE -- 2
           "0000110" WHEN data4 = "0011" ELSE -- 3
           "1001100" WHEN data4 = "0100" ELSE -- 4
           "0100100" WHEN data4 = "0101" ELSE -- 5
           "0100000" WHEN data4 = "0110" ELSE -- 6
           "0001111" WHEN data4 = "0111" ELSE -- 7
           "0000000" WHEN data4 = "1000" ELSE -- 8
           "0000100" WHEN data4 = "1001" ELSE -- 9
           "0001000" WHEN data4 = "1010" ELSE -- A
           "1100000" WHEN data4 = "1011" ELSE -- B
           "0110001" WHEN data4 = "1100" ELSE -- C
           "1000010" WHEN data4 = "1101" ELSE -- D
           "0110000" WHEN data4 = "1110" ELSE -- E
           "0111000" WHEN data4 = "1111" ELSE -- F
           "1111111";

    -- Activate the corresponding anode for the selected digit (assuming active low)
    anode <= "11111110" WHEN dig = "000" ELSE
             "11111101" WHEN dig = "001" ELSE
             "11111011" WHEN dig = "010" ELSE
             "11110111" WHEN dig = "011" ELSE
             "11101111" WHEN dig = "100" ELSE
             "11011111" WHEN dig = "101" ELSE
             "10111111" WHEN dig = "110" ELSE
             "01111111" WHEN dig = "111" ELSE
             "11111111";

END Behavioral;
