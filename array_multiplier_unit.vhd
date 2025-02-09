library ieee;
use ieee.std_logic_1164.all;

entity array_multiplier_unit is
    port (
        a: in std_logic;
        b: in std_logic;
        c_in: in std_logic;
        pp_in: in std_logic;
          a_through: out std_logic;
          b_through: out std_logic;
        c_out: out std_logic;
        pp_out: out std_logic);
end entity array_multiplier_unit;

architecture structural of array_multiplier_unit is

    component full_adder
        port (
            a, b, cin: in std_logic;
            sum, cout: out std_logic
        );
    end component full_adder;

    SIGNAL b_and_a: std_logic;

BEGIN

    b_and_a <= b and a;

    -- sum
    full_adder_1: full_adder port map (a => b_and_a, b => pp_in, cin => c_in, sum => pp_out, cout => c_out);

    -- a_through
    a_through <= a;

    -- b_through
    b_through <= b;


END architecture structural;