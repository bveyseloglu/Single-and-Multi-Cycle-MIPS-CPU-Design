library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity controller is -- single cycle control decoder
	port (	 op, funct: in STD_LOGIC_VECTOR (5 downto 0);
						zero: in STD_LOGIC;
	 memtoreg, memwrite: out STD_LOGIC;
			pcsrc, alusrc: out STD_LOGIC;
		regdst, regwrite: out STD_LOGIC;
						jump: out STD_LOGIC;
				alucontrol: out STD_LOGIC_VECTOR (2 downto 0));
	
end;

architecture struct of controller is
--Components used in Controller
component maindec
	port (					 op: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
				 branch, alusrc: out STD_LOGIC;
			  regdst, regwrite: out STD_LOGIC;
						     jump: out STD_LOGIC;
							 aluop: out STD_LOGIC_VECTOR (1 downto 0));
end component;

component aludec
	port (	funct: in STD_LOGIC_VECTOR (5 downto 0);
				aluop: in STD_LOGIC_VECTOR (1 downto 0);
		 alucontrol: out STD_LOGIC_VECTOR (2 downto 0));
end component;
--Signals
signal aluop: STD_LOGIC_VECTOR (1 downto 0);
signal branch: STD_LOGIC;

begin

maindecoder: maindec port map (op, 
                            memtoreg, 
                            memwrite, 
                            branch, 
                            alusrc, 
                            regdst, 
                            regwrite,
                            jump,
                            aluop
                          );
aludecoder: aludec port map (funct, 
                            aluop, 
                            alucontrol
                          );



end;