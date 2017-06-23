library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Shift Selection Adjuster
--
-- This component defines a combinatoral logic that adjusts the select value of
-- the shifter inside the CORDIC component to satisfy the needs of the CORDIC
-- algorithm.
--
-- Basically, this component takes as input the current iteration of the CORDIC
-- algorithm and provides as output the number of bits that need to be shifted
-- in that iteration, that is equal to:
--
-- - count = 0
--             no shift is needed, the output is 0
-- - count > 0
--             the input word must be shifted of count-1 positions
--
--------------------------------------------------------------------------------

entity ShiftAdjuster is
	generic (
		size	: positive := 8
	);
	port (
		input	: in	std_ulogic_vector(size-1 downto 0);
		output	: out	std_ulogic_vector(size-1 downto 0)
	);
end ShiftAdjuster;

architecture ShiftAdjuster_Arch of ShiftAdjuster is
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

	signal subOutput : std_ulogic_vector(size-1 downto 0);
begin

	output <= (others => '0') when unsigned(input) = 0 else subOutput;

	-- The input value of the subtractor is -1 in two's complement, so the
	-- resulting operation in two's complement is count + (-1) = count-1
	subtractor : AdderSubtractor
		generic map (size => size)
		port map (
			inA			=> (others => '1'),
			inB			=> input,
			sumSub		=> '0',
			carryOut	=> open,
			value		=> subOutput
		);
end ShiftAdjuster_Arch;