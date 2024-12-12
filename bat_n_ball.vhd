LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY player_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        player_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat x position
        player_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat y position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        hit_count : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- successful hits counter
        SW : IN STD_LOGIC_VECTOR (4 DOWNTO 0)
    
           
    );
END player_n_ball;

ARCHITECTURE Behavioral OF player_n_ball IS
    CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    CONSTANT player_w : INTEGER := 8; -- bat width in pixels
    CONSTANT player_h : INTEGER := 8; -- bat height in pixels
    SIGNAL ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL player_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    --ball
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(150, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball1
    SIGNAL ball_x1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(250, 11);
    SIGNAL ball_y1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion1, ball_y_motion1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on1 : STD_LOGIC; -- indicates whether ball is at current pixel position
    -- Add signal for hit counter
    SIGNAL local_hit_count : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL hit_detected : STD_LOGIC := '0'; -- Tracks whether the bat-ball collision is active

    --home base size/position
    CONSTANT home_base_width : INTEGER := 100;  -- New width of the square
    CONSTANT home_base_height : INTEGER := 160; -- New height of the square
    CONSTANT left_home_x : INTEGER := home_base_width / 2; -- Center of the left square
    CONSTANT right_home_x : INTEGER := 800 - (home_base_width / 2); -- Center of the right square
    CONSTANT home_base_y : INTEGER := 300; -- Vertical center for both squares
    SIGNAL left_home_on : STD_LOGIC; -- Signal for the left home base
    SIGNAL right_home_on : STD_LOGIC; -- Signal for the right home base
BEGIN
    --Process to draw home bases
    homedraw : PROCESS (pixel_row, pixel_col)
    BEGIN
        --left home base
        IF (pixel_col >= left_home_x - home_base_width / 2 AND pixel_col <= left_home_x + home_base_width / 2) AND
           (pixel_row >= home_base_y - home_base_height / 2 AND pixel_row <= home_base_y + home_base_height / 2) THEN
            left_home_on <= '1';
        ELSE
            left_home_on <= '0';
        END IF;
        
        --right home base
        IF (pixel_col >= right_home_x - home_base_width / 2 AND pixel_col <= right_home_x + home_base_width / 2) AND
           (pixel_row >= home_base_y - home_base_height / 2 AND pixel_row <= home_base_y + home_base_height / 2) THEN
            right_home_on <= '1';
        ELSE
            right_home_on <= '0';
        END IF;
    END PROCESS;


    red <= NOT player_on; -- color for setup
    green <= NOT (ball_on OR ball_on1);
    blue <= NOT (ball_on OR ball_on1) AND (left_home_on OR right_home_on);
    ball_speed <= CONV_STD_LOGIC_VECTOR (CONV_INTEGER(sw)+1, 11);

    -- Process to draw round ball
    balldraw : PROCESS (ball_x, ball_y, ball_x1, ball_y1, pixel_row, pixel_col) IS
        VARIABLE vx, vy, vx1, vy1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
    BEGIN
        --1st ball
        IF pixel_col <= ball_x THEN
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
        
        --2nd ball
        IF pixel_col <= ball_x1 THEN
            vx1 := ball_x1 - pixel_col;
        ELSE
            vx1 := pixel_col - ball_x1;
        END IF;
        IF pixel_row <= ball_y1 THEN
            vy1 := ball_y1 - pixel_row;
        ELSE
            vy1 := pixel_row - ball_y1;
        END IF;
        IF ((vx1 * vx1) + (vy1 * vy1)) < (bsize * bsize) THEN
            ball_on1 <= game_on;
        ELSE
            ball_on1 <= '0';
        END IF;
    END PROCESS;

    -- Process to draw bat
    playerdraw : PROCESS (player_x, pixel_row, pixel_col) IS
    BEGIN
        --define player as a 16 by 16 square
        IF (pixel_col >= player_x - player_w AND pixel_col <= player_x + player_w) AND
            (pixel_row >= player_y - player_h AND pixel_row <= player_y + player_h) THEN
            player_on <= '1';
        ELSE
            player_on <= '0';
        END IF;
    END PROCESS;

    -- Process to move ball once every frame
    mball : PROCESS
        VARIABLE temp, temp1 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        --IF serve = '1' AND game_on = '0' THEN
        IF game_on = '0' THEN
            local_hit_count <= (OTHERS => '0'); -- Reset hit count
            hit_detected <= '0'; -- Reset hit detection flag
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 1;
        ELSIF ball_y <= bsize THEN
            --bounce off top wall
            ball_y_motion <= ball_speed;
        ELSIF ball_y + bsize >= 600 THEN
            ball_y_motion <= (NOT ball_speed) + 1;
            --game_on <= '0';
        END IF;

        -- Bounce off left or right walls
        IF ball_x + bsize >= 800 THEN
            ball_x_motion <= (NOT ball_speed) + 1;
        ELSIF ball_x <= bsize THEN
            ball_x_motion <= ball_speed;
        END IF;

        -- Bounce off bat and increment hit count
        IF (ball_x + bsize/2) >= (player_x - player_w) AND
            (ball_x - bsize/2) <= (player_x + player_w) AND
            (ball_y + bsize/2) >= (player_y - player_h) AND
            (ball_y - bsize/2) <= (player_y + player_h) THEN
            ball_y_motion <= (NOT ball_speed) + 1; -- Bounce back
            -- Increment hit count only if it's a new hit
            IF hit_detected = '0' THEN
                local_hit_count <= local_hit_count + 1; -- Increment hit count
            END IF;
            hit_detected <= '1'; -- Mark the collision as detected
        ELSE
            hit_detected <= '0'; -- Reset the hit detection flag when no collision
        END IF;

        -- Update ball position: 1st ball
        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(440, 11);
                
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE
            ball_y <= temp(10 DOWNTO 0);
        END IF;

        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE
            ball_x <= temp(10 DOWNTO 0);
        END IF;
        
        -- Update ball position: 2nd ball
        temp1 := ('0' & ball_y1) + (ball_y_motion1(10) & ball_y_motion1);
        IF game_on = '0' THEN
            ball_y1 <= CONV_STD_LOGIC_VECTOR(440, 11);
                
        ELSIF temp1(11) = '1' THEN
            ball_y1 <= (OTHERS => '0');
        ELSE
            ball_y1 <= temp(10 DOWNTO 0);
        END IF;

        temp1 := ('0' & ball_x1) + (ball_x_motion1(10) & ball_x_motion1);
        IF temp1(11) = '1' THEN
            ball_x1 <= (OTHERS => '0');
        ELSE
            ball_x1 <= temp(10 DOWNTO 0);
        END IF;

    END PROCESS;

    -- Output hit count
    hit_count <= local_hit_count;

END Behavioral;