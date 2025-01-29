library ieee;
use ieee.std_logic_1164.all;

Entity eightBitComparator is
    PORT(
    A: in std_logic_vector(7 downto 0);
    B: in std_logic_vector(7 downto 0);
    A_gt_B: out std_logic;
    A_eq_B: out std_logic);
END eightBitComparator;

architecture structural of eightBitComparator is
    --define signals
    signal gt_conditions: std_logic_vector(7 downto 0);
    signal eq_conditions: std_logic_vector(7 downto 0);

begin

    GEN_eq: for i in 0 to 7 generate
    eq_conditions(i) <= not (A(i) xor B(i));
    end generate GEN_eq;

    gt_conditions(7) <= A(7) and (not B(7));
    gt_conditions(6) <= A(6) and (not B(6)) and eq_conditions(7);
    gt_conditions(5) <= A(5) and (not B(5)) and eq_conditions(7) and eq_conditions(6);
    gt_conditions(4) <= A(4) and (not B(4)) and eq_conditions(7) and eq_conditions(6) and eq_conditions(5);
    gt_conditions(3) <= A(3) and (not B(3)) and eq_conditions(7) and eq_conditions(6) and eq_conditions(5) and eq_conditions(4);
    gt_conditions(2) <= A(2) and (not B(2)) and eq_conditions(7) and eq_conditions(6) and eq_conditions(5) and eq_conditions(4) and eq_conditions(3);
    gt_conditions(1) <= A(1) and (not B(1)) and eq_conditions(7) and eq_conditions(6) and eq_conditions(5) and eq_conditions(4) and eq_conditions(3) and eq_conditions(2);
    gt_conditions(0) <= A(0) and (not B(0)) and eq_conditions(7) and eq_conditions(6) and eq_conditions(5) and eq_conditions(4) and eq_conditions(3) and eq_conditions(2) and eq_conditions(1);

    A_gt_B <= gt_conditions(7) or gt_conditions(6) or gt_conditions(5) or gt_conditions(4) or gt_conditions(3) or gt_conditions(2) or gt_conditions(1) or gt_conditions(0);
    A_eq_B <= eq_conditions(7) and eq_conditions(6) and eq_conditions(5) and eq_conditions(4) and eq_conditions(3) and eq_conditions(2) and eq_conditions(1) and eq_conditions(0);

end architecture structural;