library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ir is
	port 		(	clk, enable: in STD_LOGIC;
							d: in STD_LOGIC_VECTOR(31 downto 0);
							q: out STD_LOGIC_VECTOR(31 downto 0));
end ir;

architecture Behavioral of ir is

	signal sakla: STD_LOGIC_VECTOR(31 downto 0):=(others=>'0');

begin
	
	q <= sakla;
	
	process(clk)
	begin	
	
		if(clk'event and clk='1')then
			if (enable='0') then
				sakla <= (others=>'0');
			else
				sakla<=d;
			end if;
		end if;
		
	end process;
	
end Behavioral;

