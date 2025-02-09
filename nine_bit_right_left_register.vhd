LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nine_bit_dual_direction_shift_register IS
    PORT (
        parallel_input   : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);  -- 9-bit Parallel Load Input
        load             : IN  STD_LOGIC;                     -- Load Enable
        serial_input     : IN  STD_LOGIC;                     -- Serial Input (used for either left or right shift)
        shift_enable     : IN  STD_LOGIC;                     -- Overall Shift Enable
        shift_dir        : IN  STD_LOGIC;                     -- '0' => Shift Left, '1' => Shift Right
        clk              : IN  STD_LOGIC;                     -- Clock
        left_output      : OUT STD_LOGIC;                     -- MSB (bit 8)
        right_output     : OUT STD_LOGIC;                     -- LSB (bit 0)
        parallel_output  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)   -- 9-bit Parallel Output
    );
END nine_bit_dual_direction_shift_register;

ARCHITECTURE Structural OF nine_bit_dual_direction_shift_register IS

    -- Existing Flip-Flop Component
    COMPONENT enardFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Existing 2-to-1 Multiplexer Component
    COMPONENT two_to_one_mux
        PORT(
            a, b, sel : IN  STD_LOGIC;
            y         : OUT STD_LOGIC
        );
    END COMPONENT;

    -------------------------------------------------------------------------
    -- SIGNALS
    -------------------------------------------------------------------------
    SIGNAL temp_q          : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Registered outputs
    SIGNAL shift_left_data : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Data if shifting left
    SIGNAL shift_right_data: STD_LOGIC_VECTOR(8 DOWNTO 0); -- Data if shifting right
    SIGNAL mux_shift_sel   : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Mux output for shift direction
    SIGNAL mux_load_sel    : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Final Mux output before FFs
    SIGNAL enable_signal   : STD_LOGIC;                    -- Enable for FFs

BEGIN
    -------------------------------------------------------------------------
    -- Enable is active if load or shift is enabled
    -------------------------------------------------------------------------
    enable_signal <= load OR shift_enable;

    -------------------------------------------------------------------------
    -- Generate data as if shifting left:
    --   - The MSB (index 8) is fed by temp_q(7)
    --   - The LSB (index 0) is fed by 'serial_input'
    --   - For bits [1..8], shift_left_data(i) <= temp_q(i-1)
    -------------------------------------------------------------------------
    shift_left_data(0) <= serial_input;
    GEN_SHIFT_LEFT: FOR i IN 1 TO 8 GENERATE
        shift_left_data(i) <= temp_q(i-1);
    END GENERATE;

    -------------------------------------------------------------------------
    -- Generate data as if shifting right:
    --   - The LSB (index 0) is fed by temp_q(1)
    --   - The MSB (index 8) is fed by 'serial_input'
    --   - For bits [0..7], shift_right_data(i) <= temp_q(i+1)
    -------------------------------------------------------------------------
    shift_right_data(8) <= serial_input;
    GEN_SHIFT_RIGHT: FOR i IN 0 TO 7 GENERATE
        shift_right_data(i) <= temp_q(i+1);
    END GENERATE;

    -------------------------------------------------------------------------
    -- For each bit, first choose between shift_left_data(i) or shift_right_data(i)
    -- based on shift_dir ('0' => left, '1' => right). This gives mux_shift_sel(i).
    -------------------------------------------------------------------------
    GEN_SHIFT_SELECT: FOR i IN 0 TO 8 GENERATE
        sel_shift_dir: two_to_one_mux
            PORT MAP(
                a   => shift_left_data(i),
                b   => shift_right_data(i),
                sel => shift_dir,
                y   => mux_shift_sel(i)
            );
    END GENERATE;

    -------------------------------------------------------------------------
    -- Next, choose between loading parallel_input(i) or the shift path
    -- based on load. This yields mux_load_sel(i).
    -------------------------------------------------------------------------
    GEN_LOAD_SELECT: FOR i IN 0 TO 8 GENERATE
        sel_load: two_to_one_mux
            PORT MAP(
                a   => parallel_input(i),
                b   => mux_shift_sel(i),
                sel => load,
                y   => mux_load_sel(i)
            );
    END GENERATE;

    -------------------------------------------------------------------------
    -- Now store the selected data into the Flip-Flops with enable_signal
    -------------------------------------------------------------------------
    GEN_DFF: FOR i IN 0 TO 8 GENERATE
        dff_inst: enardFF_2
            PORT MAP(
                i_d        => mux_load_sel(i),
                i_clock    => clk,
                i_enable   => enable_signal,
                i_resetBar => '1',
                o_q        => temp_q(i),
                o_qBar     => OPEN
            );
    END GENERATE;

    -------------------------------------------------------------------------
    -- Outputs
    -------------------------------------------------------------------------
    right_output <= temp_q(0);
    left_output  <= temp_q(8);
    parallel_output <= temp_q;

END Structural;