library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ArithmeticShifter_TB is
end ArithmeticShifter_TB;

architecture ArithmeticShifter_TB_Arch of ArithmeticShifter_TB is

	constant SIZE		: positive := 12;
	constant SHIFT_SIZE	: positive := 4;

	component ArithmeticShifter is
		generic (
			size		: positive := 8;
			shiftSize	: positive := 3
		);
		port (
			shift	: in	std_ulogic_vector(shiftSize-1 downto 0);
			input	: in	std_ulogic_vector(size-1 downto 0);
			output	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;
	
	signal test_in		: std_ulogic_vector(SIZE-1 downto 0);
	signal test_shift	: std_ulogic_vector(SHIFT_SIZE-1 downto 0);
	
	signal test_clock	: std_ulogic := '0';
	signal test_end		: std_ulogic := '0';
begin

	shifterUnderTest : ArithmeticShifter
		generic map (
			size		=> SIZE,
			shiftSize	=> SHIFT_SIZE
		)
		port map (
			shift		=> test_shift,
			input		=> test_in,
			output		=> open
		);

	test_clock <= (not test_end) and (not test_clock) after 50ns;
	
	-- stimuli
	
	driveProcess : process
	begin
		for i in 0 to (2**SIZE-1) loop
			test_in <= std_ulogic_vector(to_signed(i, SIZE));

			for j in 0 to (2**SHIFT_SIZE-1) loop
				test_shift <= std_ulogic_vector(to_unsigned(j, SHIFT_SIZE));

				wait until rising_edge(test_clock);
			end loop;
		end loop;

		test_end <= '1';

		wait;
	end	process;
	
end ArithmeticShifter_TB_Arch;