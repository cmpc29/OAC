library ieee;
use ieee.std_logic_1164.all;

entity rom_despacho1 is port(

	address : in std_logic_vector(6 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end rom_despacho1;

architecture rtl of rom_despacho1 is

begin

	with address select output <=
		"0010" when "0000011", --lw
		"0010" when "0100011", --sw
		"0110" when "0010011", --addi
		"1000" when "0110011", --R
		"1001" when "1100011", --beq
		"1010" when "1101111", --jal
		"1011" when "1100111", --jalr
		"0000" when others;

end rtl;
