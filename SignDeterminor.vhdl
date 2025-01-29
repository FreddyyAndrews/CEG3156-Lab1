library ieee;
use ieee.std_logic_1164.all;

ENTITY SignDeterminor is
    PORT(
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        SignA: in std_logic;
        SignB: in std_logic;
        SignOut: out std_logic);
END SignDeterminor;

architecture structural of SignDeterminor is
    signal A_gt_B: std_logic;
    signal A_eq_B: std_logic;
begin

    Comparator: ENTITY work.eightBitComparator
    PORT MAP(A => A, B => B, A_gt_B => A_gt_B, A_eq_B => A_eq_B);

    SignOut <= (SignA and A_gt_B) or (SignB and not A_gt_B);

end architecture structural;