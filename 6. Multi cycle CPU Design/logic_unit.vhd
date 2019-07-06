LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

entity logic_unit is
	PORT(a : IN STD_LOGIC_VECTOR(31 downto 0);
		 b : IN STD_LOGIC_VECTOR(31 downto 0);
		 op : IN STD_LOGIC_VECTOR(1 downto 0); -- son iki haneyi al
		 r : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end logic_unit;

architecture arc of logic_unit is 

    signal r_1, r_2, r_3, r_4 : STD_LOGIC_VECTOR(31 downto 0);

begin
	
	r_1 <= not(a or b);
	r_2 <= a and b;
	r_3 <= a or b;
	r_4 <= a xor b; 

    r  <= r_1 when op = "00" else 
          r_2 when op = "01" else
          r_3 when op = "10" else
          r_4;

end arc;