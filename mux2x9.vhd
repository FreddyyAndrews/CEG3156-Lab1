library ieee;
use ieee.std_logic_1164.all;

--This mux is used to choose the input of our Gmask and DMask registers
--This means that when the circuit is initialised, we would have our A selected 
-- and B after the first cycle so it would use the value coming out of the ShiftUnits
entity mux2x9 is
	port( A,B: in std_logic_vector(8 downto 0);
			S: in std_logic;
			F: out std_logic_vector(8 downto 0));
end mux2x9;

-- Checks to see if S is 0 and gives A or if S is 1 and gives B
architecture rtl of mux2x9 is
	begin
	F(0) <= ((not S) and A(0)) or (S and B(0));
	F(1) <= ((not S) and A(1)) or (S and B(1));
	F(2) <= ((not S) and A(2)) or (S and B(2));
	F(3) <= ((not S) and A(3)) or (S and B(3));
	F(4) <= ((not S) and A(4)) or (S and B(4));
	F(5) <= ((not S) and A(5)) or (S and B(5));
	F(6) <= ((not S) and A(6)) or (S and B(6));
	F(7) <= ((not S) and A(7)) or (S and B(7));
	F(8) <= ((not S) and A(8)) or (S and B(8));

	
end rtl;