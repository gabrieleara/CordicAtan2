library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Adder Subtractor
--
-- This component defines a combinatoral logic that is able to perform basic
-- sums, subtractions and change of sign in two's complement between numbers
-- expressed with a generic number of bits.
--
-- The sumSub input is responsible to decide whether the output of the component
-- will be the sum A+B or the subtractions B-A of the two inputs:
--
-- - sumSub = 0 then the output is A+B
--
-- - sumSub = 1 then the output is B-A
--
-- To perform the inverse of a single number, the number must be put in the A
-- input and the B input must be zero, so basically the output is 0-A.
--
--------------------------------------------------------------------------------

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

	-- To perform subtractions, the input A must be converted in its inverse in
	-- two's complement and then added to the input B; to do so, we first
	-- calculate the one's complement of A
	actualInA <= inA when sumSub = '0' else not(inA);

	-- The Adder inside is obtained chaining together Full Adders, in a Ripple
	-- Carry Adder configuration
	generateFullAdders: for i in 0 to size-1 generate

		-- The first Full Adder has carryIn connected to the sumSub of the
		-- design, in order to add 1 to perform the two's complement on A when
		-- B-A operation is requested
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

		-- Internal Full Adders have carries connected in chain
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

		--The last Full Adder has carryOut connected to the carryOut of the
		-- design
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