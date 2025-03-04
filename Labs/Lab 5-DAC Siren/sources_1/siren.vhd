LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity siren is
        PORT ( 
                clk_50MHz : in  STD_LOGIC;   -- system clock (50 MHz)
                BTN0 : in STD_LOGIC;
                SW0 : IN STD_LOGIC;
                SW1 : IN STD_LOGIC;
                SW2 : IN STD_LOGIC;
                SW3 : IN STD_LOGIC;
                SW4 : IN STD_LOGIC;
                SW5 : IN STD_LOGIC;
                SW6 : IN STD_LOGIC;
                SW7 : IN STD_LOGIC;
                dac_MCLK : out  STD_LOGIC;  -- outputs to PMODI2L DAC
                dac_LRCK : out  STD_LOGIC;
                dac_SCLK : out  STD_LOGIC;
                dac_SDIN : out  STD_LOGIC);
END siren;

ARCHITECTURE Behavioral of siren is
        CONSTANT lo_tone: UNSIGNED (13 downto 0) := to_unsigned (25, 14); -- lower limit of siren = 256 Hz
        CONSTANT hi_tone: UNSIGNED (13 downto 0) := to_unsigned (2000, 14); -- upper limit of siren = 512 Hz
        SIGNAL wail_speed: UNSIGNED (7 downto 0) := to_unsigned (8, 8); -- sets wailing speed
        COMPONENT dac_if is
                PORT ( 
                        SCLK : in  STD_LOGIC;
                        L_start: in STD_LOGIC;
                        R_start: in STD_LOGIC;
                        L_data : in signed (15 downto 0);
                        R_data : in signed (15 downto 0);
                        SDATA : out  STD_LOGIC
                 );
        END COMPONENT;
        COMPONENT wail is
                PORT (   
                        lo_pitch : in  UNSIGNED (13 downto 0);
                        hi_pitch : in  UNSIGNED (13 downto 0);
                        wspeed : in UNSIGNED (7 downto 0);
                        wclk : in  STD_LOGIC;
                        audio_clk : in STD_LOGIC;
                        button_press : in STD_LOGIC;
                        audio_data : out  SIGNED (15 downto 0));
        END COMPONENT;
        SIGNAL tcount: unsigned (19 downto 0) := (others=>'0');  -- timing counter
        SIGNAL data_L, data_R: SIGNED (15 downto 0);  -- 16-bit signed audio data
        SIGNAL dac_load_L, dac_load_R: STD_LOGIC;  -- timing pulses to load DAC shift reg.
        SIGNAL slo_clk, sclk, audio_CLK: STD_LOGIC;  

BEGIN

        -- this process sets up a 20 bit binary counter clocked at 50MHz. This is used
        -- to generate all necessary timing signals. dac_load_L and dac_load_R are pulses
        -- sent to dac_if to load parallel data into shift register for serial clocking
        -- out to DAC
        tim_pr: PROCESS
        BEGIN
                WAIT UNTIL rising_edge(clk_50MHz);
                IF (tcount(9 DOWNTO 0) >= X"00F") AND (tcount(9 DOWNTO 0) < X"02E") THEN
                    dac_load_L <= '1'; 
                ELSE 
                    dac_load_L <= '0';
                END IF;
                IF (tcount(9 DOWNTO 0) >= X"20F") AND (tcount(9 DOWNTO 0) < X"22E") THEN
                    dac_load_R <= '1'; 
                ELSE 
                    dac_load_R <= '0';
                END IF;
                tcount <= tcount+1;
        END PROCESS;
        dac_MCLK <= not tcount(1);  -- DAC master clock (12.5 MHz)
        audio_CLK <= tcount(9);  -- audio sampling rate (48.8 kHz)
        dac_LRCK <= audio_CLK;  -- also sent to DAC as left/right clock
        sclk <= tcount(4);   -- serial data clock (1.56 MHz)
        dac_SCLK <= sclk;   -- also sent to DAC as SCLK
        slo_clk <= tcount(19);   -- clock to control wailing of tone (47.6 Hz)
        wail_speed(0) <= SW0;
        wail_speed(1) <= SW1;
        wail_speed(2) <= SW2;
        wail_speed(3) <= SW3;
        wail_speed(4) <= SW4;
        wail_speed(5) <= SW5;
        wail_speed(6) <= SW6;
        wail_speed(7) <= SW7;
        dac: dac_if 
        PORT MAP( 
                SCLK => sclk,   -- instantiate parallel to serial DAC interface
                L_start => dac_load_L,
                R_start => dac_load_R,
                L_data => data_L,
                R_data => data_R,
                SDATA => dac_SDIN 
         );
        
w1: wail port map( lo_pitch => lo_tone,  -- instantiate wailing siren
   hi_pitch => hi_tone,
   wspeed => wail_speed,
   wclk => slo_clk,
   button_press => BTN0,
   audio_clk => audio_clk,
   audio_data => data_L);   
w2: wail port map( lo_pitch => hi_tone,  -- instantiate wailing siren
   hi_pitch => lo_tone,
   wspeed => wail_speed,
   wclk => slo_clk,
   button_press => BTN0,
   audio_clk => audio_clk,
   audio_data => data_R);        
 
END Behavioral;