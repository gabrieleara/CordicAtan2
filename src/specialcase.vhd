library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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

	signal isZeroA		: std_ulogic;
	signal isZeroB		: std_ulogic;

	signal isZeroAHold	: std_ulogic;

begin

	-- TODO: zero detector, for first loop, check in synthesis phase
	zero <= '1' when unsigned(count) = 0 else '0';
	enableReg <= not zero;

	isZeroA <= '1' when (unsigned(inA) = 0 or zero = '1') else '0';
	isZeroB <= '1' when (unsigned(inB) = 0 or zero = '1') else '0';

	isZero <= isZeroA and isZeroB;

	isZeroAReg: GRegisterEn
		generic map (size => 1)
		port map (
			clock	=> clock,
			reset	=> reset,
			enable	=> enableReg,
			data	=> isZeroA,
			value	=> isZeroAHold
		);

	enable <= not isZero when zero = '1'
				else not isZeroAHold;

end SpecialCase_Arch;