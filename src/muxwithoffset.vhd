library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
		selValue := to_integer(resize(unsigned(sel), selSize+1) + to_unsigned(offset, selSize+1));

		if (selValue > size-1) then
			selValue := size-1;
		end if;

		output <= input(selValue);

	end process selection;

end MuxWithOffset_Arch;