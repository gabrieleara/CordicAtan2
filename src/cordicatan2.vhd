library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CORDICAtan2 is
	port (
		clock		: in	std_ulogic;
		reset		: in	std_ulogic;
		inA			: in	std_ulogic_vector(12-1 downto 0);
		inB			: in	std_ulogic_vector(12-1 downto 0);
		valid		: out	std_ulogic;
		atan2Out	: out	std_ulogic_vector(12-1 downto 0)
	);

end CORDICAtan2;

architecture CORDICAtan2_Arch of CORDICAtan2 is

	constant SIZE			: positive := 12;
	constant EXTENDED_SIZE	: positive := SIZE+2;
	constant COUNTER_SIZE	: positive := 4;
	constant LUT_SIZE		: positive := 11;

	component Atan2 is
		port (
			clock		: in	std_ulogic;
			reset		: in	std_ulogic;
			msbB		: in	std_ulogic;
			zeroA		: in	std_ulogic;
			count		: in	std_ulogic_vector(4-1 downto 0);
			valid		: out	std_ulogic;
			atan2Out	: out	std_ulogic_vector(12-1 downto 0)
		);
	end component;

	component CORDIC is
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

	signal zeroCounter	: std_ulogic;
	signal msbB			: std_ulogic;
	signal zeroA		: std_ulogic;
	signal counterIn	: std_ulogic_vector(COUNTER_SIZE-1 downto 0);
	signal count		: std_ulogic_vector(COUNTER_SIZE-1 downto 0);

	signal extendedA	: std_ulogic_vector(EXTENDED_SIZE-1 downto 0);
	signal extendedB	: std_ulogic_vector(EXTENDED_SIZE-1 downto 0);
begin

	extendedA <= inA(size-1) & inA(size-1) & inA;
	extendedB <= inB(size-1) & inB(size-1) & inB;

	atan2Calculator : Atan2
		port map (
			clock		=> clock,
			reset		=> reset,
			msbB		=> msbB,
			zeroA		=> zeroA,
			count		=> count,
			valid		=> valid,
			atan2Out	=> atan2Out
		);

	cordicInstance : CORDIC
		generic map (
			size		=> EXTENDED_SIZE,
			counterSize	=> COUNTER_SIZE
		)
		port map (
			clock		=> clock,
			reset		=> reset,
			inA			=> extendedA,
			inB			=> extendedB,
			count		=> count,
			zeroA		=> zeroA,
			msbB		=> msbB
		);

	counter : Accumulator
		generic map (size => COUNTER_SIZE)
		port map (
			clock	=> clock,
			reset	=> reset,
			zero	=> zeroCounter,
			inA		=> counterIn,
			sumSub	=> '0',
			value	=> count
		);

	zeroCounter <= '1' when (unsigned(count) = LUT_SIZE-1) else '0';
	counterIn <= std_ulogic_vector(to_unsigned(1, COUNTER_SIZE))
					when zeroCounter = '0'
					else std_ulogic_vector(to_unsigned(0, COUNTER_SIZE));

end CORDICAtan2_Arch;
