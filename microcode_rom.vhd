library ieee;
use ieee.std_logic_1164.all;

entity microcode_rom is port(

	address : in std_logic_vector(3 downto 0);
	output  : out std_logic_vector(18 downto 0)

);
end microcode_rom;

architecture rtl of microcode_rom is

begin

	with address select output <=
		"0010010001010100111" when "0000", --0
		"0000100000000000001" when "0001", --1
		"0001100000000000010" when "0010", --2
		"0000000000110000011" when "0011", --3
		"0000001100000000000" when "0100", --4
		"0000000000101000000" when "0101", --5
		"0001100000000000011" when "0110", --6
		"0000001000000000000" when "0111", --7
		"1001000000000000010" when "1000", --8
		"0101000000000011000" when "1001", --9
		"0000001010000010100" when "1010", --10
		"0001100000000000010" when "1011", --11
		"0000000000000000000" when others;


end rtl;