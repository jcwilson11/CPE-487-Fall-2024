LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY stopwatch IS
    PORT (
        clk         : IN STD_LOGIC;      
        reset       : IN STD_LOGIC;
        one_sec_en  : IN STD_LOGIC;
        pause       : IN STD_LOGIC;  -- pause input for stopping count
        display_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF stopwatch IS
    SIGNAL count : INTEGER RANGE 0 TO 9999 := 0;
    SIGNAL running : STD_LOGIC := '1'; -- start running after reset anyway

    FUNCTION to_bcd(i : INTEGER) RETURN STD_LOGIC_VECTOR IS
        VARIABLE bcd : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        VARIABLE val : INTEGER := i;
        VARIABLE d0, d1, d2, d3 : INTEGER;
    BEGIN
        d0 := val MOD 10;
        val := val / 10;
        d1 := val MOD 10;
        val := val / 10;
        d2 := val MOD 10;
        val := val / 10;
        d3 := val MOD 10;

        bcd(3 DOWNTO 0)   := STD_LOGIC_VECTOR(to_unsigned(d0,4));
        bcd(7 DOWNTO 4)   := STD_LOGIC_VECTOR(to_unsigned(d1,4));
        bcd(11 DOWNTO 8)  := STD_LOGIC_VECTOR(to_unsigned(d2,4));
        bcd(15 DOWNTO 12) := STD_LOGIC_VECTOR(to_unsigned(d3,4));
        RETURN bcd;
    END FUNCTION;

BEGIN
    process(clk)
    begin
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                count <= 0;
                running <= '1';
            ELSIF running = '1' AND one_sec_en = '1' AND pause = '0' THEN
                IF count < 9999 THEN
                    count <= count + 1;
                ELSE
                    count <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    display_out <= to_bcd(count);

END Behavioral;
