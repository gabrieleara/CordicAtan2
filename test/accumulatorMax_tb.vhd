library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity accumulator_tb is
end accumulator_tb;

architecture beh of	accumulator_tb is 

	constant Nbit : positive := 4;

	component AccumulatorMax is
		generic (size : positive := 8);
		port (
			clock	: in	std_ulogic;
			reset	: in	std_ulogic;
	        max     : in    std_ulogic_vector(size-1 downto 0);
			inA		: in	std_ulogic_vector(size-1 downto 0);
			sumSub	: in	std_ulogic;
			value	: out	std_ulogic_vector(size-1 downto 0)
		);
	end component;
	
	signal inA		: std_ulogic_vector(Nbit-1 downto 0) := "0000";
	signal max		: std_ulogic_vector(Nbit-1 downto 0) := "1010";
	signal sumSub	: std_ulogic := '0';
	signal clk		: std_ulogic := '0';
	signal rst		: std_ulogic := '1';
	
begin															   
	
	my_acc : AccumulatorMax
	generic map (size => Nbit)
	port map(
		clock	=> clk,
		reset	=> rst,
        max     => max,
		inA		=> inA,
		sumSub	=> sumSub,
		value	=> open
	);
	
	clk <= not clk after 10 ns;
	
	-- stimuli
	drive_p : process
	begin

		wait for 25ns;
		rst <= '0';
		
		wait for 25ns;
		inA <= "0010";
		
		wait for 100ns;
		
		wait;
	end	process;
	
end beh;