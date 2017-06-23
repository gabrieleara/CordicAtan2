library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Accumulator with Enable signal
--
-- This component defines a variation of the Accumulator which uses a Generic
-- Register with Enable as memory.
--
-- Its behavior is the same of the Accumulator, as long as the enable signal is
-- high. When the enable signal is low, the Accumulator behaves in the same way
-- of a Generic Register with Enable, ignoring any input from outside.
--
--------------------------------------------------------------------------------

entity AccumulatorEn is
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
end AccumulatorEn;

architecture AccumulatorEn_Arch of AccumulatorEn is
	component AdderSubtractor is
		generic (size : positive := 8);
		port (
			inA			: in	std_ulogic_vector(size-1 downto 0);
			inB			: in	std_ulogic_vector(size-1 downto 0);
			sumSub		: in	std_ulogic;
			carryOut	: out	std_ulogic;
			value		: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	component GRegisterEn
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			enable	: in	std_ulogic;
			data	: in	std_ulogic_vector(size-1 downto 0);
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component GRegisterEn;

	-- Wire between the output of the adder and the input of the register
	signal data		: std_ulogic_vector(size-1 downto 0);

	-- Wires used to loopback the output of the register into the input of the
	-- adder and to connect it to the output of the design
	signal cvalue	: std_ulogic_vector(size-1 downto 0);
	signal loopback	: std_ulogic_vector(size-1 downto 0);

begin

	addsubInstance : AdderSubtractor
		generic map(size => size)
		port map (
			inA			=> inA,
			inB			=> loopback,
			sumSub		=> sumSub,
			carryOut	=> open,
			value		=> data
		);

	registerInstance : GRegisterEn
		generic map(size => size)
		port map (
			clock	=> clock,
			reset	=> reset,
			enable	=> enable,
			data	=> data,
			value	=> cvalue
		);

	-- The output is the output value of the register
	value <= cvalue;

	-- The loopback is the output value of the register, unless the synchronous
	-- reset "zero" is set to 1
	loopback <= cvalue when zero = '0' else (others => '0');

end AccumulatorEn_Arch;