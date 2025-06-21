library ieee;
use ieee.std_logic_1164.all;

entity status_register is port(

	clk : in std_logic;
	input : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end status_register;

architecture rtl of status_register is

begin

process(clk)

	begin
	
	if (rising_edge(clk)) then
		output <= input;
	end if;
	
end process;
	

end rtl;