library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RotatorB_TB is
end RotatorB_TB;

architecture RotatorB_TB_Arch of RotatorB_TB is

	component Rotator is
		generic (
			size		: positive := 8;
			counterSize	: positive := 8
		);
		port (
			clock		: in	std_ulogic;
			reset		: in	std_ulogic;
			sign		: in	std_ulogic;
			count		: in	std_ulogic_vector(counterSize-1 downto 0);
			dataIn		: in	std_ulogic_vector(size-1 downto 0);
			otherData	: in	std_ulogic_vector(size-1 downto 0);
			shiftedOut	: out	std_ulogic_vector(size-1 downto 0);
			zeroOut		: out	std_ulogic;
			msb			: out	std_ulogic
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


	constant SIZE			: positive := 14;
	constant COUNTER_SIZE	: positive := 4;
	constant LUT_SIZE		: positive := 11;

	signal test_inB			: std_ulogic_vector(SIZE-1 downto 0);
	signal test_shiftedB	: std_ulogic_vector(SIZE-1 downto 0);
	signal test_shiftedA	: std_ulogic_vector(SIZE-1 downto 0);
	signal test_msbB		: std_ulogic;
	signal test_notMsbB		: std_ulogic;

	signal test_reset	: std_ulogic := '1';
	signal test_clock	: std_ulogic := '0';
	signal test_end		: std_ulogic := '0';

	signal test_count	: std_ulogic_vector(COUNTER_SIZE-1 downto 0);
	signal counterIn	: std_ulogic_vector(COUNTER_SIZE-1 downto 0);
	signal zeroCounter	: std_ulogic;


begin

	counter : Accumulator
		generic map (size => COUNTER_SIZE)
		port map (
			clock	=> test_clock,
			reset	=> test_reset,
			zero	=> zeroCounter,
			inA		=> counterIn,
			sumSub	=> '0',
			value	=> test_count
		);

	zeroCounter <= '1' when (unsigned(test_count) = LUT_SIZE-1) else '0';
	counterIn <= std_ulogic_vector(to_unsigned(1, COUNTER_SIZE))
					when zeroCounter = '0'
					else std_ulogic_vector(to_unsigned(0, COUNTER_SIZE));

	test_notMsbB <= not test_shiftedB(SIZE-1);

	rotatorUnderTest : Rotator
		generic map (
			size		=> SIZE,
			counterSize	=> COUNTER_SIZE
		)
		port map (
			clock		=> test_clock,
			reset		=> test_reset,
			sign		=> test_notMsbB,
			count		=> test_count,
			dataIn		=> test_inB,
			otherData	=> test_shiftedA,
			shiftedOut	=> test_shiftedB,
			zeroOut		=> open,
			msb			=> test_msbB
		);

	test_clock <= (not test_end) and (not test_clock) after 50ns;
	
	-- stimuli
	
	driveProcess : process
	begin
		wait for 50ns;
		
		test_reset <= '0';

		test_inB <= "00000000000111";
		test_shiftedA <= "00000000000010";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000111";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000100";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000010";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000001";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_shiftedA <= "00000000000000";

		wait for 50ns;
		wait for 50ns;

		test_end <= '1';

		wait;
	end	process;
	
end RotatorB_TB_Arch;