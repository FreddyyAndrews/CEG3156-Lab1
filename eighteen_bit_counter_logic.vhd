library ieee;
use ieee.std_logic_1164.all;

entity eighteen_bit_counter_logic is
    port(
        q : in std_logic_vector(17 downto 0);
        q_plus: out std_logic_vector(17 downto 0)
    );
end entity eighteen_bit_counter_logic;

architecture Structural of eighteen_bit_counter_logic is
begin
    q_plus(0) <= (not q(0));
    q_plus(1) <= q(0) xor q(1);
    q_plus(2) <= (q(0) and q(1)) xor q(2);
    q_plus(3) <= ((q(0) and q(1)) and q(2)) xor q(3);
    q_plus(4) <= ((q(0) and q(1)) and q(2) and q(3)) xor q(4);
    q_plus(5) <= ((q(0) and q(1)) and q(2) and q(3) and q(4)) xor q(5);
    q_plus(6) <= ((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) xor q(6);
    q_plus(7) <= (((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) xor q(7);
    q_plus(8) <= ((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) xor q(8);
    q_plus(9) <= (((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) xor q(9);
    q_plus(10) <= ((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) xor q(10);
    q_plus(11) <= (((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) xor q(11);
    q_plus(12) <= ((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) xor q(12);
    q_plus(13) <= (((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) and q(12)) xor q(13);
    q_plus(14) <= ((((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) and q(12)) and q(13)) xor q(14);
    q_plus(15) <= (((((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) and q(12)) and q(13)) and q(14)) xor q(15);
    q_plus(16) <= ((((((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) and q(12)) and q(13)) and q(14)) and q(15)) xor q(16);
    q_plus(17) <= (((((((((((((q(0) and q(1)) and q(2) and q(3) and q(4) and q(5)) and q(6)) and q(7)) and q(8)) and q(9)) and q(10)) and q(11)) and q(12)) and q(13)) and q(14)) and q(15)) and q(16)) xor q(17);

end Structural;