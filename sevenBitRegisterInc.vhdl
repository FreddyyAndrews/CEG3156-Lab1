------------------------------------------------------------
-- Next state logic

library ieee;
use ieee.std_logic_1164.all;

entity seven_bit_counter_logic is
    port(
        q : in std_logic_vector(6 downto 0);
        q_plus: out std_logic_vector(6 downto 0)
    );
end entity seven_bit_counter_logic;

architecture Structural of seven_bit_counter_logic is
begin
    q_plus(0) <= (not q(0));
    q_plus(1) <= q(0) xor q(1);
    q_plus(2) <= (q(0) and q(1)) xor q(2);
    q_plus(3) <= ((q(0) and q(1)) and q(2)) xor q(3);
    q_plus(4) <= ((q(0) and q(1)) and q(2) and q(3)) xor q(4);
    q_plus(5) <= ((q(0) and q(1)) and q(2) and q(3) and q(4)) xor q(5);
    q_plus(6) <= ((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) xor q(6);
end Structural;

------------------------------------------------------------
-- Register

library ieee;
use ieee.std_logic_1164.all;


ENTITY sevenBitRegisterInc IS
    PORT(
        i_Value      : IN  STD_LOGIC_VECTOR(6 downto 0);
        inc          : IN  STD_LOGIC;
        load         : IN  STD_LOGIC;
        clk          : IN  STD_LOGIC;
        reset_bar        : IN  STD_LOGIC;
        o_Value      : OUT STD_LOGIC_VECTOR(6 downto 0)
    );
END sevenBitRegisterInc;

ARCHITECTURE structural OF sevenBitRegisterInc IS

signal current_state: std_logic_vector(6 downto 0);
signal next_state: std_logic_vector(6 downto 0);
signal mux_to_dff: std_logic_vector(6 downto 0);
signal enabled: std_logic_vector(6 downto 0);

BEGIN
    GEN_BITS: FOR i IN 0 TO 6 GENERATE
        enabled(i) <= inc or load;
        LOAD_MUX: ENTITY work.mux2
            PORT MAP(
                sel  => load,
                in0 => next_state(i),        -- Normal shift/hold path
                in1 => i_Value(i),              -- Parallel load
                outy => mux_to_dff(i)
            );

        BIT_FF: ENTITY work.enardFF_2
            PORT MAP(
                i_resetBar => reset_bar,
                i_d        => mux_to_dff(i),
                i_enable   => enabled(i),
                i_clock    => clk,
                o_q        => current_state(i),
                o_qBar     => OPEN
            );
    END GENERATE;

    NEXT_STATE_LOGIC: ENTITY work.seven_bit_counter_logic
        PORT MAP(q => current_state,
        q_plus => next_state);

    o_Value <= current_state;

END structural;
