library ieee;
use ieee.std_logic_1164.all;

entity Mux2to1 is
    port (
        data_in0 : in std_logic_vector(31 downto 0);
        data_in1 : in std_logic_vector(31 downto 0);
        sel      : in std_logic;
        data_out : out std_logic_vector(31 downto 0)
    );
end entity Mux2to1;

architecture Behavioral of Mux2to1 is
begin
    data_out <= data_in1 when sel = '1' else data_in0;
end architecture Behavioral;

entity Mux3to1 is
    port (
        data_in0 : in std_logic_vector(31 downto 0);
        data_in1 : in std_logic_vector(31 downto 0);
        data_in2 : in std_logic_vector(31 downto 0);
        sel      : in std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end entity Mux3to1;

architecture Behavioral of Mux3to1 is
begin
    with sel select
        data_out <= data_in0 when "00",
                    data_in1 when "01",
                    data_in2 when "10",
                    (others => 'X') when others;
end architecture Behavioral;

entity Mux4to1 is
    port (
        data_in0 : in std_logic_vector(31 downto 0);
        data_in1 : in std_logic_vector(31 downto 0);
        data_in2 : in std_logic_vector(31 downto 0);
        data_in3 : in std_logic_vector(31 downto 0);
        sel      : in std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end entity Mux4to1;

architecture Behavioral of Mux4to1 is
begin
    with sel select
        data_out <= data_in0 when "00",
		  

end process;

                    data_in1 when "01",
                    data_in2 when "10",
                    data_in3 when "11",
                    (others => 'X') when others;
end architecture Behavioral;
