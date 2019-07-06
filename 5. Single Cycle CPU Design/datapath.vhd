library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	port(		clk, reset: in STD_LOGIC;
		 memtoreg, pcsrc: in STD_LOGIC;
		  alusrc, regdst: in STD_LOGIC;
		  regwrite, jump: in STD_LOGIC;
		      alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
						zero: out STD_LOGIC;
						  pc: out STD_LOGIC_VECTOR (31 downto 0);
					  instr: in STD_LOGIC_VECTOR(31 downto 0);
	  aluout, writedata: out STD_LOGIC_VECTOR (31 downto 0);
				  readdata: in STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of datapath is
--Components in the Datapath
component alu
	port (	   a: in STD_LOGIC_VECTOR (31 downto 0);
					b: in STD_LOGIC_VECTOR (31 downto 0);
				zero: out STD_LOGIC;
			 result: out STD_LOGIC_VECTOR (31 downto 0);
		alucontrol: in STD_LOGIC_VECTOR (2 downto 0));
end component;

component regfile
	port(				 clk: in STD_LOGIC;
					 	 we3: in STD_LOGIC;
			ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
						 wd3: in STD_LOGIC_VECTOR(31 downto 0);
				  rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component adder
	port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
				y: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component sl2
	port (	a: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
end component;

component signext
	port( a: in STD_LOGIC_VECTOR (15 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
end component;

component flopr 
   generic (width: integer);
	port (	clk, reset: in STD_LOGIC;
							d: in STD_LOGIC_VECTOR(width-1 downto 0);
							q: out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

component mux2 
	generic (wid: integer);
	port ( d0, d1: in STD_LOGIC_VECTOR(wid-1 downto 0);
					s: in STD_LOGIC;
					y: out STD_LOGIC_VECTOR(wid-1 downto 0));
end component;

signal writereg: STD_LOGIC_VECTOR (4 downto 0);
signal pcjump, pcnext, pcnextbr, pcplus4, pcbranch: STD_LOGIC_VECTOR (31 downto 0);
signal signimm, signimmsh: STD_LOGIC_VECTOR (31 downto 0);
signal srca, srcb, result: STD_LOGIC_VECTOR (31 downto 0);
--buffer signal 
signal pc_buffer : STD_LOGIC_VECTOR (31 downto 0);
signal aluout_buffer : STD_LOGIC_VECTOR (31 downto 0);
signal writedata_buffer : STD_LOGIC_VECTOR (31 downto 0);

begin
--buffers
pc <= pc_buffer;
aluout <= aluout_buffer;
writedata <= writedata_buffer;
-- next PC logic
pcjump <= pcplus4 (31 downto 28) & instr (25 downto 0) & "00";
 
pcreg: flopr -- flip-flop with synchronous reset
	generic map(32) 
	port map(clk, reset, pcnext, pc_buffer);
	
pcadd1: adder 
	port map(pc_buffer, X"00000004", pcplus4);
	
immsh: sl2 
	port map(signimm, signimmsh);
	
pcadd2: adder 
	port map(pcplus4, signimmsh, pcbranch);

pcbrmux: mux2 
	generic map(32) 
	port map(pcplus4, pcbranch, pcsrc, pcnextbr);
	
pcmux: mux2 
	generic map(32) 
	port map(pcnextbr, pcjump, jump, pcnext);
	
-- register file logic
rf: regfile 
	port map(clk, regwrite, instr(25 downto 21),instr(20 downto 16), writereg, result, srca, writedata_buffer);
	
wrmux: mux2 
	generic map(5) 
	port map(instr(20 downto 16),instr(15 downto 11), regdst, writereg);
	
resmux: mux2 
	generic map(32) 
	port map(aluout_buffer, readdata, memtoreg, result);
	
se: signext 
	port map(instr(15 downto 0), signimm);
	
-- ALU logic
srcbmux: mux2 
	generic map (32) 
	port map(writedata_buffer, signimm, alusrc, srcb);
	
mainalu: alu 
	port map(srca, srcb, zero, aluout_buffer, alucontrol);
	
	
end;