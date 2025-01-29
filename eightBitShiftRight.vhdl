library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--============================================================
-- Entity Declaration
--============================================================
entity eightBitShiftRight is
  port(
    clk          : in  std_logic;
    reset_bar    : in  std_logic;
    load         : in  std_logic;
    shift        : in  std_logic;
    shift_value  : in  std_logic;
    i_Value      : in  std_logic_vector(7 downto 0);
    o_Value      : out std_logic_vector(7 downto 0)
  );
end entity eightBitShiftRight;

--============================================================
-- Architecture
--============================================================
architecture structural of eightBitShiftRight is

  -- Internal register to store output data.
  signal r_Value       : std_logic_vector(7 downto 0);
  signal next_val      : std_logic_vector(7 downto 0);
  signal shift_mux_out : std_logic_vector(7 downto 0);

begin

  -- Drive the entity's out port from the internal register
  o_Value <= r_Value;

  --==========================================================
  -- SHIFT_MUX_OUT ASSIGNMENTS
  --==========================================================
  -- Bits 0 to 6: shift_mux_out(i) <= r_Value(i+1)
  GEN_BITS_0_TO_6: for i in 0 to 6 generate
  begin
    shift_mux_out(i) <= r_Value(i + 1);
  end generate GEN_BITS_0_TO_6;

  -- Bit 7: shift_mux_out(7) <= shift_value
  shift_mux_out(7) <= shift_value;

  --==========================================================
  -- Generate loop for multiplexing load vs. shift data,
  -- and then registering it.
  --==========================================================
  GEN_BITS: for i in 0 to 7 generate

    -- 2-to-1 mux: choose between shifted value or load input
    LOAD_MUX: entity work.mux2
      port map(
        sel   => load,
        in0   => shift_mux_out(i),
        in1   => i_Value(i),
        outy  => next_val(i)
      );

    -- Flip-flop with enable for shifting/loading
    BIT_FF: entity work.enardFF_2
      port map(
        i_resetBar => reset_bar,
        i_d        => next_val(i),
        i_enable   => (shift or load),
        i_clock    => clk,
        o_q        => r_Value(i),
        o_qBar     => open
      );
  end generate GEN_BITS;

end architecture structural;
