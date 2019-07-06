----------------------------------------------------------------------------------
-- 
-- Create Date:    09:08:33 02/13/2009 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ALU IS 
	generic(n : INTEGER := 32);
	port
	(clk : IN  std_logic;
		a :  IN  STD_LOGIC_VECTOR(31 downto 0);
		b :  IN  STD_LOGIC_VECTOR(31 downto 0);
		op :  IN  STD_LOGIC_VECTOR(5 downto 0);
		s :  OUT  STD_LOGIC_VECTOR(31 downto 0)
	);
END ALU;

ARCHITECTURE bdf_type OF ALU IS 

	component add_sub
		generic(n : INTEGER);
		PORT(sub_mode : IN STD_LOGIC;
			 a : IN STD_LOGIC_VECTOR(31 downto 0);
			 b : IN STD_LOGIC_VECTOR(31 downto 0);
			 carry : OUT STD_LOGIC;
			 zero : OUT STD_LOGIC;
			 r : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;

	component comparator
		PORT(carry : IN STD_LOGIC;
			 zero : IN STD_LOGIC;
			 a_31 : IN STD_LOGIC;
			 b_31 : IN STD_LOGIC;
			 diff_31 : IN STD_LOGIC;
			 op : IN STD_LOGIC_VECTOR(2 downto 0);
			 r : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;

	component logic_unit
		PORT(a : IN STD_LOGIC_VECTOR(31 downto 0);
			 b : IN STD_LOGIC_VECTOR(31 downto 0);
			 op : IN STD_LOGIC_VECTOR(1 downto 0);
			 r : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;

	component multiplexer
		generic(n : integer);
		PORT(i0 : IN STD_LOGIC_VECTOR(n-1 downto 0);
			 i1 : IN STD_LOGIC_VECTOR(n-1 downto 0);
			 i2 : IN STD_LOGIC_VECTOR(n-1 downto 0);
			 i3 : IN STD_LOGIC_VECTOR(n-1 downto 0);
			 sel : IN STD_LOGIC_VECTOR(1 downto 0);
			 o : OUT STD_LOGIC_VECTOR(n-1 downto 0)
		);
	end component;

	component shift_unit
		generic(n : INTEGER);
		PORT(a : IN STD_LOGIC_VECTOR(31 downto 0);
			 b : IN STD_LOGIC_VECTOR(4 downto 0);
			 op : IN STD_LOGIC_VECTOR(2 downto 0);
			 r : OUT STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;

	signal	addsub :  STD_LOGIC_VECTOR(31 downto 0);
	signal	carry :  STD_LOGIC;
	signal	comp_r :  STD_LOGIC_VECTOR(31 downto 0);
	signal	logic_r :  STD_LOGIC_VECTOR(31 downto 0);
	signal	shift_r :  STD_LOGIC_VECTOR(31 downto 0);
	signal	zero :  STD_LOGIC;


BEGIN 

	add_sub_0 : add_sub
	generic map (n)
	PORT MAP(sub_mode => op(3),
			 a => a,
			 b => b,
			 carry => carry,
			 zero => zero,
			 r => addsub);

	comparator_0 : comparator
	PORT MAP(carry => carry,
			 zero => zero,
			 a_31 => a(31),
			 b_31 => b(31),
			 diff_31 => addsub(31),
			 op => op(2 downto 0),
			 r => comp_r);

	logic_unit_0 : logic_unit
	PORT MAP(a => a,
			 b => b,
			 op => op(1 downto 0),
			 r => logic_r);
			 
	shift_unit_0 : shift_unit
	generic map(n)
	PORT MAP(a => a,
			 b => b(4 downto 0),
			 op => op(2 downto 0),
			 r => shift_r);

	multiplexer_0 : multiplexer
	generic map(n)
	PORT MAP(i0 => addsub,
			 i1 => comp_r,
			 i2 => logic_r,
			 i3 => shift_r,
			 sel => op(5 downto 4),
			 o => s);

END; 