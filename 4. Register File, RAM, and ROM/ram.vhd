--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

library IEEE; 
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- don't use this
use IEEE.numeric_std.all; -- use that, it's a better coding guideline
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram is
    port(
		clk_ram    	: in  std_logic;
		cs_ram      : in  std_logic;
		read_ram    : in  std_logic;
		write_ram   : in  std_logic;
		ad_ram		: in  std_logic_vector(12 downto 0);
		wrdata  	: in  std_logic_vector(31 downto 0);
		rddata  	: out std_logic_vector(31 downto 0));
end ram;


architecture Behavioral of ram is

	type reg_type is array(0 to 1023) of std_logic_vector(31 downto 0);
	signal reg: reg_type;
	
	signal adres : std_logic_vector(12 downto 0);

begin

	--data <= reg(conv_integer(address));
	
	adres <= std_logic_vector(unsigned(ad_ram) - 1023);
	
	process(clk_ram, read_ram, write_ram)
	begin
	
		if (clk_ram = '1' and clk_ram'event) then
			if (cs_ram = '1' and read_ram = '1' and write_ram = '0') then -- read
				rddata <= reg(conv_integer(adres));
			elsif (cs_ram = '1' and read_ram = '0' and write_ram = '1') then -- write
				reg(conv_integer(adres)) <= wrdata;
			end if;
		    
		end if;
	
	end process;

end Behavioral;