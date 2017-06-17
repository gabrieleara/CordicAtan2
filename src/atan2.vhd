library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Atan2 is
	port (
		clock		: in	std_ulogic;
		reset		: in	std_ulogic;
		msbB		: in	std_ulogic;
		zeroA		: in	std_ulogic;
		count		: in	std_ulogic_vector(4-1 downto 0);
		valid		: out	std_ulogic;
		atan2Out	: out	std_ulogic_vector(12-1 downto 0)
	);
end Atan2;

architecture Atan2_Arch of Atan2 is

	constant SIZE			: positive := 12;
	constant COUNTER_SIZE	: positive := 4;
	constant LUT_SIZE		: positive := 11;

	type bin_array is array (natural range <>) of std_ulogic_vector(SIZE-1 downto 0);
	constant lut : bin_array := ("001100100100","000110010010","000011101101","000001111101","000001000000","000000100000","000000010000","000000001000","000000000100","000000000010","000000000001");

	component Accumulator
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

	signal atanFromLut		: std_ulogic_vector(SIZE-1 downto 0);
	signal zero				: std_ulogic;
begin

	zero <= '1' when unsigned(count) = 0 else '0';
	atanFromLut <= lut(to_integer(unsigned(count))) when (zeroA = '0' or zero = '1') else (others => '0');
	valid <= zero;

	atanAccumulator : Accumulator
		generic map (size => SIZE)
		port map (
			clock	=> clock,
			reset	=> reset,
			zero	=> zero,
			inA		=> atanFromLut,
			sumSub	=> msbB,
			value	=> atan2Out
		);
end Atan2_Arch;