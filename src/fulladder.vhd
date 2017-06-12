library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
	port (
		inB			: in	std_ulogic;
		inA			: in	std_ulogic;
		carryIn		: in	std_ulogic;
		carryOut	: out	std_ulogic;
		sum			: out	std_ulogic
	);
end FullAdder;

architecture FullAdder_Arch of FullAdder is
begin
	sum			<= inA xor inB xor carryIn;
	carryOut	<= (inA and inB) or (inA and carryIn) or (inB and carryIn);
end FullAdder_Arch;