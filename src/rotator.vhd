library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--------------------------------------------------------------------------------
-- Single Dimension Rotator
--
-- This component performs the rotations needed by the CORDIC algorithm on one
-- of the dimensions of the input vector.
--
-- Each iteration, the component updates its value depending on the output of
-- another Single Dimension Rotator and its currently stored value, as required
-- by the CORDIC algorithm.
--
-- See the algorithm description for further information.
--
-- The sign input specifies if the given value has to be summed or subtracted to
-- the currently stored value.
--
-- The output value of the rotator is its currently stored value, the other
-- Rotator will shift this value by the amount of bits required by the CORDIC
-- algorithm at the current iteration.
--
-- The inputData signal has a meaning only at the first iteration and then it is
-- ignored for the following ones.
--
--------------------------------------------------------------------------------

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
		inputData	: in	std_ulogic_vector(size-1 downto 0);
		otherData	: in	std_ulogic_vector(size-1 downto 0);
		actualData	: out	std_ulogic_vector(size-1 downto 0)
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
	signal shiftedOut	: std_ulogic_vector(size-1 downto 0);
	signal storedData	: std_ulogic_vector(size-1 downto 0);
	signal shift		: std_ulogic_vector(counterSize-1 downto 0);

begin

	zero <= '1' when unsigned(count) = 0 else '0';

	actualData <= inputData when zero = '1' else storedData;

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
		port map (
			clock	=> clock,
			reset	=> reset,
			zero	=> zero,
			inA		=> shiftedOut,
			sumSub	=> sign,
			value	=> storedData
		);

	shifter: ArithmeticShifter
		generic map (
			size		=> size,
			shiftSize	=> counterSize
		)
		port map (
			shift		=> shift,
			input		=> otherData,
			output		=> shiftedOut
		);

end Rotator_Arch;