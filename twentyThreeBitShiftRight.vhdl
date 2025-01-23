LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

---------------------------------------------------------------------
-- Top-level: 23-bit shift-right register with:
--   - Parallel Load (load)
--   - Shift Enable (shift_enable)
--   - Shift-In Bit (shift_value) into the leftmost position
---------------------------------------------------------------------
ENTITY twentyThreeBitShiftRight IS
    PORT(
        i_Value      : IN  STD_LOGIC_VECTOR(22 downto 0);
        shift_value  : IN  STD_LOGIC;           -- Bit shifted into the leftmost position (bit 22)
        shift : IN  STD_LOGIC;           -- Enables right shift
        load         : IN  STD_LOGIC;           -- Loads i_Value in parallel
        clk          : IN  STD_LOGIC;
        reset        : IN  STD_LOGIC;           -- Active-high reset
        o_Value      : OUT STD_LOGIC_VECTOR(22 downto 0)
    );
END twentyThreeBitShiftRight;

ARCHITECTURE structural OF twentyThreeBitShiftRight IS
    -----------------------------------------------------------------
    -- Internal signals:
    --   shift_mux_out(i) = output of the shift/hold mux for bit i
    --   next_val(i)      = output of the load vs. shift_mux_out mux for bit i
    -----------------------------------------------------------------
    SIGNAL next_val      : STD_LOGIC_VECTOR(22 downto 0);

    -----------------------------------------------------------------
    -- Declare two instances of mux2 for each bit:
    --   1) SHIFT_MUX: chooses between hold (o_Value(i)) vs. shifted input
    --   2) LOAD_MUX : chooses between shift_mux_out(i) vs. parallel input i_Value(i)
    -----------------------------------------------------------------

BEGIN
    -----------------------------------------------------------------
    -- Generate logic for bits 22 down to 0
    -----------------------------------------------------------------
    GEN_BITS: FOR i IN 0 TO 22 GENERATE
        LOAD_MUX: ENTITY work.mux2
            PORT MAP(
                sel  => load,
                in0 => (shift_value) WHEN (i=22) ELSE o_Value(i+1),        -- Normal shift/hold path
                in1 => i_Value(i),              -- Parallel load
                outy => next_val(i)
            );

        BIT_FF: ENTITY work.enardFF_2
            PORT MAP(
                i_resetBar => NOT reset,  -- convert active-high reset to active-low
                i_d        => next_val(i),
                i_enable   => shift or load,
                i_clock    => clk,
                o_q        => o_Value(i),
                o_qBar     => OPEN
            );

    END GENERATE;

END structural;
