LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pong IS
    PORT (
        clk_in : IN STD_LOGIC; 
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC;
        btnu : IN STD_LOGIC;   
        btnd : IN STD_LOGIC;   
        btn0 : IN STD_LOGIC;
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
        SW : IN STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
END pong;

ARCHITECTURE Behavioral OF pong IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; 
    SIGNAL S_red, S_green, S_blue : STD_LOGIC;
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL player_x : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(75, 11);
    SIGNAL player_y : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    SIGNAL hit_count : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL old_hit_count : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Blocked areas
    CONSTANT blocked_left   : INTEGER := 0;
    CONSTANT blocked_right  : INTEGER := 100;
    CONSTANT blocked_top    : INTEGER := 380;
    CONSTANT blocked_bottom : INTEGER := 600;

    CONSTANT blocked_left1   : INTEGER := 0;
    CONSTANT blocked_right1  : INTEGER := 100;
    CONSTANT blocked_top1    : INTEGER := 0;
    CONSTANT blocked_bottom1 : INTEGER := 220;

    CONSTANT blocked_left2   : INTEGER := 700;
    CONSTANT blocked_right2  : INTEGER := 800;
    CONSTANT blocked_top2    : INTEGER := 380;
    CONSTANT blocked_bottom2 : INTEGER := 600;

    CONSTANT blocked_left3   : INTEGER := 700;
    CONSTANT blocked_right3  : INTEGER := 800;
    CONSTANT blocked_top3    : INTEGER := 0;
    CONSTANT blocked_bottom3 : INTEGER := 220;

    CONSTANT player_w : INTEGER := 16;
    CONSTANT player_h : INTEGER := 16;

    -- Home base dimensions and position
    CONSTANT home_base_width : INTEGER := 100;  
    CONSTANT home_base_height : INTEGER := 160;
    CONSTANT left_home_x : INTEGER := home_base_width / 2;
    CONSTANT right_home_x : INTEGER := 800 - (home_base_width / 2);
    CONSTANT home_base_y : INTEGER := 300;

    -- One-second enable signals
    SIGNAL one_sec_en : STD_LOGIC := '0';
    SIGNAL second_counter : INTEGER := 0;

    CONSTANT CLK_FREQ : INTEGER := 100000000; -- 100 MHz taken from constraints
    CONSTANT ONE_SEC_COUNT : INTEGER := CLK_FREQ - 1;  

    -- Stopwatch display output (16 bits)
    SIGNAL stopwatch_display : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Combined display for hit_count and stopwatch
    SIGNAL combined_display : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL combined_lower   : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL player_in_right_home : STD_LOGIC := '0';

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
            hit_count : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
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
            dig   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            seg   : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT stopwatch IS
        PORT (
            clk         : IN STD_LOGIC;
            reset       : IN STD_LOGIC;
            one_sec_en  : IN STD_LOGIC;
            pause       : IN STD_LOGIC; -- Added pause for when player reaches end zone
            display_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN
    one_sec_gen : PROCESS(clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF second_counter = ONE_SEC_COUNT THEN
                second_counter <= 0;
                one_sec_en <= '1';
            ELSE
                second_counter <= second_counter + 1;
                one_sec_en <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- stopwatch with pause signal
    my_stopwatch : stopwatch
    PORT MAP(
        clk => clk_in,
        reset => btnd,
        one_sec_en => one_sec_en,
        pause => player_in_right_home, 
        display_out => stopwatch_display
    );

    combined_display(15 DOWNTO 0)   <= hit_count;         
    combined_display(31 DOWNTO 16) <= stopwatch_display;  

    pos : PROCESS (clk_in)
        VARIABLE new_x, new_y : INTEGER;
        VARIABLE no_overlap, no_overlap1, no_overlap2, no_overlap3 : BOOLEAN;
    BEGIN
        IF rising_edge(clk_in) THEN
            count <= count + 1;

            -- Check reset and hit count reset condition
            IF (hit_count > old_hit_count) OR (btnd = '1') THEN
                player_x <= CONV_STD_LOGIC_VECTOR(75, 11);
                player_y <= CONV_STD_LOGIC_VECTOR(300, 11);
                old_hit_count <= hit_count;
            ELSE
                old_hit_count <= hit_count;

                -- Movement logic
                new_x := CONV_INTEGER(player_x);
                new_y := CONV_INTEGER(player_y);

                IF btnl = '1' AND count = 0 THEN
                    new_x := new_x - 5;
                ELSIF btnr = '1' AND count = 0 THEN
                    new_x := new_x + 5;
                END IF;

                IF new_x < 20 THEN
                    new_x := 20;
                ELSIF new_x > 780 THEN
                    new_x := 780;
                END IF;

                IF btnu = '1' AND count = 0 THEN
                    new_y := new_y - 5;
                ELSIF btn0 = '1' AND count = 0 THEN
                    new_y := new_y + 5;
                END IF;

                IF new_y < 20 THEN
                    new_y := 20;
                ELSIF new_y > 580 THEN
                    new_y := 580;
                END IF;

                -- used to make sure player can't enter the corner spaces
                no_overlap := (new_x + player_w < blocked_left) OR
                              (new_x - player_w > blocked_right) OR
                              (new_y + player_h < blocked_top) OR
                              (new_y - player_h > blocked_bottom);

                no_overlap1 := (new_x + player_w < blocked_left1) OR
                               (new_x - player_w > blocked_right1) OR
                               (new_y + player_h < blocked_top1) OR
                               (new_y - player_h > blocked_bottom1);

                no_overlap2 := (new_x + player_w < blocked_left2) OR
                               (new_x - player_w > blocked_right2) OR
                               (new_y + player_h < blocked_top2) OR
                               (new_y - player_h > blocked_bottom2);

                no_overlap3 := (new_x + player_w < blocked_left3) OR
                               (new_x - player_w > blocked_right3) OR
                               (new_y + player_h < blocked_top3) OR
                               (new_y - player_h > blocked_bottom3);
                
                
                IF no_overlap AND no_overlap1 AND no_overlap2 AND no_overlap3 THEN
                    player_x <= CONV_STD_LOGIC_VECTOR(new_x, 11);
                    player_y <= CONV_STD_LOGIC_VECTOR(new_y, 11);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- Check if player in right safe area
    player_area_check: PROCESS(player_x, player_y)
    BEGIN
        IF (CONV_INTEGER(player_x) >= (right_home_x - home_base_width/2)) AND
           (CONV_INTEGER(player_x) <= (right_home_x + home_base_width/2)) AND
           (CONV_INTEGER(player_y) >= (home_base_y - home_base_height/2)) AND
           (CONV_INTEGER(player_y) <= (home_base_y + home_base_height/2))
        THEN
            player_in_right_home <= '1';
        ELSE
            player_in_right_home <= '0';
        END IF;
    END PROCESS;

    -- 7-segment multiplexing clock
    led_mpx <= count(19 DOWNTO 17);

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
        hit_count => hit_count,
        SW => SW
    );

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

    VGA_vsync <= S_vsync;

    clk_wiz_0_inst : clk_wiz_0
    PORT MAP(
        clk_in1 => clk_in,
        clk_out1 => pxl_clk
    );

    led1 : leddec16
    PORT MAP(
        dig => led_mpx,
        data => combined_display,
        anode => SEG7_anode,
        seg => SEG7_seg
    );

END Behavioral;
