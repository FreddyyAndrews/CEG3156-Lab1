library IEEE;
use IEEE.std_logic_1164.all;

entity adder_subtractor_23_tb is
end entity adder_subtractor_23_tb;

architecture tb of adder_subtractor_23_tb is
  -- Constants
  constant CLK_PERIOD : time := 100 ns;

  -- Test signals
  signal A_tb    : std_logic_vector(22 downto 0) := (others => '0');
  signal B_tb    : std_logic_vector(22 downto 0) := (others => '0');
  signal SUB_tb  : std_logic := '0';  -- 0 => Add, 1 => Subtract
  signal SUM_tb  : std_logic_vector(22 downto 0);
  signal COUT_tb : std_logic;

  -- Expected signals for validation
  signal expected_SUM  : std_logic_vector(22 downto 0);
  signal expected_COUT : std_logic;

begin

  -------------------------------------------------------------------------------
  -- Unit Under Test (UUT)
  -------------------------------------------------------------------------------
  UUT: entity work.adder_subtractor_23
    port map(
      A    => A_tb,
      B    => B_tb,
      SUB  => SUB_tb,
      SUM  => SUM_tb,
      COUT => COUT_tb
    );

  -------------------------------------------------------------------------------
  -- Stimulus Process
  -------------------------------------------------------------------------------
  stim_proc: process
  begin
    -----------------------------------------------------------------------------
    -- Test Case 1: Simple add with both inputs zero
    -----------------------------------------------------------------------------
    A_tb <= (others => '0');
    B_tb <= (others => '0');
    SUB_tb <= '0';
    expected_SUM <= (others => '0');
    expected_COUT <= '0';
    wait for CLK_PERIOD;

    assert (SUM_tb = expected_SUM and COUT_tb = expected_COUT)
      report "Test Case 1 failed: Simple add with both inputs zero" severity error;

    -----------------------------------------------------------------------------
    -- Test Case 2: Add small values
    -----------------------------------------------------------------------------
    A_tb <= "00000000000000000000001"; -- 1
    B_tb <= "00000000000000000000101"; -- 5
    SUB_tb <= '0';
    expected_SUM <= "00000000000000000000110"; -- 6
    expected_COUT <= '0';
    wait for CLK_PERIOD;

    assert (SUM_tb = expected_SUM and COUT_tb = expected_COUT)
      report "Test Case 2 failed: Add small values" severity error;

    -----------------------------------------------------------------------------
    -- Test Case 3: Add larger binary patterns
    -----------------------------------------------------------------------------
    A_tb <= "10101010101010101010101";
    B_tb <= "01010101010101010101010";
    SUB_tb <= '0';
    expected_SUM <= "11111111111111111111111"; -- Expected result
    expected_COUT <= '0';
    wait for CLK_PERIOD;

    assert (SUM_tb = expected_SUM and COUT_tb = expected_COUT)
      report "Test Case 3 failed: Add larger binary patterns" severity error;

    -----------------------------------------------------------------------------
    -- Test Case 4: Subtract small values
    -----------------------------------------------------------------------------
    A_tb <= "00000000000000000000110"; -- 6
    B_tb <= "00000000000000000000010"; -- 2
    SUB_tb <= '1';
    expected_SUM <= "00000000000000000000100"; -- 4
    expected_COUT <= '1';
    wait for CLK_PERIOD;

    assert (SUM_tb = expected_SUM and COUT_tb = expected_COUT)
      report "Test Case 4 failed: Subtract small values" severity error;

    -----------------------------------------------------------------------------
    -- Test Case 5: Subtract with a larger range
    -----------------------------------------------------------------------------
    A_tb <= "11111111111111111111111"; -- Largest 23-bit value
    B_tb <= "00000000000000000000100"; -- 4
    SUB_tb <= '1';
    expected_SUM <= "11111111111111111111011"; -- Result after subtraction
    expected_COUT <= '1';
    wait for CLK_PERIOD;

    assert (SUM_tb = expected_SUM and COUT_tb = expected_COUT)
      report "Test Case 5 failed: Subtract with a larger range" severity error;

    -----------------------------------------------------------------------------
    -- End simulation
    -----------------------------------------------------------------------------
    report "Test cases pass." severity note;
    wait;
  end process;

end architecture tb;
