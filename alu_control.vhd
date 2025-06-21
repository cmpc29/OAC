library ieee;
use ieee.std_logic_1164.all;

entity alu_control is port(

	bit_30 : in std_logic;
	bits_14_12 : in std_logic_vector(2 downto 0);
	AluOP : in std_logic_vector(1 downto 0);
	AluBits : out std_logic_vector(4 downto 0)

);
end alu_control;

architecture rtl of alu_control is

begin

process(bit_30, bits_14_12, AluOP)
begin

	case AluOP is
	
		when "00" =>
			AluBits <= "00011"; -- add
			
		when "01" =>
			AluBits <= "00100"; -- sub
			
		when "10" =>
		
			if(bit_30='1') then
				AluBits <= "00100"; -- sub
			else
				
				case bits_14_12 is
					
					when "111" =>
						AluBits <= "00000"; -- and
			
					when "110" =>
						AluBits <= "00001"; -- or 
						
					when "010" =>
						AluBits <= "00101"; -- slt
						
					when others =>
						AluBits <= "00011"; -- add
				end case;
						
			end if;
						
		
		when others =>
			AluBits <= "00000"; -- and

	end case;

end process;

end rtl;