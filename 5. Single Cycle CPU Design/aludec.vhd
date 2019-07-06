library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity aludec is
  Port (funct: in STD_LOGIC_VECTOR (5 downto 0);
		aluop: in STD_LOGIC_VECTOR (1 downto 0);
		 alucontrol: out STD_LOGIC_VECTOR (2 downto 0) );
end aludec;

architecture Behavioral of aludec is

begin
    alucontrol <= "010" when aluop = "00" else
                  "110" when aluop(0) = '1' else
                  "010" when funct = "100000" else
                  "110" when funct = "100010" else
                  "000" when funct = "100100" else
                  "001" when funct = "100101" else
                  "111" when funct = "101010" else
                  "100";
                    

end Behavioral;
