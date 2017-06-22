------------------------------------------------------------------------------------
-- This file defines the type of a register with a generic size and an enable signal
------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity GRegisterEn is
	generic (size : positive := 8);
	port (
		clock	: in	std_ulogic;
		reset	: in	std_ulogic;
		enable	: in	std_ulogic;
		data	: in	std_ulogic_vector(size-1 downto 0);
		value	: out	std_ulogic_vector(size-1 downto 0)
	);
end GRegisterEn;

architecture GRegisterEn_Arch of GRegisterEn is

	-- Data to/from multiplexer
	signal dataMuxIn : std_ulogic_vector(size-1 downto 0);
	signal dataMuxOut : std_ulogic_vector(size-1 downto 0);

begin
	assignment: process(clock, reset)
	begin
		if reset = '1' then
			dataMuxIn <= (others => '0');
		elsif(clock'event and clock = '1') then
			dataMuxIn <= dataMuxOut;
		end if;
	end process;

	dataMuxOut <= data when enable = '1' else dataMuxIn;
	value <= dataMuxOut;

end GRegisterEn_Arch;