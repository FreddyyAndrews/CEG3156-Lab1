library ieee;
use ieee.std_logic_1164.all;

entity eightBitComparator_tb is
end eightBitComparator_tb;

architecture Behavioral of eightBitComparator_tb is
    -- Component declaration for the DUT (Design Under Test)
    component eightBitComparator
        port(
            A       : in std_logic_vector(6 downto 0);
            B       : in std_logic_vector(6 downto 0);
            A_gt_B  : out std_logic;
            A_eq_B  : out std_logic
        );
    end component;

    -- Signals for connecting to the DUT
    signal A       : std_logic_vector(6 downto 0);
    signal B       : std_logic_vector(6 downto 0);
    signal A_gt_B  : std_logic;
    signal A_eq_B  : std_logic;

begin
    -- Instantiate the DUT
    uut: eightBitComparator
        port map (
            A       => A,
            B       => B,
            A_gt_B  => A_gt_B,
            A_eq_B  => A_eq_B
        );

    -- Test process
    stim_proc: process
    begin
        -- Test case 1: A = B
        A <= "0000000"; B <= "0000000";
        wait for 10 ns;
        assert (A_gt_B = '0' and A_eq_B = '1')
        report "Test case 1 failed: A = B";

        -- Test case 2: A > B
        A <= "0000001"; B <= "0000000";
        wait for 10 ns;
        assert (A_gt_B = '1' and A_eq_B = '0')
        report "Test case 2 failed: A > B";

        -- Test case 3: A < B
        A <= "0000000"; B <= "0000001";
        wait for 10 ns;
        assert (A_gt_B = '0' and A_eq_B = '0')
        report "Test case 3 failed: A < B";

        -- Test case 4: A = B (non-zero)
        A <= "1111111"; B <= "1111111";
        wait for 10 ns;
        assert (A_gt_B = '0' and A_eq_B = '1')
        report "Test case 4 failed: A = B";

        -- Test case 5: A > B with MSB set
        A <= "1000000"; B <= "0111111";
        wait for 10 ns;
        assert (A_gt_B = '1' and A_eq_B = '0')
        report "Test case 5 failed: A > B with MSB set";

        -- Test case 6: A < B with MSB set
        A <= "0111111"; B <= "1000000";
        wait for 10 ns;
        assert (A_gt_B = '0' and A_eq_B = '0')
        report "Test case 6 failed: A < B with MSB set";

        -- Finish simulation
        wait;
    end process;
end Behavioral;
