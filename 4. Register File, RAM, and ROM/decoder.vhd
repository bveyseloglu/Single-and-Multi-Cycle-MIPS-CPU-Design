library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( addr 	: in  STD_LOGIC_VECTOR(15 downto 0);
           cs_ram 	: out  STD_LOGIC;		-- chip select RAM
           cs_rom 	: out  STD_LOGIC);		-- chip select ROM
end decoder;

architecture Behavioral of decoder is

begin

	process(addr)
	begin
	
		if (unsigned(addr) < 1024) then
			cs_rom <= '1';
			cs_ram <= '0';
		elsif (unsigned(addr) > 1020 and unsigned(addr) < 2048) then
			cs_rom <= '0';
			cs_ram <= '1';
		else
			cs_rom <= '0';
			cs_ram <= '0';
		end if;
	
	end process;
	
	
end Behavioral;