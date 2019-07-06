library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity top is -- top-level design for testing
	port (			clk, reset: in STD_LOGIC;
			 writedata, dataadr: out STD_LOGIC_VECTOR (31 downto 0);
						  memwrite: out STD_LOGIC);
end;
architecture Behavioral of top is
---------------------
component mips
	port (	clk, reset: in STD_LOGIC;
						  pc: out STD_LOGIC_VECTOR (31 downto 0);
					  instr: in STD_LOGIC_VECTOR (31 downto 0);
				  memwrite: out STD_LOGIC;
	  aluout, writedata: out STD_LOGIC_VECTOR (31 downto 0);
				  readdata: in STD_LOGIC_VECTOR (31 downto 0));
end component;
---------------------
component imem
   port ( a: in STD_LOGIC_VECTOR (5 downto 0);-- a is 6-bit instruction address input
         rd: out STD_LOGIC_VECTOR (31 downto 0));
end component;
---------------------
component dmem
	port ( clk, we: in STD_LOGIC;
				a, wd: in STD_LOGIC_VECTOR (31 downto 0);
					rd: out STD_LOGIC_VECTOR (31 downto 0));
end component;
---------------------
signal pc, instr, readdata: STD_LOGIC_VECTOR (31 downto 0);

--buffer signal 
signal memwrite_buffer : STD_LOGIC;
signal writedata_buffer, dataadr_buffer: STD_LOGIC_VECTOR (31 downto 0);

---------------------
begin
writedata <= writedata_buffer;
dataadr	<= dataadr_buffer;
memwrite <= memwrite_buffer;
-- instantiate processor and memories
mips1: mips port map (clk, reset, pc, instr, memwrite_buffer, dataadr_buffer, writedata_buffer, readdata);
imem1: imem port map (pc (7 downto 2), instr);
dmem1: dmem port map (clk, memwrite_buffer, dataadr_buffer, writedata_buffer, readdata);

end Behavioral;