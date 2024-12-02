LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY counter IS
    PORT (
        clk : IN STD_LOGIC;
        count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
        mpx : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    ); 
END counter;

ARCHITECTURE Behavioral OF counter IS
    TYPE state_type IS (A, B, C, D, E, F);
    
    SIGNAL PS, NS : state_type;     
    SIGNAL Z      : STD_LOGIC;     
    SIGNAL X      : STD_LOGIC;     
    
    SIGNAL cnt    : STD_LOGIC_VECTOR (38 DOWNTO 0); 
    SIGNAL dir_reg: STD_LOGIC := '1';              
BEGIN
    X <= cnt(26); 

    clock_and_update: PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            PS <= NS;

            IF Z = '1' THEN
                dir_reg <= NOT dir_reg; 
            END IF;

            IF dir_reg = '1' THEN
                cnt <= cnt + 1; 
            ELSE
                cnt <= cnt - 1; 
            END IF;
        END IF;
    END PROCESS;

    fsm_logic: PROCESS(PS, X)
    BEGIN
        CASE PS IS
            WHEN A =>
                IF X = '1' THEN 
                    NS <= B;  
                    Z <= '0';  
                ELSE 
                    NS <= A;   
                    Z <= '0';  
                END IF;

            WHEN B =>
                IF X = '1' THEN 
                    NS <= C; 
                    Z <= '0';  
                ELSE 
                    NS <= A;   
                    Z <= '0';  
                END IF;

            WHEN C =>
                IF X = '1' THEN 
                    NS <= D;  
                    Z <= '0';  
                ELSE 
                    NS <= A;
                    Z <= '0';  
                END IF;

            WHEN D =>
                IF X = '1' THEN 
                    NS <= E;  
                    Z <= '0';  
                ELSE 
                    NS <= A;
                    Z <= '0';  
                END IF;

            WHEN E =>
                IF X = '0' THEN 
                    NS <= F;  
                    Z <= '1'; 
                ELSE 
                    NS <= E;  
                    Z <= '0';  
                END IF;

            WHEN F =>
                IF X = '1' THEN
                    NS <= B;  
                    Z <= '0';  
                ELSE
                    NS <= A;
                    Z <= '0';  
                END IF;

            WHEN OTHERS =>
                NS <= A;  
                Z <= '0';  
        END CASE;
    END PROCESS;
    
    count <= cnt (38 DOWNTO 23);
    mpx <= cnt (19 DOWNTO 17);   
END Behavioral;
