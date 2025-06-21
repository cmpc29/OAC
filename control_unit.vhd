library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity control_unit is port(


	clk : in std_logic;
	opcode : in std_logic_vector(6 downto 0);
	control_signal : out std_logic_vector(18 downto 0)	


);
end control_unit;

architecture rtl of control_unit is

component microcode_rom is port(

	address : in std_logic_vector(3 downto 0);
	output  : out std_logic_vector(18 downto 0)

);
end component;

component mux_next_state is port(

	decision_bits : in std_logic_vector(1 downto 0);
	input0 : in std_logic_vector(3 downto 0);
	input1 : in std_logic_vector(3 downto 0);
	input2 : in std_logic_vector(3 downto 0);
	input3 : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end component;

component rom_despacho1 is port(

	address : in std_logic_vector(6 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end component;

component mux_next_state2 is port(

	decision_bits : in std_logic_vector(1 downto 0);
	input0 : in std_logic_vector(3 downto 0);
	input1 : in std_logic_vector(3 downto 0);
	input2 : in std_logic_vector(3 downto 0);
	input3 : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end component;

component rom_despacho2 is port(

	address : in std_logic_vector(6 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end component;

component status_register is port(

	clk : in std_logic;
	input : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)

);
end component;

component somador is port(

	input1 : in std_logic_vector(3 downto 0);
	input2 : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(3 downto 0)
);
end component;

	signal clk_input : std_logic;
	signal opcode_input : std_logic_vector(6 downto 0);

	signal mux_decision_bits : std_logic_vector(1 downto 0);
	signal mux_output : std_logic_vector(3 downto 0);
	
	signal rom1_output : std_logic_vector(3 downto 0);
	signal rom2_output : std_logic_vector(3 downto 0);
	
	signal status_output : std_logic_vector(3 downto 0);
	
	signal microcode_output : std_logic_vector(18 downto 0);


begin

	clk_input <= clk;
	opcode_input <= opcode;
	mux_decision_bits <= microcode_output(1 downto 0);
	
MICROCODE_ROM_A : microcode_rom port map(address => status_output, output => microcode_output);
STATUS_REGISTER_A : status_register port map(clk => clk_input, input=> mux_output, output => status_output);
ROM_DESPACHO1_A : rom_despacho1 port map(address => opcode_input, output => rom1_output);
ROM_DESPACHO2_A : rom_despacho2 port map(address => opcode_input, output => rom2_output);
MUX_NEXT_STATE_A : mux_next_state2 port map(decision_bits => mux_decision_bits, input0 => "0000", input1 => rom1_output,
					   input2 => rom2_output, input3 => status_output, output => mux_output);

	control_signal <= microcode_output;

end rtl;
