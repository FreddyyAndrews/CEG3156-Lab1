LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nine_bit_right_shift_register IS
    PORT (
        parralel_input   : IN  STD_LOGIC_VECTOR(8 DOWNTO 0); -- 9-bit Parallel Load Input
        load             : IN  STD_LOGIC;  -- Load Enable
        serial_input     : IN  STD_LOGIC;  -- Serial Shift Input
        shift_right      : IN  STD_LOGIC;  -- Shift Enable
        clk              : IN  STD_LOGIC;  -- Clock
        right_output     : OUT STD_LOGIC;  -- LSB Output
        parrallel_output : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) -- 9-bit Parallel Output
    );
END nine_bit_right_shift_register;

ARCHITECTURE Structural OF nine_bit_right_shift_register IS
    SIGNAL temp_q, temp_mux : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL enable_signal : STD_LOGIC;

    -- Flip-Flop Component
    COMPONENT enardFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    -- 2-to-1 Multiplexer Component
    COMPONENT two_to_one_mux
        PORT(
            a, b, sel : IN  STD_LOGIC;
            y         : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- Enable signal is active when either Load or Shift is enabled
    enable_signal <= load OR shift_right;

    -- Multiplexer Logic for 9-bit shift register
    GEN_MUX: FOR i IN 0 TO 7 GENERATE
        mux_inst: two_to_one_mux PORT MAP(
            a   => parralel_input(i),
            b   => temp_q(i+1),
            sel => shift_right,
            y   => temp_mux(i)
        );
    END GENERATE;

    -- Last MUX handling the serial input
    mux8: two_to_one_mux PORT MAP(
        a   => parralel_input(8),
        b   => serial_input,
        sel => shift_right,
        y   => temp_mux(8)
    );

    -- Flip-Flop Logic for 9-bit shift register
    GEN_DFF: FOR i IN 0 TO 8 GENERATE
        dff_inst: enardFF_2 PORT MAP(
            i_d        => temp_mux(i),
            i_clock    => clk,
            o_q        => temp_q(i),
            i_enable   => enable_signal,
            i_resetBar => '1'
        );
    END GENERATE;

    -- Output the least significant bit (LSB)
    right_output <= temp_q(0);

    -- Assign parallel output
    parrallel_output <= temp_q;

END Structural;
