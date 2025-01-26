library ieee;
use ieee.std_logic_1164.all;

entity eightBitComparator_tb is
end eightBitComparator_tb;

architecture Behavioral of eightBitComparator_tb is
    -- Component declaration for the DUT (Design Under Test)
    component eightBitCLA
        PORT(
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        sub: in std_logic;
        sum: out std_logic_vector(7 downto 0);
        cout: out std_logic);
    end component;

    -- Signals for connecting to the DUT
    signal A       : std_logic_vector(7 downto 0);
    signal B       : std_logic_vector(7 downto 0);
    signal sub     : std_logic;
    signal sum     : std_logic_vector(7 downto 0);
    signal cout    : std_logic;

begin
    -- Instantiate the DUT
    uut: eightBitCLA
        port map (
            A       => A,
            B       => B,
            sub     => sub,
            sum     => sum,
            cout    => cout
        );

    -- Test process
    stim_proc: process
    begin

        A <= "00001001"; B <= "00001101";
        wait for 10 ns;
        assert (sum = "00010110" and cout = '0')
        report "Test case 1 failed";

        A <= "11111111"; B <= "11111111";
        wait for 10 ns;
        assert (sum = "11111110" and cout = '1')
        report "Test case 2 failed";

        A <= "00000000"; B <= "00000000";
        wait for 10 ns;
        assert (sum = "00000000" and cout = '0')
        report "Test case 3 failed";

        A <= "11111111"; B <= "11111111"; sub <= '1';
        wait for 10 ns;
        assert (sum = "00000000" and cout = '1')
        report "Test case 4 failed";

        A <= "11000001"; B <= "11000000"; sub <= '1';
        wait for 10 ns;
        assert (sum = "00000001" and cout = '0')
        report "Test case 5 failed";

        -- Finish simulation
        wait;
    end process;
end Behavioral;
