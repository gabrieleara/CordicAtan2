library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Atan2 calculator
--
-- This component takes as input the iteration count of the CORDIC algorithm and
-- the sign (so the msb) of the B operand of the CORDIC algorithm and calculates
-- the corresponding Atan2 value by repeatedly summing known Atan2 values,
-- contained in a look up table (LUT).
--
-- The validity of the output is specified using an additional signal; the idea
-- behind this is that the output of the component is valid for only one clock
-- cycle, at the end of all the needed CORDIC iterations.
--
--------------------------------------------------------------------------------

entity Atan2 is
	port (
		clock		: in	std_ulogic;
		reset		: in	std_ulogic;
		msbB		: in	std_ulogic;
		enable		: in	std_ulogic;
		count		: in	std_ulogic_vector(4-1 downto 0);
		valid		: out	std_ulogic;
		atan2Out	: out	std_ulogic_vector(12-1 downto 0)
	);
end Atan2;

architecture Atan2_Arch of Atan2 is

	-- Due to lut generation and other factors, this component is not generic,
	-- hence it can be used only if the CORDIC component matches these constants
	constant SIZE			: positive := 12;
	constant COUNTER_SIZE	: positive := 4;
	constant LUT_SIZE		: positive := 11;

	type bin_array is array (natural range <>) of std_ulogic_vector(SIZE-1 downto 0);
	constant lut : bin_array := ("001100100100","000110010010","000011101101","000001111101","000001000000","000000100000","000000010000","000000001000","000000000100","000000000010","000000000001");

	component AccumulatorEn is
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			zero	: in	std_ulogic; -- synchronous reset of the accumulated value
			enable	: in	std_ulogic; -- register enable
			inA		: in	std_ulogic_vector(size-1 downto 0);
			sumSub	: in	std_ulogic;
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	signal atanFromLut		: std_ulogic_vector(SIZE-1 downto 0);
	signal zero				: std_ulogic;
begin

	zero <= '1' when unsigned(count) = 0 else '0';
	atanFromLut <= lut(to_integer(unsigned(count)));
	valid <= zero;

	-- TODO: correct this error, the zero is ignored when enable is low. This is
	-- indeed the correct behavior of the AccumulatorEn, but not what we wanted
	-- to use actually, we want that when zero is high and enable is low the
	-- value of the accumulator becomes zero.
	--
	-- Since the AccumulatorEn is used only here, change the behavior of the
	-- AccumulatorEn to match the required behavior
	atanAccumulator : AccumulatorEn
		generic map (size => SIZE)
		port map (
			clock	=> clock,
			reset	=> reset,
			zero	=> zero,
			enable	=> enable,
			inA		=> atanFromLut,
			sumSub	=> msbB,
			value	=> atan2Out
		);
end Atan2_Arch;