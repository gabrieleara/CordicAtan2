library IEEE;
use IEEE.std_logic_1164.all;

-- Performs A + B or B - A, depending respectively if the input sumSub is 0 or 1
entity AdderSubtractor is
	generic (size : positive := 8);
	port (
		inA			: in	std_ulogic_vector(size-1 downto 0);
		inB			: in	std_ulogic_vector(size-1 downto 0);
		sumSub		: in	std_ulogic;
		carryOut	: out	std_ulogic;
		value		: out	std_ulogic_vector(size-1 downto 0)
	);
end AdderSubtractor;

architecture AdderSubtractor_Arch of AdderSubtractor is

	component FullAdder
		port (
			inA			: in	std_ulogic;
			inB			: in	std_ulogic;
			carryIn		: in	std_ulogic;
			carryOut	: out	std_ulogic;
			sum			: out	std_ulogic
		);
	end component FullAdder;

	signal carryWires	: std_ulogic_vector(size-2 downto 0);
	signal actualInA	: std_ulogic_vector(size-1 downto 0);

begin

	-- When sumSub = 0 then the component performs A+B, otherwise it performs
	-- B-A
	actualInA = inA when sumSub == '0' else not(inA);

	generateFullAdders: for i in 0 to size-1 generate

		-- First adder has carryIn connected to the sumSub of the design, in
		-- order to add 1 to perform the 2-complement on A when B-A operation is
		-- needed
		first: if i = 0 generate
				fullAdderFirst: FullAdder
					port map (
						inA			=> actualInA(i),
						inB			=> inB(i),
						carryIn		=> sumSub,
						carryOut	=> carryWires(i),
						sum			=> value(i)
					);
			end generate first;

		-- Internal adders have carries connected in chain
		internal: if i > 0 and i < size-1 generate
				fullAdderInternal: FullAdder
					port map (
						inA			=> actualInA(i),
						inB			=> inB(i),
						carryIn		=> carryWires(i-1),
						carryOut	=> carryWires(i),
						sum			=> value(i)
					);
			end generate internal;

		-- Last adder has carryOut connected to the carryOut of the design
		last: if i = size-1 generate
				fullAdderLast: FullAdder
					port map (
						inA			=> actualInA(i),
						inB			=> inB(i),
						carryIn		=> carryWires(i-1),
						carryOut	=> carryOut,
						sum			=> value(i)
					);
			end generate last;
	end generate generateFullAdders;
end AdderSubtractor_Arch;