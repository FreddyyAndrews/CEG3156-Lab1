library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
    Port ( sel : in  STD_LOGIC_VECTOR (1 downto 0);
           din0 : in  STD_LOGIC;
			  din1 : in  STD_LOGIC;
			  din2 : in  STD_LOGIC;
			  din3 : in  STD_LOGIC;
           dout : out  STD_LOGIC);
end mux_4to1;

architecture arch of mux_4to1 is
begin
	
    dout <= (din0 and (not sel(0)) and (not sel(1))) or 
            (din1 and sel(0) and (not sel(1))) or 
            (din2 and (not sel(0)) and sel(1)) or 
            (din3 and sel(0) and sel(1));

end arch;