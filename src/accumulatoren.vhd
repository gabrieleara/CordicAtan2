library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Accumulator with Enable signal
--
-- This component defines a variation of the Accumulator which uses a Generic
-- Register with Enable as memory.
--
-- Its behavior depends on both the values of the zero and the enable signals;
-- the exact behavior of the component is the following:

-- +---------------------------------------------------------------------------+
-- |    Zero    |   Enable   |                    Behavior                     |
-- +============+============+=================================================+
-- |     0      |     1      | The same exact behavior of the Accumulator      |
-- +------------+------------+-------------------------------------------------+
-- |     1      |     1      | The same exact behavior of the Accumulator      |
-- +------------+------------+-------------------------------------------------+
-- |     0      |     0      | The component becomes insensitive to the input  |
-- |            |            | values, like the Register with Enable signal    |
-- +------------+------------+-------------------------------------------------+
-- |     1      |     0      | The component stored value becomes zero, for    |
-- |            |            | whatever input value is provided                |
-- +------------+------------+-------------------------------------------------+
--
--------------------------------------------------------------------------------

entity AccumulatorEn is
	generic (size : positive := 8);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		zero	: in	std_ulogic;
		enable	: in	std_ulogic;
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
	signal cvalue		: std_ulogic_vector(size-1 downto 0);
	signal loopback		: std_ulogic_vector(size-1 downto 0);

	-- Wires used to ensure the behavior of the component described in the table
	signal actualA		: std_ulogic_vector(size-1 downto 0);
	signal actualEnable	: std_ulogic;

begin

	addsubInstance : AdderSubtractor
		generic map(size => size)
		port map (
			inA			=> actualA,
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
			enable	=> actualEnable,
			data	=> data,
			value	=> cvalue
		);

	-- The output is the output value of the register
	value <= cvalue;

	-- The loopback is the output value of the register, unless the synchronous
	-- reset "zero" is set to 1
	loopback <= cvalue when zero = '0' else (others => '0');

	actualA <= (others => '0') when zero = '1' and enable = '0' else inA;
	actualEnable <= enable when zero = '0' else '1';

end AccumulatorEn_Arch;