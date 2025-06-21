library ieee;
use ieee.std_logic_1164.all;

entity rom_despacho2 is port(

	address : in std_logic_vector(6 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end rom_despacho2;

architecture rtl of rom_despacho2 is

begin

	with address select output <=
		"0011" when "0000011", --lw
		"0101" when "0100011", --sw
		"0111" when "0110011", --R
		"1010" when "1100111", --jalr
		"0000" when others;

end rtl;
