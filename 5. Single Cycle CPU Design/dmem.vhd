library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all; 
use IEEE.STD_LOGIC_ARITH.all;

entity dmem is -- data memory
	port (	clk, we: in STD_LOGIC;
				  a, wd: in STD_LOGIC_VECTOR (31 downto 0);
				     rd: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of dmem is

type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);

signal mem: ram_type; 
signal temp : std_logic_vector(31 downto 0):= mem(0);
signal tempaddr : std_logic_vector(31 downto 0):= (others => '0');

begin

rd <= temp;

--read operation
process(a, mem,we,tempaddr)										
begin	
    if (we = '1' and tempaddr /= a) then
        temp <= mem(conv_integer(a));
        tempaddr <= a;
    end if;
		
			
end process;

--write operation
process(clk, we, wd)		
begin
    if (we = '1') then 
        if (clk = '1' and clk'event) then
           mem(conv_integer(a)) <= wd;
        end if;
    end if;
end process;

end;