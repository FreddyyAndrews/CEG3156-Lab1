library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------
-- 8-bit CLA with Subtraction
-------------------------------------------

entity eightBitCLA is
    port (
        A    : in std_logic_vector(7 downto 0); -- First input
        B    : in std_logic_vector(7 downto 0); -- Second input
        sub  : in std_logic;                    -- Subtraction signal (1 = subtraction, 0 = addition)
        sum  : out std_logic_vector(7 downto 0); -- Sum output
        cout : out std_logic                     -- Carry-out
    );
end eightBitCLA;

architecture structural of eightBitCLA is

    signal cn: std_logic_vector(7 downto 0);  -- carry
    signal gn: std_logic_vector(7 downto 0);  -- generate
    signal pn: std_logic_vector(7 downto 0);  -- propagate
    signal B_xor_sub: std_logic_vector(7 downto 0); -- Modified B based on sub signal

begin

    -- XOR B with the sub signal for two's complement subtraction
    GEN_B_xor_sub: for i in 0 to 7 generate
        B_xor_sub(i) <= B(i) xor sub; -- Flip B bits if sub = 1
    end generate GEN_B_xor_sub;

    -- Generate signals (gn = A and B_xor_sub)
    GEN_gn: for i in 0 to 7 generate
        gn(i) <= A(i) and B_xor_sub(i);
    end generate GEN_gn;

    -- Propagate signals (pn = A or B_xor_sub)
    GEN_pn: for i in 0 to 7 generate
        pn(i) <= A(i) or B_xor_sub(i);
    end generate GEN_pn;
    
    -- Compute carry for the first bit (sub acts as the initial carry-in for subtraction)
    cn(0) <= gn(0) or (sub and pn(0));

    -- Compute carry for the remaining bits
    GEN_cn: for i in 1 to 7 generate
        cn(i) <= gn(i) or (cn(i-1) and pn(i));  -- Carry if generate or propagate previous carry
    end generate GEN_cn;

    sum(0) <= A(0) xor B_xor_sub(0) xor sub;

    -- Compute sum
    GEN_sum: for i in 1 to 7 generate
        sum(i) <= A(i) xor B_xor_sub(i) xor cn(i-1);
    end generate GEN_sum;

    -- Carry-out
    cout <= cn(7);

end architecture structural;
