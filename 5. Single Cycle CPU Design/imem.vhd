library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity imem is
   port ( a: in STD_LOGIC_VECTOR (5 downto 0);
         rd: out STD_LOGIC_VECTOR (31 downto 0));
end imem;

architecture Behavioral of imem is

type ROM_Array is array (0 to 31) of std_logic_vector(31 downto 0);

--signal instr_add : std_logic_vector(4 downto 0);

constant inst_mem: ROM_Array := (		-- Example Program Here. DECODE it to uderstand what to do	
	  0 => x"20020005",					-- or You can write your own program which includes your instructions.									
	  1 => x"2003000c",														
	  2 => x"2067fff7",														
	  3 => x"2067fff7",		             								
	  4 => x"00e22025",														
	  5 => x"00642824",														
	  6 => x"00a42820",														
	  7 => x"10a7000a",     												
	  8 => x"0064202a",		
	  9 => x"10800001",		
	  10 => x"20050000",		
	  11 => x"00e2202a",     							
	  12 => x"00853820",		
	  13 => x"00e23822",		
	  14 => x"ac670044",		
	  15 => x"8c020050",     
	  16 => x"08000011",		
	  17 => x"20020001",		
	  18 => x"ac020054",		
	  19 => "00000000000000000000000000000000",     
	  20 => "00000000000000000000000000000000",		
	  21 => "00000000000000000000000000000000",		
	  22 => "00000000000000000000000000000000",		
	  23 => "00000000000000000000000000000000",     
	  24 => "00000000000000000000000000000000",		
	  25 => "00000000000000000000000000000000",		
	  26 => "00000000000000000000000000000000",		
	  27 => "00000000000000000000000000000000",     
	  28 => "00000000000000000000000000000000",		
	  29 => "00000000000000000000000000000000",		
	  30 => "00000000000000000000000000000000",		
	  31 => "00000000000000000000000000000000",     
	  OTHERS => "11111111111111111111111111111111"		
	  );       
 
begin



rd <= inst_mem(conv_integer(a(4 downto 0)));				
	


end Behavioral;

