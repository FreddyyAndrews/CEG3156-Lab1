library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Half Adder
-------------------------------------------------------------------------------
entity half_adder is
  port (
    A    : in  std_logic;
    B    : in  std_logic;
    SUM  : out std_logic;
    COUT : out std_logic
  );
end entity half_adder;

architecture structural of half_adder is
begin
  -- Half Adder logic using concurrent statements
  SUM  <= A xor B;
  COUT <= A and B;
end architecture structural;

-------------------------------------------------------------------------------
-- Full Adder
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
  port (
    A    : in  std_logic;
    B    : in  std_logic;
    CIN  : in  std_logic;
    SUM  : out std_logic;
    COUT : out std_logic
  );
end entity full_adder;

architecture structural of full_adder is
  signal hs, hc1, hc2 : std_logic;
begin
  -- First half-adder
  HA1: entity work.half_adder
    port map (
      A    => A,
      B    => B,
      SUM  => hs,
      COUT => hc1
    );

  -- Second half-adder
  HA2: entity work.half_adder
    port map (
      A    => hs,
      B    => CIN,
      SUM  => SUM,
      COUT => hc2
    );

  -- Combine carries
  COUT <= hc1 or hc2;
end architecture structural;

-------------------------------------------------------------------------------
-- 23-bit Adder/Subtractor
-- SUB = '0' => A + B
-- SUB = '1' => A - B  (via A + (2's complement of B))
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_subtractor_23 is
  port (
    A    : in  std_logic_vector(22 downto 0);
    B    : in  std_logic_vector(22 downto 0);
    SUB  : in  std_logic;  -- Control bit: 0 => Add, 1 => Subtract
    SUM  : out std_logic_vector(22 downto 0);
    COUT : out std_logic
  );
end entity adder_subtractor_23;

architecture structural of adder_subtractor_23 is
  -- B_in will be B XOR SUB:
  --   if SUB = 0 => B_in = B
  --   if SUB = 1 => B_in = NOT(B)
  signal B_in : std_logic_vector(22 downto 0);

  -- Internal carry signals, 24 bits to include final carry
  signal c : std_logic_vector(23 downto 0);
begin
  -- Generate the appropriately inverted B
  GEN_B_IN: for i in 0 to 22 generate
    B_in(i) <= B(i) xor SUB;
  end generate GEN_B_IN;

  -- Initial carry-in is SUB (if SUB=1 => add the '1' for 2's complement)
  c(0) <= SUB;

  -- Instantiate 23 full adders for ripple carry
  GEN_ADDERS: for i in 0 to 22 generate
    FA: entity work.full_adder
      port map (
        A    => A(i),
        B    => B_in(i),
        CIN  => c(i),
        SUM  => SUM(i),
        COUT => c(i+1)
      );
  end generate GEN_ADDERS;

  -- Final carry-out
  COUT <= c(23);

end architecture structural;
