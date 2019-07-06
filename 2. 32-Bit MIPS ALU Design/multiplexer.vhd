LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

entity  multiplexer is
		generic(n : integer := 32);
		PORT(i0 : IN STD_LOGIC_VECTOR(n-1 downto 0); -- addsub
			 i1 : IN STD_LOGIC_VECTOR(n-1 downto 0); --comp
			 i2 : IN STD_LOGIC_VECTOR(n-1 downto 0); --logic
			 i3 : IN STD_LOGIC_VECTOR(n-1 downto 0); -- shifdt rot
			 sel : IN STD_LOGIC_VECTOR(1 downto 0);
			 o : OUT STD_LOGIC_VECTOR(n-1 downto 0)
		);
	end multiplexer;

architecture arc of multiplexer is

begin

        --with sel select o <=
          --  i0 when "00",
            --i1 when "01",
            --i2 when "10",
            --i3 when others;

o  <= i0 when sel="00" else 
      i1 when sel="01" else 
      i2 when sel="10" else 
      i3;   

end arc;