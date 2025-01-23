library ieee;
use ieee.std_logic_1164.all;

-- Completely untested and probably broken

entity cla3 is
    port(
        a    : in  std_logic_vector(2 downto 0);
        b    : in  std_logic_vector(2 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(2 downto 0);
        cout : out std_logic;
        Gout : out std_logic;  -- Group Generate
        Pout : out std_logic   -- Group Propagate
    );
end entity cla3;

architecture structural of cla3 is

    signal G : std_logic_vector(2 downto 0);
    signal P : std_logic_vector(2 downto 0);
    signal c : std_logic_vector(3 downto 0);

begin

    c(0) <= cin;

    GEN_P0:  G(0) <= a(0) and b(0);
    PROP_P0: P(0) <= a(0) or  b(0);
    GEN_P1:  G(1) <= a(1) and b(1);
    PROP_P1: P(1) <= a(1) or  b(1);
    GEN_P2:  G(2) <= a(2) and b(2);
    PROP_P2: P(2) <= a(2) or  b(2);

    CARRY_1: c(1) <= (G(0)) or (P(0) and c(0));
    CARRY_2: c(2) <= (G(1)) or (P(1) and c(1));
    CARRY_3: c(3) <= (G(2)) or (P(2) and c(2));

    SUM_0: sum(0) <= (a(0) xor b(0)) xor c(0);
    SUM_1: sum(1) <= (a(1) xor b(1)) xor c(1);
    SUM_2: sum(2) <= (a(2) xor b(2)) xor c(2);

    cout <= c(3);

    -- Group Generate (3 bits)
    GOUT_ASSIGN: Gout <= G(2)
                   or (P(2) and G(1))
                   or (P(2) and P(1) and G(0));

    -- Group Propagate (3 bits)
    POUT_ASSIGN: Pout <= P(2) and P(1) and P(0);

end architecture structural;