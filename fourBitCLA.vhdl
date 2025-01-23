LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Completely untested and probably broken

entity cla4 is
    port(
        a    : in  std_logic_vector(3 downto 0);
        b    : in  std_logic_vector(3 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(3 downto 0);
        cout : out std_logic;
        Gout : out std_logic;  -- Group Generate
        Pout : out std_logic   -- Group Propagate
    );
end entity cla4;

architecture structural of cla4 is

    -- Generate and Propagate signals for each bit
    signal G : std_logic_vector(3 downto 0);
    signal P : std_logic_vector(3 downto 0);

    -- Internal carry signals c(0..3), where c(0) = cin
    -- c(4) = cout
    signal c : std_logic_vector(4 downto 0);

begin

    c(0) <= cin;  -- least significant carry is the input carry

    -- Bitwise generate/propagate
    GEN_P0:  G(0) <= a(0) and b(0);
    PROP_P0: P(0) <= a(0) or  b(0);
    GEN_P1:  G(1) <= a(1) and b(1);
    PROP_P1: P(1) <= a(1) or  b(1);
    GEN_P2:  G(2) <= a(2) and b(2);
    PROP_P2: P(2) <= a(2) or  b(2);
    GEN_P3:  G(3) <= a(3) and b(3);
    PROP_P3: P(3) <= a(3) or  b(3);

    -- Carry lookahead within this 4-bit block (fast local lookahead)
    -- c(i+1) = G(i) OR (P(i) AND c(i))
    CARRY_1: c(1) <= (G(0)) or (P(0) and c(0));
    CARRY_2: c(2) <= (G(1)) or (P(1) and c(1));
    CARRY_3: c(3) <= (G(2)) or (P(2) and c(2));
    CARRY_4: c(4) <= (G(3)) or (P(3) and c(3));

    -- Sum bits: sum(i) = a(i) XOR b(i) XOR c(i)
    SUM_0: sum(0) <= (a(0) xor b(0)) xor c(0);
    SUM_1: sum(1) <= (a(1) xor b(1)) xor c(1);
    SUM_2: sum(2) <= (a(2) xor b(2)) xor c(2);
    SUM_3: sum(3) <= (a(3) xor b(3)) xor c(3);

    cout <= c(4);

    -- Group Generate, Group Propagate (for next-level carry logic)
    -- Gout = G(3) OR P(3)*G(2) OR P(3)*P(2)*G(1) OR P(3)*P(2)*P(1)*G(0)
    GOUT_ASSIGN: Gout <=  G(3)
                  or (P(3) and G(2))
                  or (P(3) and P(2) and G(1))
                  or (P(3) and P(2) and P(1) and G(0));

    -- Pout = P(3)*P(2)*P(1)*P(0)
    POUT_ASSIGN: Pout <= P(3) and P(2) and P(1) and P(0);

end architecture structural;