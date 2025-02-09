LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nine_bit_shift_register IS
    PORT (
        input           : IN  STD_LOGIC_VECTOR(8 DOWNTO 0); -- 9-bit Parallel Load Input
        load            : IN  STD_LOGIC;  -- Load Enable
        serial_input    : IN  STD_LOGIC;  -- Serial Shift Input
        shift_right     : IN  STD_LOGIC;  -- Shift Right Enable
        shift_left      : IN  STD_LOGIC;  -- Shift Left Enable
        clk             : IN  STD_LOGIC;  -- Clock
        right_output    : OUT STD_LOGIC;  -- LSB Output
        left_output     : OUT STD_LOGIC;  -- MSB Output
        parallel_output : OUT STD_LOGIC_VECTOR(8 DOWNTO 0); -- 9-bit Parallel Output
        highest_8       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- 8-bit Parallel Output
    );
END nine_bit_shift_register;

ARCHITECTURE Structural OF nine_bit_shift_register IS
    SIGNAL temp_q, temp_mux, parallel_input : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL enable_signal : STD_LOGIC;

    -- Flip-Flop Component
    COMPONENT enardFF_2
        PORT(
            i_resetBar : IN  STD_LOGIC;
            i_d        : IN  STD_LOGIC;
            i_enable   : IN  STD_LOGIC;
            i_clock    : IN  STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

    -- 2-to-1 Multiplexer Component
    COMPONENT mux2
        PORT(
            a, b, sel : IN  STD_LOGIC;
            y         : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- Enable signal is active when Load, Shift Right, or Shift Left is enabled
    enable_signal <= load OR shift_right OR shift_left;
    parallel_input <= input;
    
    -- Process to determine shift direction
    shift_logic: PROCESS(shift_right, shift_left, parallel_input, temp_q, serial_input)
    BEGIN
        FOR i IN 0 TO 7 LOOP
            IF shift_right = '1' THEN
                temp_mux(i) <= temp_q(i+1);
					 temp_mux(8) <= serial_input;
            END IF;
        END LOOP;
		  FOR i IN 1 TO 8 LOOP
            IF shift_left = '1' THEN
                temp_mux(i) <= temp_q(i-1);
 					 temp_mux(0) <= serial_input;
            END IF;
			END LOOP;
			FOR i IN 0 TO 0 LOOP
            IF load = '1' THEN
                temp_mux(i) <= parallel_input(i);
            END IF;
        END LOOP;
    END PROCESS;


    -- Flip-Flop Logic for 9-bit shift register
    GEN_DFF: FOR i IN 0 TO 8 GENERATE
        dff_inst: enardFF_2 PORT MAP(
            i_d        => temp_mux(i),
            i_clock    => clk,
            o_q        => temp_q(i),
            i_enable   => enable_signal,
            i_resetBar => '1'
        );
    END GENERATE;

    -- Output the least significant bit (LSB) and most significant bit (MSB)
    right_output <= input(0);
    left_output  <= input(8);

    -- Assign parallel output
    parallel_output <= temp_q;
    highest_8 <= temp_q(8 DOWNTO 1);
END Structural;