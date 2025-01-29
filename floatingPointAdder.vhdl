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

    -- Global signals
    signal reset_bar: std_logic;
    -- Control Signals global
    signal load_in: std_logic;
    signal first_shift: std_logic;
    signal A_gt_B: std_logic;
    signal A_eq_B: std_logic;
    signal normalize_input: std_logic;
    -- Arithmetic control signals
    signal am_subbing: std_logic;
    -- Control Signals A
    signal normalize_a: std_logic;
    -- A outputs
    signal sign_a_out: std_logic;
    signal exp_a_out: std_logic_vector(6 downto 0);
    signal mant_a_out: std_logic_vector(7 downto 0);
    -- Control Signals B
    signal normalize_b: std_logic;
    -- B outputs
    signal sign_b_out: std_logic;
    signal exp_b_out: std_logic_vector(6 downto 0);
    signal mant_b_out: std_logic_vector(7 downto 0);
    -- Operation outputs
    mant_operation_out: std_logic_vector(7 downto 0);
    mant_operation_cout: std_logic;
    -- sum register inputs
    signal sum_sign_in: std_logic;
    -- sum control signals
    signal load_sum_sign: std_logic;
    -- sum register outputs
    signal sum_sign: std_logic;

begin

    reset_bar <= not GReset;
    normalize_a <= normalize_input and (not A_gt_B);
    normalize_b <= normalize_input and A_gt_B;
    am_subbing <= sign_a_out xor sign_b_out;  -- doing a subtract operation if signs are different

    -------------------------------------
    -- A
    -------------------------------------
    SignA_Register: ENTITY work.enardFF_2
        PORT MAP(i_resetBar => reset_bar,
        i_d => SignA, i_enable => load_in, i_clock => GClock, o_q => sign_a_out, o_qBar => OPEN);

    ExponentA_Register: ENTITY work.sevenBitRegisterInc
        PORT MAP(i_Value => ExponentA, inc => normalize_a, load => load_in, clk => GClock, reset_bar => reset_bar, o_Value => exp_a_out);

    MantissaA_Register: ENTITY work.eightBitShiftRight
        PORT MAP(i_Value => MantissaA, shift => normalize_a, shift_value => first_shift, load => load_in, clk => GClock, reset_bar => reset_bar, o_Value => mant_a_out);

    -------------------------------------
    -- B
    -------------------------------------
    SignB_Register: ENTITY work.enardFF_2
        PORT MAP(i_resetBar => reset_bar,
        i_d => SignB, i_enable => load_in, i_clock => GClock, o_q => sign_b_out, o_qBar => OPEN);

    ExponentB_Register: ENTITY work.sevenBitRegisterInc
        PORT MAP(i_Value => ExponentB, inc => normalize_b, load => load_in, clk => GClock, reset_bar => reset_bar, o_Value => exp_b_out);

    MantissaB_Register: ENTITY work.eightBitShiftRight
        PORT MAP(i_Value => MantissaB, shift => normalize_b, shift_value => first_shift, load => load_in, clk => GClock, reset_bar => reset_bar, o_Value => mant_b_out);

    -------------------------------------
    -- Data manipulators
    -------------------------------------

    Comparator: ENTITY work.sevenBitComparator
        PORT MAP(A => exp_a_out, B => exp_b_out, A_gt_B => A_gt_B, A_eq_B => A_eq_B);

    ALU: ENTITY work.eightBitCLA
        PORT MAP(A => mant_a_out, B => mant_b_out, sub => am_subbing, sum => mant_operation_out, cout => mant_operation_cout);

    SignDeterminor: ENTITY work.SignDeterminor
        PORT MAP(A => mant_a_out, B => mant_b_out, SignA => sign_a_out, SignB => sign_b_out, SignOut => sum_sign_in);

    -------------------------------------
    -- Controllers
    -------------------------------------
    Controller: ENTITY work.additionController
        PORT MAP();
    -------------------------------------
    -- Sum
    -------------------------------------
    Sign_Sum_Register: ENTITY work.enardFF_2
        PORT MAP(i_resetBar => reset_bar, i_d => sum_sign_in, i_enable => load_sum_sign, i_clock => GClock, o_q => sum_sign, o_qBar => OPEN);

    Exponent_Sum_Register: ENTITY work.sevenBitRegisterInc
        PORT MAP();

    Mantissa_Sum_Register: ENTITY work.eightBitShiftRight
        PORT MAP();

    

end architecture structural;