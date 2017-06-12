library IEEE;
use IEEE.std_logic_1164.all;

entity Counter is
	generic (size : positive := 8);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		inA		: in	std_ulogic_vector(size-1 downto 0);
		value	: out	std_ulogic_vector(size-1 downto 0)
	);
end Counter;

architecture Counter_Arch of Counter is
	component RippleCarryAdder
		generic (size : positive := 8);
		port (
			inA			: in	std_ulogic_vector(size-1 downto 0);
			inB			: in	std_ulogic_vector(size-1 downto 0);
			carryIn		: in	std_ulogic;
			carryOut	: out	std_ulogic;
			sum			: out	std_ulogic_vector(size-1 downto 0)
		);
	end component RippleCarryAdder;

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
	signal loopback	: std_ulogic_vector(size-1 downto 0);

begin

	rcaInstance : RippleCarryAdder
		generic map(size => size)
		port map (
			inA			=> inA,
			inB			=> loopback,
			carryIn		=> '0',
			carryOut	=> open,
			sum			=> data
		);

	registerInstance : GRegister
		generic map(size => size)
		port map (
			data	=> data,
			clock	=> clock,
			value	=> loopback,
			reset	=> reset
		);

	-- The output is the value in the loopback wire
	value <= loopback;

end Counter_Arch;