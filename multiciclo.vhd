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
	 --Sinais relacionados ao Controle
	 signal Control_out 		: std_logic_vector(18 downto 0); --sinal saida do controle
	 signal Op_ALU  			: std_logic_vector(1 downto 0);
	 signal OrigAluA 			: std_logic_vector(1 downto 0);
	 signal OrigAluB 			: std_logic_vector(1 downto 0);
    signal EscreveReg 		: std_logic := '0';
	 signal Mem2Reg 				: std_logic_vector(1 downto 0); --???????
	 signal EscreveIR 		: std_logic := '0';
	 signal IouD  				: std_logic := '0';
	 signal LeMem 				: std_logic := '0';
	 signal EscreveMem 		: std_logic := '0';
	 signal EscrevePCBack 	: std_logic := '0'; --EscrevePCB
	 signal OrigPC 			: std_logic := '0';
	 signal EscrevePCCond 	: std_logic := '0';
	 signal wrPC 				: std_logic;  		  --EscrevePC
	 signal Seq 				: std_logic_vector(1 downto 0); --Nao sao usados
	 --end
	 
	 signal PC_in       : std_logic_vector(31 downto 0) := x"00400000";
    signal PC_out      : std_logic_vector(31 downto 0) := x"00400000";
    
    signal pcb_out	  : std_logic_vector(31 downto 0) := (others => '0'); --OutPCback
    signal regout_reg  : std_logic_vector(31 downto 0) := (others => '0'); --??????
    signal estado_reg  : std_logic_vector(3 downto 0)  := (others => '0'); --n usado
	 
	 signal RegDataA_out 			: std_logic_vector(31 downto 0); 			--Out signalA do bd registradores
	 signal RegDataB_out 			: std_logic_vector(31 downto 0); 			--Out signalB do bd registradores
	 signal Imediato 					: std_logic_vector(31 downto 0); 					--sinal que recebe o imediato
    signal SaidaULA, Leitura2, B : std_logic_vector(31 downto 0); --leitura2 e B?????
    signal proximo    				: std_logic_vector(3 downto 0); 				--n usado ?????
	 signal AluBits 					: std_logic_vector(4 downto 0)
	
	--Sinais relacionados a Memorias de dados e instrucoes
    signal wIouD, MemData, MemData_mem, rmem : std_logic_vector(31 downto 0);  --relacionados a memoria
	 signal Instr_reg   : std_logic_vector(31 downto 0) := (others => '0'); --outRegistradordeInst
	 signal Instr_reg_mem : std_logic_vector(31 downto 0) := (others => '0'); --outRegistradordeInstMem
begin
		--Sinais relacionados ao Controle
	 Op_ALU  			<= Control_out(18 downto 17);
	 OrigAluA 			<= Control_out(16 downto 15);
	 OrigAluB 			<= Control_out(14 downto 13);
    EscreveReg 		<= Control_out(12);
	 Mem2Reg				<= Control_out(11 downto 10); --Mem2Reg
	 EscreveIR 			<= Control_out(9);
	 IouD  				<= Control_out(8);
	 LeMem 				<= Control_out(7);
	 EscreveMem 		<= Control_out(6);
	 EscrevePCBack 	<= Control_out(5); 			   --EscrevePCB
	 OrigPC 				<= Control_out(4);
	 EscrevePCCond 	<= Control_out(3);
	 wrPC 				<= Control_out(2); 			   --EscrevePC
		--end
		
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
			opcode 			=> Instr_reg(6 downto 0),
			control_signal => Control_out	
		);

-- Instancia Banco de Registradores
	Xreg: entity work.xreg
		port map(
			iCLK		=> clockCPU;
			iRST		=> reset; --Ponto de atencao
			iWREN		=> EscreveReg,
			iRS1		=> Instr_reg(19 downto 15),
			iRS2		=> Instr_reg(24 downto 20),
			iRD		=> Instr_reg(11 downto 7),
			iDATA		: in  std_logic_vector(31 downto 0);
			oREGA 	=> RegDataA_out,
			oREGB 	=> RegDataB_out,
			iDISP		: in  std_logic_vector(4 downto 0);
			oREGD		: out std_logic_vector(31 downto 0)
		);

--Instancia ULA
	ALU: entity work.ALU 
		 port map(
			  iControl => AluBits,
			  iA       : in  std_logic_vector(31 downto 0);
			  iB       : in  std_logic_vector(31 downto 0);
			  oResult  => SaidaULA
		);
			
--Instancia ULA Control
	Alu_Control: entity work.alu_control 
		port map(
			bit_30 		=> Instr_reg(30),
			bits_14_12 	=> Instr_reg(14 downto 12),
			AluOP 		=> Op_ALU,
			AluBits 		=> AluBits
		);
		
--Instancia Gerador de Imediatos
	GenImm32: entity work.genImm32
		port map(
			instr => Instr_reg(31 downto 0),
			imm32 => Imediato
		);
--Instancia os Muxes
Mux3to1_MemD : entity work.Mux3to1
    port map(
        data_in0 => SaidaULA,
        data_in1 => PC_out,
        data_in2 => MemData,
        sel      => Mem2Reg,
        data_out : out std_logic_vector(31 downto 0) --Ligar no iDATA de xregs
    );
	 
Mux3to1_ULAa : entity work.Mux3to1
    port map(
        data_in0 => pcb_out,
        data_in1 => in std_logic_vector(31 downto 0), --saida A bd reg
        data_in2 => PC_out,
        sel      => Mem2Reg,
        data_out : out std_logic_vector(31 downto 0) --Ligar no iDATA de xregs
    );
	 
Mux4to1 : entity work.Mux4to1
    port map(
        data_in0 => RegDataB_out,
        data_in1 => x"00000004", 
        data_in2 => Imediato,
        data_in3 => x"00000000", --????
        sel      => OrigAluB,
        data_out : out std_logic_vector(31 downto 0) --Ligar
    );
	 
Mux2to1_PCOut: entity work.Mux2to1
    port map(
        data_in0 : PC_out,
        data_in1 : SaidaULA,
        sel      : IouD,
        data_out : wIouD
    );
	 
Mux2to1_ULAOut: entity work.Mux2to1
    port map(
        data_in0 : UlaOut,
        data_in1 : SaidaULA,
        sel      : IouD,
        data_out : wIouD
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
            q       => Instr_reg_mem
        );

    -- Instância de memória de dados
    MemD: entity work.ramD
        port map (
            address => wIouD(11 downto 2),
            clock   => clockCPU,
            data    => B,
            wren    => EscreveMem and wIouD(28),
            q       => MemData_mem
        );

    -- Seleção entre instrução ou dado da memória
    rmem <= MemData_mem when wIouD(28) = '1' else Instr_reg_mem;


	--registrador de instrucoes
	process (clockCPU)
begin
	if (rising_edge(clockCPU)) and (EscreveIR = '1') then
		instr_reg <= rmem;
	end if;
end process;

--registrador de dados
	process (clockCPU)
begin
	if (rising_edge(clockCPU)) then
		MemData <= rmem;
	end if;
end process;


end Behavioral;






