library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.riscv_pkg.all;

entity Multiciclo is
    Port (
        clockCPU : in std_logic;
        clockMem : in std_logic;
        reset    : in std_logic;
        PC       : out std_logic_vector(31 downto 0);
        Instr    : out std_logic_vector(31 downto 0);
        regin    : in std_logic_vector(4 downto 0);
        regout   : out std_logic_vector(31 downto 0);
        estado   : out std_logic_vector(3 downto 0)
    );
end Multiciclo;

architecture Behavioral of Multiciclo is

    signal PC_in       : std_logic_vector(31 downto 0) := x"00400000";
    signal PC_out      : std_logic_vector(31 downto 0) := x"00400000";
    signal Instr_reg   : std_logic_vector(31 downto 0) := (others => '0');
    signal EscrevePCBack : std_logic := '0';
    signal pcb_out	  : std_logic_vector(31 downto 0) := (others => '0');
    signal regout_reg  : std_logic_vector(31 downto 0) := (others => '0');
    signal estado_reg  : std_logic_vector(3 downto 0)  := (others => '0');
	 signal Control_out : std_logic_vector(18 downto 0); --sinal saida do controle

    signal SaidaULA, Leitura2, B : std_logic_vector(31 downto 0);
    signal EscreveMem : std_logic := '0';
	 signal wrPC : std_logic;
    signal proximo    : std_logic_vector(3 downto 0);

    signal wIouD, MemData, rmem : std_logic_vector(31 downto 0);

begin

    -- Sinais de saída
--    PC     <= PC_reg;
--    Instr  <= Instr_reg;
--    regout <= regout_reg;
--    estado <= estado_reg;
--
--    process(clockCPU, reset)
--    begin
--        if reset = '1' then
--            PC_reg     <= x"00400000";
--            PCBack     <= x"00400000";
--            estado_reg <= (others => '0');
--        elsif rising_edge(clockCPU) then
--            estado_reg <= proximo;
--        end if;
--    end process;


-- Instancia Controle/Controlar/Controlador
	Control_Unit: entity work.control_unit 
		port map(
			clk 				=> clockCPU,
			opcode 			: in std_logic_vector(6 downto 0),
			control_signal => Control_out	
		);

-- Instancia Banco de Registradores
	Xreg: entity work.xreg
		port map(
			iCLK		=> clockCPU;
			iRST		: in  std_logic;
			iWREN		: in  std_logic;
			iRS1		: in  std_logic_vector(5-1 downto 0);
			iRS2		: in  std_logic_vector(5-1 downto 0);
			iRD		: in  std_logic_vector(5-1 downto 0);
			iDATA		: in  std_logic_vector(32-1 downto 0);
			oREGA 	: out std_logic_vector(32-1 downto 0);
			oREGB 	: out std_logic_vector(32-1 downto 0);
			
			iDISP		: in  std_logic_vector(5-1 downto 0);
			oREGD		: out std_logic_vector(32-1 downto 0)
		);

--Instancia ULA
	ALU: entity work.ALU 
		 port map(
			  iControl : in  std_logic_vector(4 downto 0);
			  iA       : in  std_logic_vector(31 downto 0);
			  iB       : in  std_logic_vector(31 downto 0);
			  oResult  : out std_logic_vector(31 downto 0)
		);
			
--Instancia ULA Control
	Alu_Control: entity work.alu_control 
		port map(
			bit_30 		: in std_logic;
			bits_14_12 	: in std_logic_vector(2 downto 0),
			AluOP 		=> Control_out(18 downto 17),  --REVISAR SE SERA 18 DOWNTO 17 OU 1 DOWNTO 0, PQ A ORDEM DA TABELA PODE ESTAR INVERTIDA
			AluBits 		: out std_logic_vector(4 downto 0)
		);
		
--Instancia Gerador de Imediatos
	GenImm32: entity work.genImm32
		port map(
			instr : in std_logic_vector(31 downto 0);
			imm32 : out std_logic_vector(31 downto 0));
		);






PCreg:	regPC port map (
						clk  => clockCPU,
						wren => wrPC,
						rst  => reset,
						reg_in => PC_in,
						reg_out => PC_out
			);

PCBack:  regPC port map (
						clk  => clockCPU,
						wren => EscrevePCBack,
						rst  => reset,
						reg_in => PC_out,
						reg_out => pcb_out
			);

    -- Instância de memória de instruções
    MemC: entity work.ramI
        port map (
            address => wIouD(11 downto 2),
            clock   => clockCPU,
            data    => B,
            wren    => EscreveMem and not wIouD(28),
            q       => Instr_reg
        );

    -- Instância de memória de dados
    MemD: entity work.ramD
        port map (
            address => wIouD(11 downto 2),
            clock   => clockCPU,
            data    => B,
            wren    => EscreveMem and wIouD(28),
            q       => MemData
        );

    -- Seleção entre instrução ou dado da memória
    rmem <= MemData when wIouD(28) = '1' else Instr_reg;

end Behavioral;
