library ieee;
use ieee.std_logic_1164.all;

entity xor2 is
    port (
        a : in  std_logic;
        b : in  std_logic;
        y : out std_logic
    );
end entity xor2;

architecture structural of xor2 is
begin
    -- y = a XOR b
    y <= (a and not b) or (not a and b);
end architecture structural;