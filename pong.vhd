LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pong IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC;
        btnu : IN STD_LOGIC;
        btnd : IN STD_LOGIC;
        btn0 : IN STD_LOGIC;
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- anodes of four 7-seg displays
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (4 DOWNTO 0)
    ); 
END pong;

ARCHITECTURE Behavioral OF pong IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
    SIGNAL S_red, S_green, S_blue : STD_LOGIC;
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL player_x : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(75, 11);
    SIGNAL player_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11); -- Initial Y position of the square
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    SIGNAL display : STD_LOGIC_VECTOR (15 DOWNTO 0); -- value to be displayed on 7-segment
    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0); -- 7-segment multiplexing clock
    SIGNAL hit_count : STD_LOGIC_VECTOR (15 DOWNTO 0); -- signal for hit count
    SIGNAL old_hit_count : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    COMPONENT player_n_ball IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            player_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            player_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            reset : IN STD_LOGIC;
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
            hit_count : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- successful hits
            SW : IN STD_LOGIC_VECTOR (4 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT clk_wiz_0 IS
        PORT (
            clk_in1  : IN STD_LOGIC;
            clk_out1 : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT leddec16 IS
        PORT (
            dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        );
    END COMPONENT; 
BEGIN
    -- Clock process
    pos : PROCESS (clk_in) 
    BEGIN
        IF rising_edge(clk_in) THEN
            count <= count + 1;
            -- Check if a new hit has occurred
            IF hit_count > old_hit_count THEN
                -- Reset player position
                player_x <= CONV_STD_LOGIC_VECTOR(75, 11);   -- original x position
                player_y <= CONV_STD_LOGIC_VECTOR(300, 11);  -- original y position
            ELSIF btnd = '1' THEN
                player_x <= CONV_STD_LOGIC_VECTOR(75, 11);   -- original x position
                player_y <= CONV_STD_LOGIC_VECTOR(300, 11);  -- original y position
            END IF;
        
            -- Update old_hit_count for next cycle
            old_hit_count <= hit_count;
            IF (btnl = '1' AND count = 0 AND player_x > 20) THEN
                player_x <= player_x - 5;
            ELSIF (btnr = '1' AND count = 0 AND player_x < 780) THEN
                player_x <= player_x + 5;
            END IF;
            
            IF (btnu = '1' AND count = 0 AND player_y > 20) THEN
                player_y <= player_y - 5; -- Move up
            ELSIF (btn0 = '1' AND count = 0 AND player_y < 580) THEN
                player_y <= player_y + 5; -- Move down
            END IF;
        END IF;
    END PROCESS;

    -- 7-segment multiplexing clock
    led_mpx <= count(19 DOWNTO 17);

    -- Instantiate bat and ball component
    add_bb : player_n_ball
    PORT MAP(
        v_sync => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        player_x => player_x, 
        player_y => player_y,
        reset => btnd, 
        red => S_red, 
        green => S_green, 
        blue => S_blue,
        hit_count => hit_count,-- Connect hit count signal
        SW => SW
    );

    -- VGA sync component
    vga_driver : vga_sync
    PORT MAP(
        pixel_clk => pxl_clk, 
        red_in => S_red & "000", 
        green_in => S_green & "000", 
        blue_in => S_blue & "000", 
        red_out => VGA_red, 
        green_out => VGA_green, 
        blue_out => VGA_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync => VGA_hsync, 
        vsync => S_vsync
    );

    -- VGA vsync output
    VGA_vsync <= S_vsync;

    -- Clock wizard component
    clk_wiz_0_inst : clk_wiz_0
    PORT MAP(
        clk_in1 => clk_in,
        clk_out1 => pxl_clk
    );

    -- 7-segment display component
    led1 : leddec16
    PORT MAP(
        dig => led_mpx, 
        data => hit_count, -- Display hit count on 7-segment display
        anode => SEG7_anode, 
        seg => SEG7_seg
    );
END Behavioral;