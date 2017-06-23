library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Generic Register with Enable signal
--
-- This component defines a register of a generic size which can be enabled or
-- disabled using a special input:
--
-- - when the enable input is high, the register acts like a normal Generic
--   Register.
--
-- - when the enable input is low, the register enters a holding state and it is
--   unsensitive to its input data.
--
--------------------------------------------------------------------------------

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

	-- The sensitivity of the register is regulated using a multiplexer, the
	-- inputs of the multiplexer are the data from outside and the value
	-- contained in the register. When the enable signal is zero, the loopback
	-- value is sampled again, hence the value of the register does not change.
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
	value <= dataMuxIn;

end GRegisterEn_Arch;