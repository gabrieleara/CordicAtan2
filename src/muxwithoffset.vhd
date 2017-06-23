library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Multiplexer with static Offset
--
-- This component defines a combinatoral logic that is equivalent to a
-- multiplexer, but the multiplexer selector has a fixed offset value.
--
-- This means that when the sel input is zero, the bit in the output is the one
-- in the position corresponding with the offset value. If the sel is 1, the
-- output is the one in the position next to the offset value one and so on.
--
-- When the requested bit position is not possible, the most significant bit of
-- the input word is provided as output.
--
-- This component has a proper meaning only when used to generate an Arithmetic
-- Shifter, so please see its usage in the Arithmetic Shifter architecture.
--
--------------------------------------------------------------------------------

entity MuxWithOffset is
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
end MuxWithOffset;

architecture MuxWithOffset_Arch of MuxWithOffset is
begin

	selection: process(input, sel)
		variable selValue : natural := 0;
	begin
		-- The actual select value of the Multiplexer is the sum between the
		-- input sel and the fixed offset
		selValue := to_integer(
						resize(unsigned(sel), selSize+1) +
						to_unsigned(offset, selSize+1)
					);

		-- If the position excedes the input word length, the msb is provided as
		-- output
		if (selValue > size-1) then
			selValue := size-1;
		end if;

		output <= input(selValue);

	end process selection;

end MuxWithOffset_Arch;