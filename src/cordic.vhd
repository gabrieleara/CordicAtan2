library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------------------------------------------------
-- CORDIC Algorithm
--
-- This component implements the CORDIC rotational algorithm for a vector of two
-- components A and B.
--
-- The reuslt is obtained connecting together accordignly two Single Dimension
-- Rotators.
--
--------------------------------------------------------------------------------

entity CORDIC is
	generic (
		size		: positive := 8;
		counterSize	: positive := 8
	);
	port (
		clock		: in	std_ulogic;
		reset		: in	std_ulogic;
		inA			: in	std_ulogic_vector(size-1 downto 0);
		inB			: in	std_ulogic_vector(size-1 downto 0);
		count		: in	std_ulogic_vector(counterSize-1 downto 0);
		msbB		: out	std_ulogic
	);
end CORDIC;

architecture CORDIC_Arch of CORDIC is
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
			inputData	: in	std_ulogic_vector(size-1 downto 0);
			otherData	: in	std_ulogic_vector(size-1 downto 0);
			actualData	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	signal msb			: std_ulogic;
	signal notMsb		: std_ulogic;
	signal actualA		: std_ulogic_vector(size-1 downto 0);
	signal actualB		: std_ulogic_vector(size-1 downto 0);
begin

	msb <= actualB(size-1);
	msbB <= msb;
	notMsb <= not actualB(size-1);

	-- The sign in input of rotatorA is the same as the MSB of B, so 1 for B < 0
	-- and 1 otherwise
	rotatorA: Rotator
		generic map (
			size		=> size,
			counterSize	=> counterSize
		)
		port map (
			clock		=> clock,
			reset		=> reset,
			sign		=> msb,
			count		=> count,
			inputData	=> inA,
			otherData	=> actualB,
			actualData	=> actualA
		);

	-- The sign in input of rotatorB is the negation of the MSB of B itself
	rotatorB: Rotator
		generic map (
			size		=> size,
			counterSize	=> counterSize
		)
		port map (
			clock		=> clock,
			reset		=> reset,
			sign		=> notMsb,
			count		=> count,
			inputData	=> inB,
			otherData	=> actualA,
			actualData	=> actualB
		);
end CORDIC_Arch;