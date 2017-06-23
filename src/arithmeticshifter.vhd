library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Arithmetic Shifter
--
-- This component defines a combinatoral logic that executes the Arithmetic
-- Shift operation of the input word.
--
--------------------------------------------------------------------------------


entity ArithmeticShifter is
	generic (
		size		: positive := 8;
		shiftSize	: positive := 3
	);
	port (
		shift	: in	std_ulogic_vector(shiftSize-1 downto 0);
		input	: in	std_ulogic_vector(size-1 downto 0);
		output	: out	std_ulogic_vector(size-1 downto 0)
	);
end ArithmeticShifter;

architecture ArithmeticShifter_Arch of ArithmeticShifter is
	component MuxWithOffset is
		generic (
			size	: positive	:= 8;
			selSize : positive	:= 3;
			offset	: natural	:= 0
			);
		port (
			sel		: in	std_ulogic_vector(selSize-1 downto 0);
			input	: in	std_ulogic_vector(size-1 downto 0);
			output	: out	std_ulogic
		);
	end component;
begin

	-- Each Multiplexer with Offset used inside is used to select the proper
	-- value for the output bit in the position equal to the given offset
	generateMuxes: for i in 0 to size-1 generate
		mux: MuxWithOffset
			generic map (
				size		=> size,
				selSize		=> shiftSize,
				offset		=> i
				)
			port map (
				sel			=> shift,
				input		=> input,
				output		=> output(i)
			);
	end generate generateMuxes;

end ArithmeticShifter_Arch;