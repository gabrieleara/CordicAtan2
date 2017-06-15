library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Rotator is
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
		msb			: out	std_ulogic
	);
end Rotator;

architecture Rotator_Arch of Rotator is
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

	component ShiftAdjuster is
		generic (
			size	: positive := 8
		);
		port (
			input	: in	std_ulogic_vector(size-1 downto 0);
			output	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	signal zero			: std_ulogic;
	signal actualData	: std_ulogic_vector(size-1 downto 0);
	signal accData		: std_ulogic_vector(size-1 downto 0);
	signal shift		: std_ulogic_vector(counterSize-1 downto 0);

begin

	-- TODO: zero detector, for first loop, check in synthesis phase
	zero <= '1' when unsigned(count) = 0 else '0';
	
		
	actualData <= dataIn when zero = '0' else accData;

	msb <= actualData(size-1);

	adjusterInstance : ShiftAdjuster
		generic map (
			size	=> counterSize
		)
		port map (
			input	=> count,
			output	=> shift
		);

	accumulatorInstance: Accumulator
		generic map (size => size)
		port map(
			clock	=> clock,
			reset	=> reset,
			zero	=> zero,
			inA		=> otherData,
			sumSub	=> sign,
			value	=> accData
		);

	shifter: ArithmeticShifter
		generic map (
			size		=> size,
			shiftSize	=> counterSize
		)
		port map (
			shift		=> shift,
			input		=> actualData,
			output		=> shiftedOut
		);

end Rotator_Arch;