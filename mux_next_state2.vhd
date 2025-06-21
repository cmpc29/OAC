library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity mux_next_state2 is port(

	decision_bits : in std_logic_vector(1 downto 0);
	input0 : in std_logic_vector(3 downto 0);
	input1 : in std_logic_vector(3 downto 0);
	input2 : in std_logic_vector(3 downto 0);
	input3 : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end mux_next_state2;

architecture rtl of mux_next_state2 is 

signal number : std_logic_vector(3 downto 0);

begin

number <= "0001";

logic : process(decision_bits)
variable aux : std_logic_vector(3 downto 0);


begin

	if(decision_bits = "00") then
		output <= input0;
	elsif(decision_bits = "01") then
		output <= input1;
	elsif(decision_bits = "10") then
		output <= input2;
	else
		aux := unsigned(input3)+unsigned(number);
		output <= aux;
	end if;


end process logic;
end rtl;