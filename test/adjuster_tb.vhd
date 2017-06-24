library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftAdjuster_TB is
end ShiftAdjuster_TB;

architecture ShiftAdjuster_TB_Arch of ShiftAdjuster_TB is

	constant SHIFT_SIZE	: positive := 4;

	component ShiftAdjuster is
		generic (
			size	: positive := 8
		);
		port (
			input	: in	std_ulogic_vector(size-1 downto 0);
			output	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	component Accumulator is
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			zero	: in	std_ulogic; -- synchronous reset of the accumulated value
			inA		: in	std_ulogic_vector(size-1 downto 0);
			sumSub	: in	std_ulogic;
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;
	
	signal test_in		: std_ulogic_vector(SHIFT_SIZE-1 downto 0);
	signal test_shift	: std_ulogic_vector(SHIFT_SIZE-1 downto 0);
	
	signal test_reset	: std_ulogic := '1';
	signal test_clock	: std_ulogic := '0';
	signal test_end		: std_ulogic := '0';
begin

	adjusterUnderTest: ShiftAdjuster
		generic map (size => SHIFT_SIZE)
		port map (
			input	=> test_in,
			output	=> test_shift
		);

	counter : Accumulator
		generic map (size => SHIFT_SIZE)
		port map (
			clock	=> test_clock,
			reset	=> test_reset,
			zero	=> '0',
			inA		=> std_ulogic_vector(to_unsigned(1, SHIFT_SIZE)),
			sumSub	=> '0',
			value	=> test_in
		);

	test_clock <= (not test_end) and (not test_clock) after 50ns;
	
	-- stimuli
	
	driveProcess : process
	begin
		wait for 50ns;
		
		test_reset <= '0';

		wait for 5000ns;

		test_end <= '1';

		wait;
	end	process;
	
end ShiftAdjuster_TB_Arch;