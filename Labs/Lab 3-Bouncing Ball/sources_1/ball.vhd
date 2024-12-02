LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
    PORT (
        v_sync    : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        red       : OUT STD_LOGIC;
        green     : OUT STD_LOGIC;
        blue      : OUT STD_LOGIC
    );
END ball;

ARCHITECTURE Behavioral OF ball IS
    CONSTANT size  : INTEGER := 32;
    SIGNAL ball_on : STD_LOGIC; 
    SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
    SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100"; 
BEGIN
    red <= NOT ball_on; 
    green <= NOT ball_on;
    blue  <= '1';
    bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col)
        VARIABLE px, py, bx, by, dx, dy, distSquared : INTEGER;
    BEGIN
        px := CONV_INTEGER(pixel_col);
        py := CONV_INTEGER(pixel_row);
        bx := CONV_INTEGER(ball_x);
        by := CONV_INTEGER(ball_y);
        dx := px - bx;
        dy := py - by;
        distSquared := dx*dx + dy*dy;
        IF distSquared <= size*size THEN
            ball_on <= '1';
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    mball : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF CONV_INTEGER(ball_y) + size >= 600 THEN
            ball_y_motion <= "11111111100"; 
        ELSIF CONV_INTEGER(ball_y) - size <= 0 THEN
            ball_y_motion <= "00000000100"; 
        END IF;
        IF CONV_INTEGER(ball_x) + size >= 800 THEN
            ball_x_motion <= "11111111100";
        ELSIF CONV_INTEGER(ball_x) - size <= 0 THEN
            ball_x_motion <= "00000000100"; 
        END IF;
        ball_y <= ball_y + ball_y_motion; 
        ball_x <= ball_x + ball_x_motion;
    END PROCESS;
END Behavioral;
