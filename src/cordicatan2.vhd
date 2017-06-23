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
			enable		: in	std_ulogic;
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
			msbB		: out	std_ulogic

		);
	end component;

	component CounterWithMax is
		generic (
			size	: positive := 8;
			max		: positive := 16
		);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	component SpecialCase is
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
	end component;

	signal msbB			: std_ulogic;
	signal enable		: std_ulogic;
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
			enable		=> enable,
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
			msbB		=> msbB
		);

	counter : CounterWithMax
		generic map (
			size	=> COUNTER_SIZE,
			max		=> LUT_SIZE
		)
		port map (
			clock	=> clock,
			reset	=> reset,
			value	=> count
		);

	special : SpecialCase
		generic map (
			size		=> SIZE,
			counterSize	=> COUNTER_SIZE
		)
		port map (
			clock		=> clock,
			reset		=> reset,
			count		=> count,
			inA			=> inA,
			inB			=> inB,
			enable		=> enable
		);

end CORDICAtan2_Arch;
