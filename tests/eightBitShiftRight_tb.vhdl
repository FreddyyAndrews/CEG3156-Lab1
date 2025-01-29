LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY tb_eightBitShiftRight IS
END tb_eightBitShiftRight;

ARCHITECTURE behavior OF tb_eightBitShiftRight IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT eightBitShiftRight
        PORT(
            i_Value      : IN  STD_LOGIC_VECTOR(7 downto 0);
            shift_value  : IN  STD_LOGIC;
            shift        : IN  STD_LOGIC;
            load         : IN  STD_LOGIC;
            clk          : IN  STD_LOGIC;
            reset_bar    : IN  STD_LOGIC;
            o_Value      : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    -- Signals
    SIGNAL i_Value     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    SIGNAL shift_value : STD_LOGIC := '0';
    SIGNAL shift       : STD_LOGIC := '0';
    SIGNAL load        : STD_LOGIC := '0';
    SIGNAL clk         : STD_LOGIC := '0';
    SIGNAL reset_bar   : STD_LOGIC := '0';
    SIGNAL o_Value     : STD_LOGIC_VECTOR(7 downto 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: eightBitShiftRight PORT MAP (
        i_Value     => i_Value,
        shift_value => shift_value,
        shift       => shift,
        load        => load,
        clk        => clk,
        reset_bar   => reset_bar,
        o_Value     => o_Value
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period/2;
            clk <= '1';
            WAIT FOR clk_period/2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stim_process : PROCESS
    BEGIN
        -- Reset the circuit
        reset_bar <= '0';
        WAIT FOR 20 ns;
        reset_bar <= '1';
        WAIT FOR 10 ns;

        -- Load a value into the shift register
        i_Value <= "11001100";
        load <= '1';
        shift <= '0';
        WAIT FOR clk_period;
        load <= '0';
        ASSERT o_Value = "11001100" REPORT "Error: Load failed" SEVERITY ERROR;

        -- Shift right with different shift values
        shift <= '1';
        shift_value <= '0'; -- Insert '0' into the leftmost bit
        WAIT FOR clk_period;
        ASSERT o_Value = "01100110" REPORT "Error: Shift right with '0' failed" SEVERITY ERROR;
        WAIT FOR clk_period;
        shift_value <= '1'; -- Insert '1' into the leftmost bit
        WAIT FOR clk_period;
        ASSERT o_Value = "10110011" REPORT "Error: Shift right with '1' failed" SEVERITY ERROR;
        WAIT FOR clk_period;

        -- Hold (no shift)
        shift <= '0';
        WAIT FOR clk_period;
        ASSERT o_Value = "10110011" REPORT "Error: Hold failed" SEVERITY ERROR;
        WAIT FOR clk_period;

        -- Load a new value
        i_Value <= "10101010";
        load <= '1';
        WAIT FOR clk_period;
        load <= '0';
        ASSERT o_Value = "10101010" REPORT "Error: Second load failed" SEVERITY ERROR;

        -- Shift right again
        shift <= '1';
        shift_value <= '0';
        WAIT FOR clk_period;
        ASSERT o_Value = "01010101" REPORT "Error: Shift right after second load failed" SEVERITY ERROR;
        shift_value <= '1';
        WAIT FOR clk_period;
        ASSERT o_Value = "10101010" REPORT "Error: Shift right with '1' after second load failed" SEVERITY ERROR;

        -- Stop simulation
        WAIT;
    END PROCESS;

END behavior;
