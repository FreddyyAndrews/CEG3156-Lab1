library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eight_bit_array_multiplier_tb is
end entity eight_bit_array_multiplier_tb;

architecture sim of eight_bit_array_multiplier_tb is

    signal a : std_logic_vector(7 downto 0);
    signal b : std_logic_vector(7 downto 0);
    signal p : std_logic_vector(15 downto 0);

begin

    DUT: entity work.eight_bit_array_multiplier
        port map (
            a => a,
            b => b,
            p => p
        );

    stim: process
    begin
        -- Test 1: 0 * 0 = 0
        a <= "00000000";
        b <= "00000000";
        wait for 10 ns;
        assert p = "0000000000000000"
            report "Test 1 failed: 0 * 0" 
            severity error;

        -- Test 2: 1 * 1 = 1
        a <= "00000001";
        b <= "00000001";
        wait for 10 ns;
        assert p = "0000000000000001"
            report "Test 2 failed: 1 * 1"
            severity error;

        -- Test 3: 2 * 3 = 6
        a <= "00000010";  -- 2
        b <= "00000011";  -- 3
        wait for 10 ns;
        assert p = "0000000000000110"
            report "Test 3 failed: 2 * 3"
            severity error;

        -- Test 4: 255 * 255 = 65025 = "1111111000000001"
        a <= "11111111";
        b <= "11111111";
        wait for 10 ns;
        assert p = "1111111000000001"
            report "Test 4 failed: 255 * 255"
            severity error;

        wait;
    end process stim;

end architecture sim;
