library IEEE;
use IEEE.std_logic_1164.all;

entity Accumulator is
	generic (size : positive := 8);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		zero	: in	std_ulogic; -- synchronous reset of the accumulated value
		inA		: in	std_ulogic_vector(size-1 downto 0);
		sumSub	: in	std_ulogic;
		value	: out	std_ulogic_vector(size-1 downto 0)
	);
end Accumulator;

architecture Accumulator_Arch of Accumulator is
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

	component GRegister
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			data	: in	std_ulogic_vector(size-1 downto 0);
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component GRegister;

	-- Wire between the output of the adder and the input of the register
	signal data		: std_ulogic_vector(size-1 downto 0);

	-- Wire used to loopback the output of the register into the input of the
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

	registerInstance : GRegister
		generic map(size => size)
		port map (
			clock	=> clock,
			reset	=> reset,
			data	=> data,
			value	=> cvalue
		);

	-- The output is the output value of the register
	value <= cvalue;

	-- The loopback is the output value of the register, unless the synchronous
	-- reset "zero" is set to 1
	loopback <= cvalue when zero == '0' else (others => '0');

end Accumulator_Arch;