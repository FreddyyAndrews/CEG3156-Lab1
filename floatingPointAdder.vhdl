library ieee;
use ieee.std_logic_1164.all;

ENTITY floatingPointAdder is
    PORT(
        SignA: in std_logic;
        MantissaA: in std_logic_vector(7 downto 0);
        ExponentA: in std_logic_vector(6 downto 0);
        SignB: in std_logic;
        MantissaB: in std_logic_vector(7 downto 0);
        ExponentB: in std_logic_vector(6 downto 0);
        GClock: in std_logic;
        GReset: in std_logic;
        SignOut: out std_logic;
        MantissaOut: out std_logic_vector(7 downto 0);
        ExponentOut: out std_logic_vector(6 downto 0);
        Overflow: out std_logic;
    );
END floatingPointAdder;

architecture structural of floatingPointAdder is

begin

end architecture structural;