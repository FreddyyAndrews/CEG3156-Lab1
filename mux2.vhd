LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2 IS
    PORT(
        sel  : IN  std_logic;       -- Select signal
        a  : IN  std_logic;       -- Data input 0
        b  : IN  std_logic;       -- Data input 1
        y : OUT std_logic        -- Multiplexer output
    );
END mux2;

ARCHITECTURE structural OF mux2 IS
BEGIN
    -- outy = (in0 AND NOT sel) OR (in1 AND sel)
    y <= (a AND (NOT sel)) OR (b AND sel);
END structural;