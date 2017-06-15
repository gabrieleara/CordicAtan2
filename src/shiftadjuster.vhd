library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ShiftAdjuster is
	generic (
		size	: positive := 8
	);
	port (
		input	: in	std_ulogic_vector(size-1 downto 0);
		output	: out	std_ulogic_vector(size-1 downto 0)
	);
end ShiftAdjuster;

architecture ShiftAdjuster_Arch of ShiftAdjuster is
	component AdderSubtractor is
		generic (size : positive := 8);
		port (
			inA			: in	std_ulogic_vector(size-1 downto 0);
			inB			: in	std_ulogic_vector(size-1 downto 0);
			sumSub		: in	std_ulogic;
			carryOut	: out	std_ulogic;
			value		: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;

	signal subOutput : std_ulogic_vector(size-1 downto 0);
begin
	
	output <= (others => '0') when unsigned(input) = 0 else subOutput;

	subtractor : AdderSubtractor
		generic map (size => size)
		port map (
			inA			=> (others => '1'), -- means -1 in 2-complement
			inB			=> input,
			sumSub		=> '0',
			carryOut	=> open,
			value		=> subOutput
		);
end ShiftAdjuster_Arch;