library ieee;
use ieee.std_logic_1164.all;

entity Controller is
    port (
        SignA    : in std_logic; -- First input
        SignB    : in std_logic; -- Second input
        EAgtEB  : in std_logic;                    
        EBgtEA  : in std_logic;
		  EBeqEA: 	in std_logic;
		  MAgtMB  : in std_logic;                    
		  MAeqMB: 	in std_logic;
		  GClock : in std_logic;
		  Cout: in std_logic;
		  OutputRight: in std_logic;
		  InitialEAminusEB : in std_logic_vector(7 downto 0);
		  MRzero : in std_logic;
        SelectorCLA  : out std_logic;
        IncEA  : out std_logic;
        IncEB  : out std_logic;
        SREA : out std_logic;
        SREB : out std_logic;
		  loadEA: out std_logic;
		  loeadEB: out std_logic;
		  s0 : out std_logic;
		  s1 : out std_logic;
		  s2 : out std_logic; 
		  s3 : out std_logic;
		  loadResult : out std_logic;
		  serialInputResult: out std_logic;
		  ShiftRightResult: out std_logic;
		  SubALU : out std_logic;
		  SelectorSign : out std_logic_vector(1 downto 0);
		  resetBarR : out std_LOGIC;
		  loadRE : out std_LOGIC;
		  loadRS : out std_LOGIC;
		  tempM : in std_logic_vector(8 downto 0);
		  SLMR : out std_LOGIC;
		  ERdec : out std_LOGIC;
		  MRInc : out std_LOGIC;
		  ERInc : out std_logic
		  );
end Controller;

architecture structural of Controller is
	SIGNAL AisbiggerthanB, BisbiggerthanA, resetBar, notq3, i_q3, q3, notq2, i_q2, q2,i_q1, i_q0, q0, q1, o_q, notq1, notq0, AxorB, MBgtMA  : STD_logic;
	SIGNAL state0, state1, state2, state3, state4, state5, state6, state7, state8, state9, state10, state11, state12 : STD_LOGIC;
	SIGNAL initAgtB, initAeqB, initBgtA : STD_LOGIC;
	component enardFF_2
		port(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC
		);
	end component;
	
begin
	d3 : enardFF_2
				port map(
					i_resetBar => resetBar,
					i_d => i_q3,
					i_enable => '1',
					i_clock => GClock,
					o_q => q3,
					o_qBar => notq3
				);
	d2 : enardFF_2
			port map(
				i_resetBar => resetBar,
				i_d => i_q2,
				i_enable => '1',
				i_clock => GClock,
				o_q => q2,
				o_qBar => notq2
			);
			
	d1 : enardFF_2
		port map(
			i_resetBar => resetBar,
			i_d => i_q1,
			i_enable => '1',
			i_clock => GClock,
			o_q => q1,
			o_qBar => notq1
		);
		
	d0 : enardFF_2
		port map(
			i_resetBar => resetBar,
			i_d => i_q0,
			i_enable => '1',
			i_clock => GClock,
			o_q => q0,
			o_qBar => notq0
		);
		
	state0  <= not(q3) and not(q2) and not(q1) and not(q0);
   state1  <= not(q3) and not(q2) and not(q1) and q0;
   state2  <= not(q3) and not(q2) and q1 and not(q0);
   state3  <= not(q3) and not(q2) and q1 and q0;
   state4  <= not(q3) and q2 and not(q1) and not(q0);
   state5  <= not(q3) and q2 and not(q1) and q0;
   state6  <= not(q3) and q2 and q1 and not(q0);
   state7  <= not(q3) and q2 and q1 and q0;
   state8  <= q3 and not(q2) and not(q1) and not(q0);
   state9  <= q3 and not(q2) and not(q1) and q0;
   state10 <= q3 and not(q2) and q1 and not(q0);	
	state11 <= q3 and not(q2) and q1 and q0;
	state12 <= q3 and q2 and not(q1) and not(q0);
	
	s0 <= q0;
	s1 <= q1;
	s2 <= q2;
	s3 <= q3;
	
	i_q0 <= (initAgtB and state0) or (initAeqB and state0) or (state1 and EAgtEB) or (AxorB and state4) or (state6 and (Cout and not(AxorB))) or (state8 and not(tempM(8))) or (state7 and outputRight);
	i_q1 <= (initBgtA and state0) or (initAeqB and state0) or (state2 and EBgtEA) or (not(AxorB) and state4) or state5 or (state6 and (Cout and not(AxorB)))or (state8 and tempM(8)) or (state9 and tempM(8)) or state10 or (state7 and outputRight);
	i_q2 <= state3 or (EBeqEA and (state2 or state1) )or state4 or state5 or (state6 and (Cout and not(AxorB))) or (state11 and MRzero) ;
	i_q3 <= (state6 and (not(Cout) or AxorB)) or state7 or state8 or state9 or state10 or state11 or state12;
	
	SREA<= state2;
	SREB <= state1;
	IncEA <= state2;
	IncEB <= state1;
	loadEA<= state0;
	loeadEB<=state0;
	resetBar <= '1';
	AxorB <= (SignA and not(SignB)) or (not(SignA) and SignB);
	SubALU <= AxorB;
	loadResult <= state6;
	serialInputResult <=state7;
	ShiftRightResult <= state7;

	SelectorCLA <= (initBgtA or (initAeqB and not(MAgtMB or MAeqMB)) ) and AxorB;
	
	MBgtMA<= initBgtA;
	SelectorSign(0) <= (state3 and MAgtMB) or state1;
	SelectorSign(1) <= (state3 and not(MAgtMB)) or state2;
	loadRE <= state4;
	resetBarR <='1';
	loadRS <= state1 or state3 or state2;
	
	initAeqB <= not(InitialEAminusEB(7) or InitialEAminusEB(6) or InitialEAminusEB(5) or InitialEAminusEB(4) or InitialEAminusEB(3) or InitialEAminusEB(2) or InitialEAminusEB(1) or InitialEAminusEB(0)) ;
	initAgtB<= not(InitialEAminusEB(7));
	initBgtA <= (InitialEAminusEB(7));
	
	SLMR<= state9;
	ERdec <= state9;
	ERInc <= state12 or state7;
	MRinc <= state11;
	
end architecture structural;
