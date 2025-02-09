library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity full_adder is
 Port ( a : in STD_LOGIC;
 b : in STD_LOGIC;
 cin : in STD_LOGIC;
 sum : out STD_LOGIC;
 cout : out STD_LOGIC);
end full_adder;
 
architecture gate_level of full_adder is
 
begin
 
 sum <= A XOR B XOR Cin ;
 Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;
 
end gate_level;
