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
    CONSTANT bsize : INTEGER := 16; -- ball size in pixels
    CONSTANT player_w : INTEGER := 16; -- bat width in pixels
    CONSTANT player_h : INTEGER := 16; -- bat height in pixels
    SIGNAL ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL player_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    --ball
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(120, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball1
    SIGNAL ball_x1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(220, 11);
    SIGNAL ball_y1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion1, ball_y_motion1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on1 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball2
    SIGNAL ball_x2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(320, 11);
    SIGNAL ball_y2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion2, ball_y_motion2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on2 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball3
    SIGNAL ball_x3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(420, 11);
    SIGNAL ball_y3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion3, ball_y_motion3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on3 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball4
    SIGNAL ball_x4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(520, 11);
    SIGNAL ball_y4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion4, ball_y_motion4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on4 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball5
    SIGNAL ball_x5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(620, 11);
    SIGNAL ball_y5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motion5, ball_y_motion5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_on5 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball
    SIGNAL ball_xr : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(170, 11);
    SIGNAL ball_yr : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr, ball_y_motionr : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball1
    SIGNAL ball_xr1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(270, 11);
    SIGNAL ball_yr1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr1, ball_y_motionr1 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr1 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball2
    SIGNAL ball_xr2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(370, 11);
    SIGNAL ball_yr2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr2, ball_y_motionr2 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr2 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball3
    SIGNAL ball_xr3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(470, 11);
    SIGNAL ball_yr3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr3, ball_y_motionr3 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr3 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball4
    SIGNAL ball_xr4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(570, 11);
    SIGNAL ball_yr4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr4, ball_y_motionr4 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr4 : STD_LOGIC; -- indicates whether ball is at current pixel position
    --ball5
    SIGNAL ball_xr5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(670, 11);
    SIGNAL ball_yr5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL ball_x_motionr5, ball_y_motionr5 : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL ball_onr5 : STD_LOGIC; -- indicates whether ball is at current pixel position

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
    green <= NOT (ball_on OR ball_on1 OR ball_on2 OR ball_on3 OR ball_on4 OR ball_on5 OR ball_onr OR ball_onr1 OR ball_onr2 OR ball_onr3 OR ball_onr4 OR ball_onr5);
    blue <= NOT (ball_on OR ball_on1 OR ball_on2 OR ball_on3 OR ball_on4 OR ball_on5 OR ball_onr OR ball_onr1 OR ball_onr2 OR ball_onr3 OR ball_onr4 OR ball_onr5) AND (left_home_on OR right_home_on);
    ball_speed <= CONV_STD_LOGIC_VECTOR (CONV_INTEGER(sw)+1, 11);

    -- Process to draw round ball
    balldraw : PROCESS (ball_x, ball_y, ball_x1, ball_y1, ball_x2, ball_y2, ball_x3, ball_y3, ball_x4, ball_y4, ball_x5, ball_y5, ball_xr, ball_yr, ball_xr1, ball_yr1, ball_xr2, ball_yr2, ball_xr3, ball_yr3, ball_xr4, ball_yr4, ball_xr5, ball_yr5, pixel_row, pixel_col) IS
        VARIABLE vx, vy, vx1, vy1, vx2, vy2, vx3, vy3, vx4, vy4, vx5, vy5, vxr, vyr, vxr1, vyr1, vxr2, vyr2, vxr3, vyr3, vxr4, vyr4, vxr5, vyr5  : STD_LOGIC_VECTOR (10 DOWNTO 0);
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
        
        --3rd ball
        IF pixel_col <= ball_x2 THEN
            vx2 := ball_x2 - pixel_col;
        ELSE
            vx2 := pixel_col - ball_x2;
        END IF;
        IF pixel_row <= ball_y2 THEN
            vy2 := ball_y2 - pixel_row;
        ELSE
            vy2 := pixel_row - ball_y2;
        END IF;
        IF ((vx2 * vx2) + (vy2 * vy2)) < (bsize * bsize) THEN
            ball_on2 <= game_on;
        ELSE
            ball_on2 <= '0';
        END IF;
        
        --4th ball
        IF pixel_col <= ball_x3 THEN
            vx3 := ball_x3 - pixel_col;
        ELSE
            vx3 := pixel_col - ball_x3;
        END IF;
        IF pixel_row <= ball_y3 THEN
            vy3 := ball_y3 - pixel_row;
        ELSE
            vy3 := pixel_row - ball_y3;
        END IF;
        IF ((vx3 * vx3) + (vy3 * vy3)) < (bsize * bsize) THEN
            ball_on3 <= game_on;
        ELSE
            ball_on3 <= '0';
        END IF;
        
        --5th ball
        IF pixel_col <= ball_x4 THEN
            vx4 := ball_x4 - pixel_col;
        ELSE
            vx4 := pixel_col - ball_x4;
        END IF;
        IF pixel_row <= ball_y4 THEN
            vy4 := ball_y4 - pixel_row;
        ELSE
            vy4 := pixel_row - ball_y4;
        END IF;
        IF ((vx4 * vx4) + (vy4 * vy4)) < (bsize * bsize) THEN
            ball_on4 <= game_on;
        ELSE
            ball_on4 <= '0';
        END IF;
        
        --6th ball
        IF pixel_col <= ball_x5 THEN
            vx5 := ball_x5 - pixel_col;
        ELSE
            vx5 := pixel_col - ball_x5;
        END IF;
        IF pixel_row <= ball_y5 THEN
            vy5 := ball_y5 - pixel_row;
        ELSE
            vy5 := pixel_row - ball_y5;
        END IF;
        IF ((vx5 * vx5) + (vy5 * vy5)) < (bsize * bsize) THEN
            ball_on5 <= game_on;
        ELSE
            ball_on5 <= '0';
        END IF;
        --1st ball
        IF pixel_col <= ball_xr THEN
            vxr := ball_xr - pixel_col;
        ELSE
            vxr := pixel_col - ball_xr;
        END IF;
        IF pixel_row <= ball_yr THEN
            vyr := ball_yr - pixel_row;
        ELSE
            vyr := pixel_row - ball_yr;
        END IF;
        IF ((vxr * vxr) + (vyr * vyr)) < (bsize * bsize) THEN
            ball_onr <= game_on;
        ELSE
            ball_onr <= '0';
        END IF;
        
        --2nd ball
        IF pixel_col <= ball_xr1 THEN
            vxr1 := ball_xr1 - pixel_col;
        ELSE
            vxr1 := pixel_col - ball_xr1;
        END IF;
        IF pixel_row <= ball_yr1 THEN
            vyr1 := ball_yr1 - pixel_row;
        ELSE
            vyr1 := pixel_row - ball_yr1;
        END IF;
        IF ((vxr1 * vxr1) + (vyr1 * vyr1)) < (bsize * bsize) THEN
            ball_onr1 <= game_on;
        ELSE
            ball_onr1 <= '0';
        END IF;
        
        --3rd ball
        IF pixel_col <= ball_xr2 THEN
            vxr2 := ball_xr2 - pixel_col;
        ELSE
            vxr2 := pixel_col - ball_xr2;
        END IF;
        IF pixel_row <= ball_yr2 THEN
            vyr2 := ball_yr2 - pixel_row;
        ELSE
            vyr2 := pixel_row - ball_yr2;
        END IF;
        IF ((vxr2 * vxr2) + (vyr2 * vyr2)) < (bsize * bsize) THEN
            ball_onr2 <= game_on;
        ELSE
            ball_onr2 <= '0';
        END IF;
        
        --4th ball
        IF pixel_col <= ball_xr3 THEN
            vxr3 := ball_xr3 - pixel_col;
        ELSE
            vxr3 := pixel_col - ball_xr3;
        END IF;
        IF pixel_row <= ball_yr3 THEN
            vyr3 := ball_yr3 - pixel_row;
        ELSE
            vyr3 := pixel_row - ball_yr3;
        END IF;
        IF ((vxr3 * vxr3) + (vyr3 * vyr3)) < (bsize * bsize) THEN
            ball_onr3 <= game_on;
        ELSE
            ball_onr3 <= '0';
        END IF;
        
        --5th ball
        IF pixel_col <= ball_xr4 THEN
            vxr4 := ball_xr4 - pixel_col;
        ELSE
            vxr4 := pixel_col - ball_xr4;
        END IF;
        IF pixel_row <= ball_yr4 THEN
            vyr4 := ball_yr4 - pixel_row;
        ELSE
            vyr4 := pixel_row - ball_yr4;
        END IF;
        IF ((vxr4 * vxr4) + (vyr4 * vyr4)) < (bsize * bsize) THEN
            ball_onr4 <= game_on;
        ELSE
            ball_onr4 <= '0';
        END IF;
        
        --6th ball
        IF pixel_col <= ball_xr5 THEN
            vxr5 := ball_xr5 - pixel_col;
        ELSE
            vxr5 := pixel_col - ball_xr5;
        END IF;
        IF pixel_row <= ball_yr5 THEN
            vyr5 := ball_yr5 - pixel_row;
        ELSE
            vyr5 := pixel_row - ball_yr5;
        END IF;
        IF ((vxr5 * vxr5) + (vyr5 * vyr5)) < (bsize * bsize) THEN
            ball_onr5 <= game_on;
        ELSE
            ball_onr5 <= '0';
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
        VARIABLE temp, temp1, temp2, temp3, temp4, temp5, tempr, tempr1, tempr2, tempr3, tempr4, tempr5 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        --IF serve = '1' AND game_on = '0' THEN
        IF game_on = '0' THEN
            local_hit_count <= (OTHERS => '0'); -- Reset hit count
            hit_detected <= '0'; -- Reset hit detection flag
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 1;
            ball_y_motion1 <= (NOT ball_speed) + 1;
            ball_y_motion2 <= (NOT ball_speed) + 1;
            ball_y_motion3 <= (NOT ball_speed) + 1;
            ball_y_motion4 <= (NOT ball_speed) + 1;
            ball_y_motion5 <= (NOT ball_speed) + 1;
            ball_y_motionr <=  ball_speed + 1;
            ball_y_motionr1 <= ball_speed + 1;
            ball_y_motionr2 <= ball_speed + 1;
            ball_y_motionr3 <= ball_speed + 1;
            ball_y_motionr4 <= ball_speed + 1;
            ball_y_motionr5 <= ball_speed + 1;
        ELSIF ball_y <= bsize THEN
            --bounce off top wall
            ball_y_motion <= ball_speed;
            ball_y_motion1 <= ball_speed;
            ball_y_motion2 <= ball_speed;
            ball_y_motion3 <= ball_speed;
            ball_y_motion4 <= ball_speed;
            ball_y_motion5 <= ball_speed;
        ELSIF ball_yr <= bsize THEN
            ball_y_motionr <=  ball_speed;
            ball_y_motionr1 <= ball_speed;
            ball_y_motionr2 <= ball_speed;
            ball_y_motionr3 <= ball_speed;
            ball_y_motionr4 <= ball_speed;
            ball_y_motionr5 <= ball_speed;
        ELSIF ball_y + bsize >= 600 THEN
            ball_y_motion <= (NOT ball_speed) + 1;
            ball_y_motion1 <= (NOT ball_speed) + 1;
            ball_y_motion2 <= (NOT ball_speed) + 1;
            ball_y_motion3 <= (NOT ball_speed) + 1;
            ball_y_motion4 <= (NOT ball_speed) + 1;
            ball_y_motion5 <= (NOT ball_speed) + 1;
        ELSIF ball_yr + bsize >= 600 THEN  
            ball_y_motionr <=  (NOT ball_speed) + 1;
            ball_y_motionr1 <= (NOT ball_speed) + 1;
            ball_y_motionr2 <= (NOT ball_speed) + 1;
            ball_y_motionr3 <= (NOT ball_speed) + 1;
            ball_y_motionr4 <= (NOT ball_speed) + 1;
            ball_y_motionr5 <= (NOT ball_speed) + 1;
            --game_on <= '0';
        ELSIF ball_x + bsize >= 800 THEN
            ball_x_motion <= (NOT ball_speed) + 1;
        ELSIF ball_x <= bsize THEN
            ball_x_motion <= ball_speed;
        ELSIF ball_x1 + bsize >= 800 THEN
            ball_x_motion1 <= (NOT ball_speed) + 1;
        ELSIF ball_x1 <= bsize THEN
            ball_x_motion1 <= ball_speed;
        ELSIF ball_x2 + bsize >= 800 THEN
            ball_x_motion2 <= (NOT ball_speed) + 1;
        ELSIF ball_x2 <= bsize THEN
            ball_x_motion2 <= ball_speed;
        ELSIF ball_x3 + bsize >= 800 THEN
            ball_x_motion3 <= (NOT ball_speed) + 1;
        ELSIF ball_x3 <= bsize THEN
            ball_x_motion3 <= ball_speed;
        ELSIF ball_x4 + bsize >= 800 THEN
            ball_x_motion4 <= (NOT ball_speed) + 1;
        ELSIF ball_x4 <= bsize THEN
            ball_x_motion4 <= ball_speed;
        ELSIF ball_x5 + bsize >= 800 THEN
            ball_x_motion5 <= (NOT ball_speed) + 1;
        ELSIF ball_x5 <= bsize THEN
            ball_x_motion5 <= ball_speed;
        ELSIF ball_xr + bsize >= 800 THEN
            ball_x_motionr <= (NOT ball_speed) + 1;
        ELSIF ball_xr <= bsize THEN
            ball_x_motionr <= ball_speed;
        ELSIF ball_xr1 + bsize >= 800 THEN
            ball_x_motionr1 <= (NOT ball_speed) + 1;
        ELSIF ball_xr1 <= bsize THEN
            ball_x_motionr1 <= ball_speed;
        ELSIF ball_xr2 + bsize >= 800 THEN
            ball_x_motionr2 <= (NOT ball_speed) + 1;
        ELSIF ball_xr2 <= bsize THEN
            ball_x_motionr2 <= ball_speed;
        ELSIF ball_xr3 + bsize >= 800 THEN
            ball_x_motionr3 <= (NOT ball_speed) + 1;
        ELSIF ball_xr3 <= bsize THEN
            ball_x_motionr3 <= ball_speed;
        ELSIF ball_xr4 + bsize >= 800 THEN
            ball_x_motionr4 <= (NOT ball_speed) + 1;
        ELSIF ball_xr4 <= bsize THEN
            ball_x_motionr4 <= ball_speed;
        ELSIF ball_xr5 + bsize >= 800 THEN
            ball_x_motionr5 <= (NOT ball_speed) + 1;
        ELSIF ball_xr5 <= bsize THEN
            ball_x_motionr5 <= ball_speed;
        END IF;


        -- Bounce off bat and increment hit count
        IF (ball_x + bsize/2) >= (player_x - player_w) AND
            (ball_x - bsize/2) <= (player_x + player_w) AND
            (ball_y + bsize/2) >= (player_y - player_h) AND
            (ball_y - bsize/2) <= (player_y + player_h) THEN
            --ball_y_motion <= (NOT ball_speed) + 1; -- Bounce back
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
            ball_y <= CONV_STD_LOGIC_VECTOR(300, 11);
                
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
            ball_y1 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF temp1(11) = '1' THEN
            ball_y1 <= (OTHERS => '0');
        ELSE
            ball_y1 <= temp1(10 DOWNTO 0);
        END IF;

        temp1 := ('0' & ball_x1) + (ball_x_motion1(10) & ball_x_motion1);
        IF temp1(11) = '1' THEN
            ball_x1 <= (OTHERS => '0');
        ELSE
            ball_x1 <= temp1(10 DOWNTO 0);
        END IF;
        
        -- Update ball position: 3rd ball
        temp2 := ('0' & ball_y2) + (ball_y_motion2(10) & ball_y_motion2);
        IF game_on = '0' THEN
            ball_y2 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF temp2(11) = '1' THEN
            ball_y2 <= (OTHERS => '0');
        ELSE
            ball_y2 <= temp2(10 DOWNTO 0);
        END IF;

        temp2 := ('0' & ball_x2) + (ball_x_motion2(10) & ball_x_motion2);
        IF temp2(11) = '1' THEN
            ball_x2 <= (OTHERS => '0');
        ELSE
            ball_x2 <= temp2(10 DOWNTO 0);
        END IF;

        -- Update ball position: 4th ball
        temp3 := ('0' & ball_y3) + (ball_y_motion3(10) & ball_y_motion3);
        IF game_on = '0' THEN
            ball_y3 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF temp3(11) = '1' THEN
            ball_y3 <= (OTHERS => '0');
        ELSE
            ball_y3 <= temp3(10 DOWNTO 0);
        END IF;

        temp3 := ('0' & ball_x3) + (ball_x_motion3(10) & ball_x_motion3);
        IF temp3(11) = '1' THEN
            ball_x3 <= (OTHERS => '0');
        ELSE
            ball_x3 <= temp3(10 DOWNTO 0);
        END IF;
        -- Update ball position: 4th ball
        temp4 := ('0' & ball_y4) + (ball_y_motion4(10) & ball_y_motion4);
        IF game_on = '0' THEN
            ball_y4 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF temp4(11) = '1' THEN
            ball_y4 <= (OTHERS => '0');
        ELSE
            ball_y4 <= temp4(10 DOWNTO 0);
        END IF;

        temp4 := ('0' & ball_x4) + (ball_x_motion4(10) & ball_x_motion4);
        IF temp4(11) = '1' THEN
            ball_x4 <= (OTHERS => '0');
        ELSE
            ball_x4 <= temp4(10 DOWNTO 0);
        END IF;
        -- Update ball position: 4th ball
        temp5 := ('0' & ball_y5) + (ball_y_motion5(10) & ball_y_motion5);
        IF game_on = '0' THEN
            ball_y5 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF temp5(11) = '1' THEN
            ball_y5 <= (OTHERS => '0');
        ELSE
            ball_y5 <= temp5(10 DOWNTO 0);
        END IF;

        temp5 := ('0' & ball_x5) + (ball_x_motion5(10) & ball_x_motion5);
        IF temp5(11) = '1' THEN
            ball_x5 <= (OTHERS => '0');
        ELSE
            ball_x5 <= temp5(10 DOWNTO 0);
        END IF;
        
        -- Update ball position: 1st ball
        tempr := ('0' & ball_yr) + (ball_y_motionr(10) & ball_y_motionr);
        IF game_on = '0' THEN
            ball_yr <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr(11) = '1' THEN
            ball_yr <= (OTHERS => '0');
        ELSE
            ball_yr <= tempr(10 DOWNTO 0);
        END IF;

        tempr := ('0' & ball_xr) + (ball_x_motionr(10) & ball_x_motionr);
        IF tempr(11) = '1' THEN
            ball_xr <= (OTHERS => '0');
        ELSE
            ball_xr <= tempr(10 DOWNTO 0);
        END IF;
        
        -- Update ball position: 2nd ball
        tempr1 := ('0' & ball_yr1) + (ball_y_motionr1(10) & ball_y_motionr1);
        IF game_on = '0' THEN
            ball_yr1 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr1(11) = '1' THEN
            ball_yr1 <= (OTHERS => '0');
        ELSE
            ball_yr1 <= tempr1(10 DOWNTO 0);
        END IF;

        tempr1 := ('0' & ball_xr1) + (ball_x_motionr1(10) & ball_x_motionr1);
        IF tempr1(11) = '1' THEN
            ball_xr1 <= (OTHERS => '0');
        ELSE
            ball_xr1 <= tempr1(10 DOWNTO 0);
        END IF;
        
        -- Update ball position: 3rd ball
        tempr2 := ('0' & ball_yr2) + (ball_y_motionr2(10) & ball_y_motionr2);
        IF game_on = '0' THEN
            ball_yr2 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr2(11) = '1' THEN
            ball_yr2 <= (OTHERS => '0');
        ELSE
            ball_yr2 <= tempr2(10 DOWNTO 0);
        END IF;

        tempr2 := ('0' & ball_xr2) + (ball_x_motionr2(10) & ball_x_motionr2);
        IF tempr2(11) = '1' THEN
            ball_xr2 <= (OTHERS => '0');
        ELSE
            ball_xr2 <= tempr2(10 DOWNTO 0);
        END IF;

        -- Update ball position: 4th ball
        tempr3 := ('0' & ball_yr3) + (ball_y_motionr3(10) & ball_y_motionr3);
        IF game_on = '0' THEN
            ball_yr3 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr3(11) = '1' THEN
            ball_yr3 <= (OTHERS => '0');
        ELSE
            ball_yr3 <= tempr3(10 DOWNTO 0);
        END IF;

        tempr3 := ('0' & ball_xr3) + (ball_x_motionr3(10) & ball_x_motionr3);
        IF tempr3(11) = '1' THEN
            ball_xr3 <= (OTHERS => '0');
        ELSE
            ball_xr3 <= tempr3(10 DOWNTO 0);
        END IF;
        -- Update ball position: 4th ball
        tempr4 := ('0' & ball_yr4) + (ball_y_motionr4(10) & ball_y_motionr4);
        IF game_on = '0' THEN
            ball_yr4 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr4(11) = '1' THEN
            ball_yr4 <= (OTHERS => '0');
        ELSE
            ball_yr4 <= tempr4(10 DOWNTO 0);
        END IF;

        tempr4 := ('0' & ball_xr4) + (ball_x_motionr4(10) & ball_x_motionr4);
        IF tempr4(11) = '1' THEN
            ball_xr4 <= (OTHERS => '0');
        ELSE
            ball_xr4 <= tempr4(10 DOWNTO 0);
        END IF;
        -- Update ball position: 4th ball
        tempr5 := ('0' & ball_yr5) + (ball_y_motionr5(10) & ball_y_motionr5);
        IF game_on = '0' THEN
            ball_yr5 <= CONV_STD_LOGIC_VECTOR(300, 11);
                
        ELSIF tempr5(11) = '1' THEN
            ball_yr5 <= (OTHERS => '0');
        ELSE
            ball_yr5 <= tempr5(10 DOWNTO 0);
        END IF;

        tempr5 := ('0' & ball_xr5) + (ball_x_motionr5(10) & ball_x_motionr5);
        IF tempr5(11) = '1' THEN
            ball_xr5 <= (OTHERS => '0');
        ELSE
            ball_xr5 <= tempr5(10 DOWNTO 0);
        END IF;
        
    END PROCESS;

    -- Output hit count
    hit_count <= local_hit_count;

END Behavioral;