--------------------------------------------------------------------------------
-- This file defines the type of a register with a generic size.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity GRegister is
	generic (size : positive := 8);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		data	: in	std_ulogic_vector(size-1 downto 0);
		value	: out	std_ulogic_vector(size-1 downto 0)
	);
end GRegister;

architecture GRegister_Arch of GRegister is
begin
	assignment: process(clock, reset)
	begin
		if reset = '1' then
			value <= (others => '0');
		elsif(clock'event and clock = '1') then
			value <= data;
		end if;
	end process;
end GRegister_Arch;