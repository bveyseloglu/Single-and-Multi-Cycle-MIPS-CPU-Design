library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
 Port ( a: in STD_LOGIC_VECTOR (31 downto 0);
					b: in STD_LOGIC_VECTOR (31 downto 0);
				zero: out STD_LOGIC;
			 result: out STD_LOGIC_VECTOR (31 downto 0);
		alucontrol: in STD_LOGIC_VECTOR (2 downto 0));
end alu;

architecture Behavioral of alu is
signal toplam : STD_LOGIC_VECTOR (32 downto 0);
signal fark : STD_LOGIC_VECTOR (31 downto 0);
signal slt : STD_LOGIC_VECTOR (31 downto 0);

begin
fark <= std_logic_vector(unsigned(a) - unsigned(b));
toplam <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));

zero <= '1' when fark = "00000000000000000000000000000000" else '0';

result <= (a and b) when alucontrol = "000" else
          (a or b) when alucontrol = "001" else
          toplam(31 downto 0) when alucontrol = "010" else
          (a and not(b)) when alucontrol = "100" else
          (a or not(b)) when alucontrol = "101" else
          fark when alucontrol = "110" else
          slt when alucontrol = "111" else
          (others=>'0');
          
slt <= (others=>'1') when a<b else (others=>'0'); --unsigned(a)<unsigned(b)

end Behavioral;
