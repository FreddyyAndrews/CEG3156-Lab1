LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sevenBitRegisterIncDec IS
    PORT(
        i_Value      : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
        inc          : IN  STD_LOGIC;
        dec          : IN  STD_LOGIC;
        load         : IN  STD_LOGIC;
        clk          : IN  STD_LOGIC;
        reset_bar    : IN  STD_LOGIC;
        o_Value      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END sevenBitRegisterIncDec;

ARCHITECTURE structural OF sevenBitRegisterIncDec IS

SIGNAL current_state : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL next_state    : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL mux_to_dff    : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL enabled       : STD_LOGIC;

BEGIN
    enabled <= inc OR dec OR load;
    
    PROCESS (current_state, inc, dec, load, i_Value)
    BEGIN
        IF load = '1' THEN
            next_state <= i_Value;  -- Load new value
        ELSIF inc = '1' THEN
            next_state <= STD_LOGIC_VECTOR(unsigned(current_state) + 1);  -- Increment
        ELSIF dec = '1' THEN
            next_state <= STD_LOGIC_VECTOR(unsigned(current_state) - 1);  -- Decrement
        ELSE
            next_state <= current_state;  -- Hold
        END IF;
    END PROCESS;
    
    PROCESS (clk, reset_bar)
    BEGIN
        IF reset_bar = '0' THEN
            current_state <= (OTHERS => '0');  -- Reset to 0
        ELSIF rising_edge(clk) THEN
            IF enabled = '1' THEN
                current_state <= next_state;
            END IF;
        END IF;
    END PROCESS;

    o_Value <= current_state;

END structural;