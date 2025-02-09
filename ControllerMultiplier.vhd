library ieee;
use ieee.std_logic_1164.all;

entity ControllerMultiplier is
    port (
        Overflow    : in std_logic; -- First input
        Underflow    : in std_logic; -- Second input
        M7  : in std_logic;                    
        M17  : in std_logic;
		  GClock : in std_logic;
		  resetBar : in std_LOGIC;
        loadAB  : out std_logic;
        incTE  : out std_logic;
        loadTE  : out std_logic;
		  loadRE : out std_logic;
        incTM : out std_logic;
        SRTM : out std_logic;
		  loadTM: out std_logic;
		  loadRM: out std_logic;
		  s0 : out std_logic;
		  s1 : out std_logic;
		  s2 : out std_logic; 
		  s3 : out std_logic;
		  O_OVERFLOW : out std_logic
		  );
end ControllerMultiplier;

architecture structural of ControllerMultiplier is
	SIGNAL  i_q3, q3, notq2, i_q2, q2,i_q1, notq3, i_q0, q0, q1, o_q, notq1, notq0, AxorB, MBgtMA  : STD_logic;
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
		 
	i_q0 <= state0 or (state2 and M17) or (state4 and not(underflow) and not(overflow)) or (state5 and not(M7)) or state9;
	i_q1 <= state1 or (state2 and M17) or (state5 and M7) or state6 ;
	i_q2 <= state3 or (state2 and not(M17)) or (state4 and not(underflow) and not(overflow)) or (state5 and M7);
	i_q3 <= (state4 and (overflow or underflow))  or (state5 and not(M7)) or state8 or state9;

	loadAB <= state0;
  loadTE <=state1;
  incTE  <= state3;
  loadRE <= state5;
  incTM <= state6;
  SRTM <=state3;
  loadTM <= state1;
  loadRM<= state4;
  O_OVERFLOW <= state8;
	  
end architecture structural;
