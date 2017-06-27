library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Special Case Detector
--
-- This component checks for the special cases specified by the CORDICAtan2
-- algorithm and pilots the Atan2 component via the enable signal.
--
-- The basic idea behind this component is that there are two special cases:
--
-- - A = 0, B <> 0
--                 in this case, the result of the algorithm must be either pi/2
--                 if B > 0 and -pi/2 otherwise; this result is obtained making
--                 Atan2 component run only for the first iteration and then go 
--                 idle after, until a new input is provided.
--
-- - A = 0, B = 0
--                 in this case, the result of the algorithm must be 0 by
--                 convention, so the Atan2 component must not consider any
--                 value coming from the LUT that it has inside, until a new
--                 input is provided.
--------------------------------------------------------------------------------

entity SpecialCase is
	generic (
		size		: positive := 8;
		counterSize	: positive := 8
	);
	port (
		clock		: in	std_ulogic;
		reset		: in	std_ulogic;
		count		: in	std_ulogic_vector(counterSize-1 downto 0);
		inA			: in	std_ulogic_vector(size-1 downto 0);
		inB			: in	std_ulogic_vector(size-1 downto 0);
		enable		: out	std_ulogic
	);
end SpecialCase;

architecture SpecialCase_Arch of SpecialCase is
	component GRegisterEn is
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			enable	: in	std_ulogic;
			data	: in	std_ulogic_vector(size-1 downto 0);
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	signal zero			: std_ulogic;
	signal enableReg	: std_ulogic;

	signal isZero		: std_ulogic;

	signal isZeroA		: std_ulogic_vector(0 downto 0);
	signal isZeroB		: std_ulogic;

	signal isZeroAHold	: std_ulogic_vector(0 downto 0);

begin

	-- The register inside this component is active only at the first iteration
	-- and for the following ones it will hold its value in order to enable or
	-- not the Atan2 component.
	zero <= '1' when unsigned(count) = 0 else '0';
	isZeroA <= "1" when unsigned(inA) = 0 else "0";
	isZeroB <= '1' when unsigned(inB) = 0 else '0';

	isZero <= isZeroA(0) and isZeroB;

	isZeroAReg: GRegisterEn
		generic map (size => 1)
		port map (
			clock	=> clock,
			reset	=> reset,
			enable	=> zero,
			data	=> isZeroA,
			value	=> isZeroAHold
		);

	-- At the first iteration, the regster is bypassed and if the two input
	-- values are both zero the Atan2 component is disabled; then we are only
	-- interested if the input A was zero or not at the first iteration
	enable <= not isZero when zero = '1'
				else not isZeroAHold(0);

end SpecialCase_Arch;