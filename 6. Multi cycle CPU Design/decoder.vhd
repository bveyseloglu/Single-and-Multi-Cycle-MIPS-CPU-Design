

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
use IEEE.STD_LOGIC_ARITH.all;


entity decoder is
    Port ( addr 	: in  STD_LOGIC_VECTOR(15 downto 0);
           cs_di 	: out  STD_LOGIC;		-- chip select button
		   cs_do 	: out  STD_LOGIC;		-- chip select Seven Segment Display
           cs_ram 	: out  STD_LOGIC;		-- chip select RAM
           cs_rom 	: out  STD_LOGIC);		-- chip select ROM
end decoder;


architecture behave of decoder is

	type ram_type is array (0 to 1023) of std_logic_vector(31 downto 0);
	signal mem: ram_type:= ((others=> (others=>'0')));


begin

	--mem(1) <= "11111111111111110000000000000000";
	--mem(4) <= "00000000000000001111111111111111";

	--read operation
	process(a, mem,we,tempaddr)										
	begin	
			
		if (clk_rom = '1' and clk_rom'event) then
			if (cs_rom = '1' and read_rom = '1') then 
			   rddata <= mem(conv_integer(ad_rom));
			end if;
		end if;
				
	end process;

	--write operation
	--process(clk_rom, we, wd)		
	--begin
	 --   if (cs_rom = '1' and read_rom = '1') then 
	 --       if (clk_rom = '1' and clk_rom'event) then
	 --          mem(conv_integer(a)) <= wd;
	 --      end if;
	 -- end if;
	--end process;

end;