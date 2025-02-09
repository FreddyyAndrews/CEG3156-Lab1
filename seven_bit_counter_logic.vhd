library ieee;
use ieee.std_logic_1164.all;

entity seven_bit_counter_logic is
    port(
        q : in std_logic_vector(6 downto 0);
        q_plus: out std_logic_vector(6 downto 0)
    );
end entity seven_bit_counter_logic;

architecture Structural of seven_bit_counter_logic is
begin
    q_plus(0) <= (not q(0));
    q_plus(1) <= q(0) xor q(1);
    q_plus(2) <= (q(0) and q(1)) xor q(2);
    q_plus(3) <= ((q(0) and q(1)) and q(2)) xor q(3);
    q_plus(4) <= ((q(0) and q(1)) and q(2) and q(3)) xor q(4);
    q_plus(5) <= ((q(0) and q(1)) and q(2) and q(3) and q(4)) xor q(5);
    q_plus(6) <= ((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) xor q(6);
end Structural;