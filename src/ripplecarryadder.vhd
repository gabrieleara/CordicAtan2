library IEEE;
use IEEE.std_logic_1164.all;

entity RippleCarryAdder is
	generic (size : positive := 8);
	port (
		inA			: in	std_ulogic_vector(size-1 downto 0);
		inB			: in	std_ulogic_vector(size-1 downto 0);
		carryIn		: in	std_ulogic;
		carryOut	: out	std_ulogic;
		sum			: out	std_ulogic_vector(size-1 downto 0)
	);
end RippleCarryAdder;

architecture RippleCarryAdder_Arch of RippleCarryAdder is

	component FullAdder
		port (
			inA			: in	std_ulogic;
			inB			: in	std_ulogic;
			carryIn		: in	std_ulogic;
			carryOut	: out	std_ulogic;
			sum			: out	std_ulogic
		);
	end component FullAdder;

	signal carryWires : std_ulogic_vector(size-2 downto 0);

begin

	generateFullAdders: for i in 0 to size-1 generate

		-- First adder has carryIn connected to the carryIn of the design
		first: if i = 0 generate
				fullAdderFirst: FullAdder
					port map (
						inA			=> inA(i),
						inB			=> inB(i),
						carryIn		=> carryIn,
						carryOut	=> carryWires(i),
						sum			=> sum(i)
					);
			end generate first;

		-- Internal adders have carries connected in chain
		internal: if i > 0 and i < size-1 generate
				fullAdderInternal: FullAdder
					port map (
						inA			=> inA(i),
						inB			=> inB(i),
						carryIn		=> carryWires(i-1),
						carryOut	=> carryWires(i),
						sum			=> sum(i)
					);
			end generate internal;

		-- Last adder has carryOut connected to the carryOut of the design
		last: if i = size-1 generate
				fullAdderLast: FullAdder
					port map (
						inA			=> inA(i),
						inB			=> inB(i),
						carryIn		=> carryWires(i-1),
						carryOut	=> carryOut,
						sum			=> sum(i)
					);
			end generate last;
	end generate generateFullAdders;
end RippleCarryAdder_Arch;