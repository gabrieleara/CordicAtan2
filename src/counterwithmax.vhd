library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Counter with a Maximum value
--
-- This component defines a variation of the Accumulator which can count only
-- by steps of 1 each time and that is automatically resetted when the internal
-- value reaches a maximum value.
--
-- Basically, the output of the Counter each clock is a value between 0 and
-- max-1.
--
--------------------------------------------------------------------------------

entity CounterWithMax is
	generic (
		size	: positive := 8;
		max		: positive := 16
	);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		value	: out	std_ulogic_vector(size-1 downto 0)
	);
end CounterWithMax;

architecture CounterWithMax_Arch of CounterWithMax is
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
	signal data			: std_ulogic_vector(size-1 downto 0);

	-- Wire used to loopback the output of the register into the input of the
	-- adder and to connect it to the output of the design
	signal cvalue		: std_ulogic_vector(size-1 downto 0);
	signal loopback		: std_ulogic_vector(size-1 downto 0);
	signal counterIn	: std_ulogic_vector(size-1 downto 0);

begin

	addsubInstance : AdderSubtractor
		generic map(size => size)
		port map (
			inA			=> counterIn,
			inB			=> loopback,
			sumSub		=> '0',
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

	-- The input of the Adder Subtractor is 1, unless the value has reached the
	-- maximum permitted value, in that case the input is 0
	counterIn <= std_ulogic_vector(to_unsigned(1, size))
				when ((max-1) > to_integer(unsigned(cvalue)))
				else std_ulogic_vector(to_unsigned(0, size));

	-- The loopback is the output value of the register, unless the value
	-- has reached the maximum permitted value
	loopback <= cvalue
				when ((max-1) > to_integer(unsigned(cvalue)))
				else (others => '0');

end CounterWithMax_Arch;