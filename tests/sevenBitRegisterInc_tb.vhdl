library ieee;
use ieee.std_logic_1164.all;

entity sevenBitRegisterInc_tb is
end entity sevenBitRegisterInc_tb;

architecture Behavioral of sevenBitRegisterInc_tb is
    -- Component declaration for DUT (Design Under Test)
    component sevenBitRegisterInc
        port (
            i_Value      : in  std_logic_vector(6 downto 0);
            inc          : in  std_logic;
            load         : in  std_logic;
            clk          : in  std_logic;
            reset_bar    : in  std_logic;
            o_Value      : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Signals to connect to DUT
    signal i_Value      : std_logic_vector(6 downto 0);
    signal inc          : std_logic;
    signal load         : std_logic;
    signal clk          : std_logic := '0';
    signal reset_bar    : std_logic;
    signal o_Value      : std_logic_vector(6 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the DUT
    uut: sevenBitRegisterInc
        port map (
            i_Value   => i_Value,
            inc       => inc,
            load      => load,
            clk       => clk,
            reset_bar => reset_bar,
            o_Value   => o_Value
        );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the register
        reset_bar <= '0';
        wait for clk_period;
        reset_bar <= '1';
        wait for clk_period;

        -- Test 1: Load a value into the register and assert
        i_Value <= "0001010"; -- Load value 10
        load <= '1';
        inc <= '0';
        wait for clk_period;
        load <= '0';
        wait for clk_period;

        assert o_Value = "0001010"
        report "Test 1 failed: Load value 10 into register" severity error;

        -- Test 2: Increment the register and assert
        inc <= '1';
        wait for clk_period;
        assert o_Value = "0001011"
        report "Test 2 failed: Increment once" severity error;

        wait for clk_period;
        assert o_Value = "0001100"
        report "Test 2 failed: Increment twice" severity error;

        inc <= '0';
        wait for clk_period;

        -- Test 3: Load a new value and assert
        i_Value <= "1111111"; -- Load value 127
        load <= '1';
        wait for clk_period;
        load <= '0';
        wait for clk_period;

        assert o_Value = "1111111"
        report "Test 3 failed: Load value 127 into register" severity error;

        assert false
        report "End of Testbench - Forcing simulation stop" severity failure;
    end process;
end Behavioral;
