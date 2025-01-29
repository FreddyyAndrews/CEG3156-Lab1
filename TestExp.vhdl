library ieee;
use ieee.std_logic_1164.all;

Entity TestExp is
    PORT(
    A: in std_logic_vector(6 downto 0);
    B: in std_logic_vector(6 downto 0);
    clock : in std_logic;
    A_gt_B: out std_logic;
    B_gt_A: out std_logic;
    ResultReg: out std_logic_vector(7 downto 0);
    cloook:  out std_logic;
    inputALUA: out std_logic_vector(7 downto 0);
    inputALUB: out std_logic_vector(7 downto 0));
END TestExp;

architecture structural of TestExp is
    component sevenBitRegisterInc
    PORT(
        i_Value      : IN  STD_LOGIC_VECTOR(6 downto 0);
        inc          : IN  STD_LOGIC;
        load         : IN  STD_LOGIC;
        clk          : IN  STD_LOGIC;
        reset_bar        : IN  STD_LOGIC;
        o_Value      : OUT STD_LOGIC_VECTOR(6 downto 0)
    );
    END component;

    component eightBitComparator
        PORT(
        A: in std_logic_vector(7 downto 0);
        B: in std_logic_vector(7 downto 0);
        A_gt_B: out std_logic;
        A_eq_B: out std_logic);
    END component;

    component eightBitShiftRight IS
    PORT(
        i_Value      : IN  STD_LOGIC_VECTOR(7 downto 0);
        shift_value  : IN  STD_LOGIC;           -- Bit shifted into the leftmost position (bit 22)
        shift : IN  STD_LOGIC;           -- Enables right shift
        load         : IN  STD_LOGIC;           -- Loads i_Value in parallel
        clk          : IN  STD_LOGIC;
        reset_bar        : IN  STD_LOGIC;           -- Active-high reset
        o_Value      : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
    END component;

    component eightBitCLA is
        port (
            A    : in std_logic_vector(7 downto 0); -- First input
            B    : in std_logic_vector(7 downto 0); -- Second input
            sub  : in std_logic;                    -- Subtraction signal (1 = subtraction, 0 = addition)
            sum  : out std_logic_vector(7 downto 0); -- Sum output
            cout : out std_logic                     -- Carry-out
        );
    END component;

    SIGNAL valueEA, valueEB : std_logic_vector(6 downto 0);
    SIGNAL input_comparator_EA, input_comparator_EB, out_ALU : std_logic_vector(7 downto 0);
    SIGNAL AgtB, AeqB, Cout: std_logic;
begin
    RegEA: sevenBitRegisterInc
        PORT MAP (
            i_Value =>A,
            inc => '0' ,
            load => '1',
            clk => clock,
            reset_bar => '1',
            o_Value => valueEA
         );


    RegEB: sevenBitRegisterInc
        PORT MAP (
             i_Value =>A,
             inc => '0' ,
             load => '1',
             clk => clock,
             reset_bar => '1',
             o_Value => valueEB
          );

    ALU: eightBitCLA
          PORT MAP(
              A => input_comparator_EA,
              B => input_comparator_EB,
              sub => '1',                    -- Subtraction signal (1 = subtraction, 0 = addition)
              sum  => out_ALU, -- Sum output
              cout => Cout                   -- Carry-out
          );

    comparator: eightBitComparator
          PORT MAP(
          A => input_comparator_EA,
          B => input_comparator_EA,
          A_gt_B =>AgtB,
          A_eq_B => AeqB);

    input_comparator_EA <= '0' & valueEA;
    input_comparator_EB <= '0' & valueEB;
    B_gt_A <= NOT(AgtB OR AeqB);
    ResultReg <= out_ALU;
    inputALUA <=input_comparator_EA;
    inputALUAB <=input_comparator_EB;
    cloook <= clock;

END structural;