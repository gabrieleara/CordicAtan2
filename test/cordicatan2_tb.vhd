library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CORDICAtan2_TB is
end CORDICAtan2_TB;

architecture CORDICAtan2_TB_Arch of CORDICAtan2_TB is

	component CORDICAtan2 is
		port (
			clock		: in	std_ulogic;
			reset		: in	std_ulogic;
			inA			: in	std_ulogic_vector(12-1 downto 0);
			inB			: in	std_ulogic_vector(12-1 downto 0);
			valid		: out	std_ulogic;
			atan2Out	: out	std_ulogic_vector(12-1 downto 0)
		);
	end component;

	constant SIZE : positive := 12;

	signal test_inA		: std_ulogic_vector(SIZE-1 downto 0);
	signal test_inB		: std_ulogic_vector(SIZE-1 downto 0);
	
	signal test_reset	: std_ulogic := '1';
	signal test_clock	: std_ulogic := '0';
	signal test_end		: std_ulogic := '0';

begin

	cordicAtan2UnderTest : CORDICAtan2
		port map (
			clock		=> test_clock,
			reset		=> test_reset,
			inA			=> test_inA,
			inB			=> test_inB,
			valid		=> open,
			atan2Out	=> open
		);

	test_clock <= (not test_end) and (not test_clock) after 50ns;
	
	-- stimuli
	
	driveProcess : process
	begin
		wait for 50ns;
		
		test_reset <= '0';

		test_inA <= "000000000101";
		test_inB <= "000000000111";

		wait for 5000ns; 
		
		test_inA <= "000000000000";
		test_inB <= "000000000111";

		wait for 5000ns;
		
		test_inA <= "000000000000";
		test_inB <= "000000000000";

		wait for 5000ns;

		test_end <= '1';

		wait;
	end	process;
	
end CORDICAtan2_TB_Arch;