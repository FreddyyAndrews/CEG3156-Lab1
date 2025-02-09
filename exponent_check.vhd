LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY exponent_check IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		SignA :  IN  STD_LOGIC;
		SignB :  IN  STD_LOGIC;
		A :  IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		AM :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		B :  IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
		BM :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		AgtB :  OUT  STD_LOGIC;
		BgtA :  OUT  STD_LOGIC;
		IncEA2 :  OUT  STD_LOGIC;
		IncEB :  OUT  STD_LOGIC;
		SREA :  OUT  STD_LOGIC;
		SREB :  OUT  STD_LOGIC;
		load_EA :  OUT  STD_LOGIC;
		loead_EB :  OUT  STD_LOGIC;
		s0 :  OUT  STD_LOGIC;
		s1 :  OUT  STD_LOGIC;
		s2 :  OUT  STD_LOGIC;
		AeqB :  OUT  STD_LOGIC;
		s3 :  OUT  STD_LOGIC;
		outputright :  OUT  STD_LOGIC;
		SignOutput :  OUT  STD_LOGIC;
		left_out :  OUT  STD_LOGIC;
		zero :  OUT  STD_LOGIC;
		A_2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		AMState :  OUT  STD_LOGIC_VECTOR(8 DOWNTO 0);
		B_2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		BMState :  OUT  STD_LOGIC_VECTOR(8 DOWNTO 0);
		InitialESum :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		ouputRE :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		sumM :  OUT  STD_LOGIC_VECTOR(8 DOWNTO 0);
		tempM :  OUT  STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END exponent_check;

ARCHITECTURE bdf_type OF exponent_check IS 

COMPONENT nine_bit_right_shift_register
	PORT(load : IN STD_LOGIC;
		 serial_input : IN STD_LOGIC;
		 shift_right : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 right_output : OUT STD_LOGIC;
		 highest_8 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 parrallel_output : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT eightbitcla
	PORT(sub : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 cout : OUT STD_LOGIC;
		 sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT controller
	PORT(SignA : IN STD_LOGIC;
		 SignB : IN STD_LOGIC;
		 AgtB : IN STD_LOGIC;
		 BgtA : IN STD_LOGIC;
		 AeqB : IN STD_LOGIC;
		 MAgtMB : IN STD_LOGIC;
		 MAeqMB : IN STD_LOGIC;
		 GClock : IN STD_LOGIC;
		 Cout : IN STD_LOGIC;
		 OutputRight : IN STD_LOGIC;
		 MRzero : IN STD_LOGIC;
		 InitialESUM : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 tempM : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 SelectorCLA : OUT STD_LOGIC;
		 IncEA : OUT STD_LOGIC;
		 IncEB : OUT STD_LOGIC;
		 SREA : OUT STD_LOGIC;
		 SREB : OUT STD_LOGIC;
		 loadEA : OUT STD_LOGIC;
		 loeadEB : OUT STD_LOGIC;
		 s0 : OUT STD_LOGIC;
		 s1 : OUT STD_LOGIC;
		 s2 : OUT STD_LOGIC;
		 s3 : OUT STD_LOGIC;
		 loadResult : OUT STD_LOGIC;
		 serialInputResult : OUT STD_LOGIC;
		 ShiftRightResult : OUT STD_LOGIC;
		 SubALU : OUT STD_LOGIC;
		 resetBarR : OUT STD_LOGIC;
		 loadRE : OUT STD_LOGIC;
		 loadRS : OUT STD_LOGIC;
		 SLMR : OUT STD_LOGIC;
		 ERdec : OUT STD_LOGIC;
		 MRInc : OUT STD_LOGIC;
		 ERInc : OUT STD_LOGIC;
		 SelectorSign : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT enardff_2
	PORT(i_resetBar : IN STD_LOGIC;
		 i_d : IN STD_LOGIC;
		 i_enable : IN STD_LOGIC;
		 i_clock : IN STD_LOGIC;
		 o_q : OUT STD_LOGIC;
		 o_qBar : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT sevenbitregisterinc
	PORT(inc : IN STD_LOGIC;
		 load : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset_bar : IN STD_LOGIC;
		 i_Value : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 o_Value : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux_4to1
	PORT(din0 : IN STD_LOGIC;
		 din1 : IN STD_LOGIC;
		 din2 : IN STD_LOGIC;
		 din3 : IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dout : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT eightbitcomparator
	PORT(A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 A_gt_B : OUT STD_LOGIC;
		 A_eq_B : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mux2x9
	PORT(S : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 F : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ninebitcla
	PORT(sub : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 cout : OUT STD_LOGIC;
		 sum : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sevenbitregisterincdec
	PORT(inc : IN STD_LOGIC;
		 dec : IN STD_LOGIC;
		 load : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset_bar : IN STD_LOGIC;
		 i_Value : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 o_Value : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT nine_bit_dual_direction_shift_register
	PORT(load : IN STD_LOGIC;
		 shift_left : IN STD_LOGIC;
		 shift_right : IN STD_LOGIC;
		 serial_input : IN STD_LOGIC;
		 inc : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 parallel_input : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 left_output : OUT STD_LOGIC;
		 right_output : OUT STD_LOGIC;
		 zero : OUT STD_LOGIC;
		 parallel_output : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	CoutALU :  STD_LOGIC;
SIGNAL	ERInc :  STD_LOGIC;
SIGNAL	GClock :  STD_LOGIC;
SIGNAL	InitialInpA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	InitialInpB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	InpA :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	InpB :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	inputAM :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	inputBM :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	loadER :  STD_LOGIC;
SIGNAL	MoutALU :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	MRInc :  STD_LOGIC;
SIGNAL	outputRight_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	ozero :  STD_LOGIC;
SIGNAL	reset_bar_ER :  STD_LOGIC;
SIGNAL	ShiftMA :  STD_LOGIC;
SIGNAL	ShiftMB :  STD_LOGIC;
SIGNAL	SignA2 :  STD_LOGIC;
SIGNAL	SignB2 :  STD_LOGIC;
SIGNAL	SLMR :  STD_LOGIC;
SIGNAL	tempMC :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_41 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_42 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_43 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_44 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_45 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_46 :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_47 :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;


BEGIN 
AgtB <= SYNTHESIZED_WIRE_42;
BgtA <= SYNTHESIZED_WIRE_4;
IncEA2 <= SYNTHESIZED_WIRE_10;
IncEB <= SYNTHESIZED_WIRE_12;
load_EA <= SYNTHESIZED_WIRE_44;
loead_EB <= SYNTHESIZED_WIRE_41;
AeqB <= SYNTHESIZED_WIRE_43;
AMState <= SYNTHESIZED_WIRE_46;
BMState <= SYNTHESIZED_WIRE_47;
InitialESum <= SYNTHESIZED_WIRE_8;
SYNTHESIZED_WIRE_1 <= '0';
SYNTHESIZED_WIRE_2 <= '1';
SYNTHESIZED_WIRE_18 <= '1';
SYNTHESIZED_WIRE_19 <= '0';
SYNTHESIZED_WIRE_22 <= '0';
SYNTHESIZED_WIRE_24 <= '1';



b2v_asdasdasdf : nine_bit_right_shift_register
PORT MAP(load => SYNTHESIZED_WIRE_41,
		 serial_input => SYNTHESIZED_WIRE_1,
		 shift_right => ShiftMB,
		 clk => GClock,
		 input => inputBM,
		 parrallel_output => SYNTHESIZED_WIRE_47);


b2v_inst : eightbitcla
PORT MAP(sub => SYNTHESIZED_WIRE_2,
		 A => InitialInpA,
		 B => InitialInpB,
		 sum => SYNTHESIZED_WIRE_8);




b2v_inst12 : controller
PORT MAP(SignA => SignA2,
		 SignB => SignB2,
		 AgtB => SYNTHESIZED_WIRE_42,
		 BgtA => SYNTHESIZED_WIRE_4,
		 AeqB => SYNTHESIZED_WIRE_43,
		 MAgtMB => SYNTHESIZED_WIRE_6,
		 MAeqMB => SYNTHESIZED_WIRE_7,
		 GClock => GClock,
		 Cout => CoutALU,
		 OutputRight => outputRight_ALTERA_SYNTHESIZED,
		 MRzero => ozero,
		 InitialESUM => SYNTHESIZED_WIRE_8,
		 tempM => tempMC,
		 SelectorCLA => SYNTHESIZED_WIRE_45,
		 IncEA => SYNTHESIZED_WIRE_10,
		 IncEB => SYNTHESIZED_WIRE_12,
		 SREA => SREA,
		 SREB => SREB,
		 loadEA => SYNTHESIZED_WIRE_44,
		 loeadEB => SYNTHESIZED_WIRE_41,
		 s0 => s0,
		 s1 => s1,
		 s2 => s2,
		 s3 => s3,
		 loadResult => SYNTHESIZED_WIRE_35,
		 serialInputResult => SYNTHESIZED_WIRE_37,
		 ShiftRightResult => SYNTHESIZED_WIRE_36,
		 SubALU => SYNTHESIZED_WIRE_31,
		 resetBarR => reset_bar_ER,
		 loadRE => loadER,
		 loadRS => SYNTHESIZED_WIRE_16,
		 SLMR => SLMR,
		 ERdec => SYNTHESIZED_WIRE_34,
		 MRInc => MRInc,
		 ERInc => ERInc,
		 SelectorSign => SYNTHESIZED_WIRE_20);


ShiftMA <= SYNTHESIZED_WIRE_9 AND SYNTHESIZED_WIRE_10;


ShiftMB <= SYNTHESIZED_WIRE_11 AND SYNTHESIZED_WIRE_12;


SYNTHESIZED_WIRE_11 <= NOT(SYNTHESIZED_WIRE_43);



SYNTHESIZED_WIRE_9 <= NOT(SYNTHESIZED_WIRE_43);



b2v_inst19 : enardff_2
PORT MAP(i_resetBar => reset_bar_ER,
		 i_d => SYNTHESIZED_WIRE_15,
		 i_enable => SYNTHESIZED_WIRE_16,
		 i_clock => GClock,
		 o_q => SignOutput);


b2v_inst2 : sevenbitregisterinc
PORT MAP(inc => ShiftMA,
		 load => SYNTHESIZED_WIRE_44,
		 clk => GClock,
		 reset_bar => SYNTHESIZED_WIRE_18,
		 i_Value => InitialInpA(6 DOWNTO 0),
		 o_Value => InpA(6 DOWNTO 0));


b2v_inst20 : mux_4to1
PORT MAP(din0 => '0',
		 din1 => SignA2,
		 din2 => SignB2,
		 din3 => SYNTHESIZED_WIRE_19,
		 sel => SYNTHESIZED_WIRE_20,
		 dout => SYNTHESIZED_WIRE_15);


b2v_inst21 : eightbitcomparator
PORT MAP(A => inputAM,
		 B => inputBM,
		 A_gt_B => SYNTHESIZED_WIRE_6,
		 A_eq_B => SYNTHESIZED_WIRE_7);


b2v_inst24 : nine_bit_right_shift_register
PORT MAP(load => SYNTHESIZED_WIRE_44,
		 serial_input => SYNTHESIZED_WIRE_22,
		 shift_right => ShiftMA,
		 clk => GClock,
		 input => inputAM,
		 parrallel_output => SYNTHESIZED_WIRE_46);




b2v_inst3 : sevenbitregisterinc
PORT MAP(inc => ShiftMB,
		 load => SYNTHESIZED_WIRE_41,
		 clk => GClock,
		 reset_bar => SYNTHESIZED_WIRE_24,
		 i_Value => InitialInpB(6 DOWNTO 0),
		 o_Value => InpB(6 DOWNTO 0));




b2v_inst4 : eightbitcomparator
PORT MAP(A => InpA,
		 B => InpB,
		 A_gt_B => SYNTHESIZED_WIRE_42,
		 A_eq_B => SYNTHESIZED_WIRE_43);


b2v_inst41 : mux2x9
PORT MAP(S => SYNTHESIZED_WIRE_45,
		 A => SYNTHESIZED_WIRE_46,
		 B => SYNTHESIZED_WIRE_47,
		 F => SYNTHESIZED_WIRE_32);


b2v_inst42 : mux2x9
PORT MAP(S => SYNTHESIZED_WIRE_28,
		 A => SYNTHESIZED_WIRE_46,
		 B => SYNTHESIZED_WIRE_47,
		 F => SYNTHESIZED_WIRE_33);


b2v_inst43 : ninebitcla
PORT MAP(sub => SYNTHESIZED_WIRE_31,
		 A => SYNTHESIZED_WIRE_32,
		 B => SYNTHESIZED_WIRE_33,
		 cout => CoutALU,
		 sum => MoutALU);


b2v_inst49 : sevenbitregisterincdec
PORT MAP(inc => ERInc,
		 dec => SYNTHESIZED_WIRE_34,
		 load => loadER,
		 clk => GClock,
		 reset_bar => reset_bar_ER,
		 i_Value => InpA(6 DOWNTO 0),
		 o_Value => ouputRE);



b2v_inst7 : nine_bit_dual_direction_shift_register
PORT MAP(load => SYNTHESIZED_WIRE_35,
		 shift_left => SLMR,
		 shift_right => SYNTHESIZED_WIRE_36,
		 serial_input => SYNTHESIZED_WIRE_37,
		 inc => MRInc,
		 clk => GClock,
		 parallel_input => MoutALU,
		 left_output => left_out,
		 right_output => outputRight_ALTERA_SYNTHESIZED,
		 zero => ozero,
		 parallel_output => tempMC);


SYNTHESIZED_WIRE_4 <= NOT(SYNTHESIZED_WIRE_43 OR SYNTHESIZED_WIRE_42);


SYNTHESIZED_WIRE_28 <= NOT(SYNTHESIZED_WIRE_45);


SignA2 <= SignA;
SignB2 <= SignB;
inputAM <= AM;
inputBM <= BM;
GClock <= Clk;
outputright <= outputRight_ALTERA_SYNTHESIZED;
zero <= ozero;
A_2 <= InpA;
B_2 <= InpB;
sumM <= MoutALU;
tempM <= tempMC;

InitialInpA(7) <= '0';
InitialInpA(6 DOWNTO 0) <= A;
InitialInpB(7) <= '0';
InitialInpB(6 DOWNTO 0) <= B;

InpA(7) <= '0';  -- Assign the 8th bit to '0'
InpB(7) <= '0';

END bdf_type;