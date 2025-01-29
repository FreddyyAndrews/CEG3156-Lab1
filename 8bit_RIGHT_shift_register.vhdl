library ieee;
use ieee.std_logic_1164.all;

entity eight_bit_right_shift_register is
    PORT (
        parralel_input : in std_logic_vector(7 downto 0);
        load : in std_logic;
        serial_input : in std_logic;
        shift_right : in std_logic;
        clk: in std_logic;
        right_output : out std_logic);
end eight_bit_right_shift_register;

architecture Structural of eight_bit_right_shift_register is
    signal temp_q, temp_mux : std_logic_vector(7 downto 0);
    signal enable_signal : std_logic;
    component enardFF_2
        PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
    end component;

    component two_to_one_mux
        port(
            a, b, sel : in std_logic;
            y : out std_logic
        );
    end component;

begin

    enable_signal <= load or shift_right;
    mux0: two_to_one_mux port map(
        a => parralel_input(0),
        b => temp_q(1),
        sel => shift_right,
        y => temp_mux(0)
    );

    mux1: two_to_one_mux port map(
        a => parralel_input(1),
        b => temp_q(2),
        sel => shift_right,
        y => temp_mux(1)
    );

    mux2: two_to_one_mux port map(
        a => parralel_input(2),
        b => temp_q(3),
        sel => shift_right,
        y => temp_mux(2)
    );

    mux3: two_to_one_mux port map(
        a => parralel_input(3),
        b => temp_q(4),
        sel => shift_right,
        y => temp_mux(3)
    );

    mux4: two_to_one_mux port map(
        a => parralel_input(4),
        b => temp_q(5),
        sel => shift_right,
        y => temp_mux(4)
    );

    mux5: two_to_one_mux port map(
        a => parralel_input(5),
        b => temp_q(6),
        sel => shift_right,
        y => temp_mux(5)
    );

    mux6: two_to_one_mux port map(
        a => parralel_input(6),
        b => temp_q(7),
        sel => shift_right,
        y => temp_mux(6)
    );

    mux7: two_to_one_mux port map(
        a => parralel_input(7),
        b => serial_input,
        sel => shift_right,
        y => temp_mux(7)
    );

    dff0: enardFF_2 port map(
        i_d => temp_mux(0),
        i_clock => clk,
        o_q => temp_q(0),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff1: enardFF_2 port map(
        i_d => temp_mux(1),
        i_clock => clk,
        o_q => temp_q(1),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff2: enardFF_2 port map(
        i_d => temp_mux(2),
        i_clock => clk,
        o_q => temp_q(2),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff3: enardFF_2 port map(
        i_d => temp_mux(3),
        i_clock => clk,
        o_q => temp_q(3),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff4: enardFF_2 port map(
        i_d => temp_mux(4),
        i_clock => clk,
        o_q => temp_q(4),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff5: enardFF_2 port map(
        i_d => temp_mux(5),
        i_clock => clk,
        o_q => temp_q(5),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff6: enardFF_2 port map(
        i_d => temp_mux(6),
        i_clock => clk,
        o_q => temp_q(6),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    dff7: enardFF_2 port map(
        i_d => temp_mux(7),
        i_clock => clk,
        o_q => temp_q(7),
        i_enable => enable_signal,
        i_resetBar => '1'
    );

    right_output <= temp_q(0);

end Structural;