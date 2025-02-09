LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nine_bit_dual_direction_shift_register IS
    PORT (
        parallel_input   : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);  -- 9-bit Parallel Load Input
        load             : IN  STD_LOGIC;                     -- Load Enable
        shift_left       : IN  STD_LOGIC;                     -- Shift Left Control
        shift_right      : IN  STD_LOGIC;                     -- Shift Right Control
        serial_input     : IN  STD_LOGIC;                     -- Serial Input for shifting
        inc              : IN  STD_LOGIC;                     -- Increment Counter
        clk              : IN  STD_LOGIC;                     -- Clock
        left_output      : OUT STD_LOGIC;                     -- MSB (bit 8)
        right_output     : OUT STD_LOGIC;                     -- LSB (bit 0)
        parallel_output  : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);   -- 9-bit Parallel Output
		  zero				 : OUT STD_LOGIC
    );
END nine_bit_dual_direction_shift_register;

ARCHITECTURE Structural OF nine_bit_dual_direction_shift_register IS

    ----------------------------------------------------------------------------
    -- Flip-Flop Component
    ----------------------------------------------------------------------------
    COMPONENT enardFF_2
        PORT (
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    ----------------------------------------------------------------------------
    -- 2-to-1 Multiplexer Component
    ----------------------------------------------------------------------------
    COMPONENT mux2
        PORT (
            a, b, sel : IN  STD_LOGIC;
            y         : OUT STD_LOGIC
        );
    END COMPONENT;

    ----------------------------------------------------------------------------
    -- Next state logic
    ----------------------------------------------------------------------------
    COMPONENT nine_bit_counter_logic
    PORT(
        q : in std_logic_vector(8 downto 0);
        q_plus: out std_logic_vector(8 downto 0)
    );
    end COMPONENT;

    ----------------------------------------------------------------------------
    -- SIGNALS
    ----------------------------------------------------------------------------
    SIGNAL temp_q            : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Registered outputs
    SIGNAL shift_left_data   : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Data if shifting left
    SIGNAL shift_right_data  : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Data if shifting right
    SIGNAL mux_shift_sel     : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Selects which shift direction
    SIGNAL mux_load_sel      : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Final MUX output (shift vs. parallel)
    SIGNAL next_state        : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Next state for counter
    SIGNAL final_mux         : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Final MUX output (shift vs. next state)
    SIGNAL enable_ff         : STD_LOGIC;                     -- FF enable
    signal shift: std_logic;

    ----------------------------------------------------------------------------
    -- Decide when to enable the flip-flops: whenever load, shift_left, or shift_right are active
    ----------------------------------------------------------------------------
BEGIN
    enable_ff <= load OR shift_left OR shift_right;
    shift <= shift_left or shift_right;

    ----------------------------------------------------------------------------
    -- Generate data as if shifting left:
    --   shift_left_data(0)   <= serial_input;
    --   shift_left_data(i)   <= temp_q(i - 1) for i = 1..8
    ----------------------------------------------------------------------------
    shift_left_data(0) <= serial_input;
    GEN_SHIFT_LEFT: FOR i IN 1 TO 8 GENERATE
        shift_left_data(i) <= temp_q(i-1);
    END GENERATE;

    ----------------------------------------------------------------------------
    -- Generate data as if shifting right:
    --   shift_right_data(8) <= serial_input;
    --   shift_right_data(i) <= temp_q(i+1) for i = 0..7
    ----------------------------------------------------------------------------
    shift_right_data(8) <= serial_input;
    GEN_SHIFT_RIGHT: FOR i IN 0 TO 7 GENERATE
        shift_right_data(i) <= temp_q(i+1);
    END GENERATE;

    ----------------------------------------------------------------------------
    -- First MUX set picks which direction to shift:
    --   Use shift_right as select; if '0' => left data, if '1' => right data
    --   (Assumes shift_left and shift_right won't both be high at the same time)
    ----------------------------------------------------------------------------
    GEN_SHIFT_SELECT: FOR i IN 0 TO 8 GENERATE
        sel_shift_dir: mux2
            PORT MAP(
                a   => shift_left_data(i),
                b   => shift_right_data(i),
                sel => shift_right,  -- if '1': pick right shift path; if '0': pick left
                y   => mux_shift_sel(i)
            );
    END GENERATE;

    ----------------------------------------------------------------------------
    -- Second MUX set decides between SHIFT vs. PARALLEL load:
    --   If (shift_left OR shift_right) = '1' => shift, else => parallel
    ----------------------------------------------------------------------------
    GEN_LOAD_SELECT: FOR i IN 0 TO 8 GENERATE
        sel_load: mux2
            PORT MAP(
                a   => parallel_input(i),
                b   => mux_shift_sel(i),
                sel => shift,  -- if '1': pick shift path; if '0': pick parallel
                y   => mux_load_sel(i)
            );
    END GENERATE;

    NextState: nine_bit_counter_logic
        PORT MAP(
            q      => temp_q,
            q_plus => next_state
        );

    ----------------------------------------------------------------------------
    -- Third mux for choosing between shift or load, vs next state
    --   If inc = '1' => next state, else => output of mux_load_sel
    ----------------------------------------------------------------------------
    GEN_NEXT_SELECT: FOR i IN 0 TO 8 GENERATE
        sel_next: mux2
            PORT MAP(
                a   => mux_load_sel(i),
                b   => next_state(i),
                sel => inc,  -- if '1': pick shift path; if '0': pick parallel
                y   => final_mux(i)
            );
    END GENERATE;


    ----------------------------------------------------------------------------
    -- Flip-Flops
    ----------------------------------------------------------------------------
    GEN_DFF: FOR i IN 0 TO 8 GENERATE
        dff_inst: enardFF_2
            PORT MAP(
                i_d        => final_mux(i),
                i_clock    => clk,
                i_enable   => enable_ff,
                i_resetBar => '1',
                o_q        => temp_q(i),
                o_qBar     => OPEN
            );
    END GENERATE;

    ----------------------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------------------
    left_output      <= temp_q(8);
    right_output     <= temp_q(0);
    parallel_output  <= temp_q;
	 zero <= not (temp_q(0) or temp_q(1) or temp_q(2) or temp_q(3) or temp_q(4) or temp_q(5) or temp_q(6) or temp_q(7) or temp_q(8));

END Structural;