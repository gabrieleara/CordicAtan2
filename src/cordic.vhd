library IEEE;
use IEEE.std_logic_1164.all;

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
		zeroA		: out	std_ulogic;
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
			dataIn		: in	std_ulogic_vector(size-1 downto 0);
			otherData	: in	std_ulogic_vector(size-1 downto 0);
			shiftedOut	: out	std_ulogic_vector(size-1 downto 0);
			zeroOut		: out	std_ulogic;
			msb			: out	std_ulogic
		);
	end component;

	signal msb			: std_ulogic;
	signal notMsb		: std_ulogic;
	signal shiftedA		: std_ulogic_vector(size-1 downto 0);
	signal shiftedB		: std_ulogic_vector(size-1 downto 0);
begin

	msbB <= msb;
	notMsb <= not msb;

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
			dataIn		=> inA,
			otherData	=> shiftedB,
			shiftedOut	=> shiftedA,
			zeroOut		=> zeroA,
			msb			=> open
		);


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
			dataIn		=> inB,
			otherData	=> shiftedA,
			shiftedOut	=> shiftedB,
			zeroOut		=> open,
			msb			=> msb
		);
end CORDIC_Arch;