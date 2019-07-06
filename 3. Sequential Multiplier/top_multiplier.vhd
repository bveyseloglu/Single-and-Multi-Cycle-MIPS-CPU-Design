----------------------------------------------------------------------------------
-- 
-- Create Date:    13:32:56 08/30/2009 
-- Design Name: 
-- Module Name:    top_multiplier - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_multiplier is
    Port ( A 	: in std_logic_vector(7 downto 0);
           B 	: in std_logic_vector(7 downto 0);
           clk 	: in  STD_LOGIC;
           reset 	: in  STD_LOGIC;
           start 	: in  STD_LOGIC;
           done	: out STD_LOGIC;
			  eye    : out STD_LOGIC;
			  counter : out STD_LOGIC;
			  F			: out STD_LOGIC_VECTOR (8 downto 0);
			  P 		: out STD_LOGIC_VECTOR (15 downto 0));
end top_multiplier;

architecture Behavioral of top_multiplier is
	component clock_divider	
		Port ( clk : in  STD_LOGIC;
				reset : in  STD_LOGIC;
			   clk_100Hz : buffer  STD_LOGIC);
	end component;
	--component declaration of Add
	component adder
		port(
				a : in  std_logic_vector(7 downto 0);
				b : in  std_logic_vector(7 downto 0);
				s : out std_logic_vector(8 downto 0)
			);
	end component;
	------------------------------
	--component declaration of and1x8
	component ander
		port(
			a : in  std_logic;
			b : in  std_logic_vector(7 downto 0);
			s : out std_logic_vector(7 downto 0)
		);
	end component;
	------------------------------
	--component declaration of controller
	component controller
		port(
			-- External signals
			clk   : in  std_logic;
			reset : in  std_logic;
			start : in  std_logic;
			done  : out std_logic;
			counter1 : out std_logic;
			-- Control signals
			load_multiplier   : out std_logic;
			shift_multiplier  : out std_logic;
			load_multiplicand : out std_logic;
			reset_product     : out std_logic; 
			load_product      : out std_logic; 
			shift_product     : out std_logic
		);
	end component;
	------------------------------
	--component declaration of multiplicand
	component mcand
		port(
			clk     : in  std_logic;
			load    : in  std_logic;
			datain  : in  std_logic_vector(7 downto 0);
			dataout : out std_logic_vector(7 downto 0)
		);
	end component;
	------------------------------
	--component declaration of multiplier
	component mlier
		port(
			clk         : in  std_logic;
			load        : in  std_logic;
			shift_right_m : in  std_logic;
			datain      : in  std_logic_vector(7 downto 0);
			dataout     : out std_logic
		);
	end component;
	------------------------------
	--component declaration of product
	component producter
		port(
			clk         : in  std_logic;
			reset       : in  std_logic;
			load        : in  std_logic;
			shift_right_p : in  std_logic;
			datain      : in  std_logic_vector(8 downto 0);
			dataout     : out std_logic_vector(15 downto 0)
		);
	end component;
	------------------------------

	signal load_mr ,clk_1		: std_logic;
	signal shift_mr 				: std_logic;
	signal multiplicand_load 	: std_logic;
	signal reset_product_top 	: std_logic;
	signal load_product_top 	: std_logic;
	signal shift_product_top 	: std_logic;
	signal multiplier0_top 		: std_logic;
	signal m 						: std_logic_vector(7 downto 0);
	signal mcand_out				: std_logic_vector(7 downto 0);
	signal product_out_h8_top 	: std_logic_vector(7 downto 0):="00000000";
	signal adder_out		 		: std_logic_vector(8 downto 0):="000000000";
	signal product_out 			: std_logic_vector(15 downto 0):="0000000000000000";
	signal and_out 				: std_logic_vector(7 downto 0);
	signal mr_out					: std_logic;
	signal A_con, B_con 			: std_logic_vector(7 downto 0);

	--signal A_in : std_logic_vector(6 downto 0):="0000000"; 
	--signal B_in : std_logic_vector(6 downto 0):="0000000"; 

	begin

	F(7 downto 0) <= and_out(6 downto 0) & mr_out;
	--A_con <= A_in & A;
	--B_con <= B_in & B;

	and8:	ander
		port map (
			a => mr_out,
			b => mcand_out,
			s => and_out
		);
		
	multand: mcand
		port map (
			clk     => clk_1,
			load    => multiplicand_load,
			datain  => B,
			dataout => mcand_out
		);
				
	adder1: adder
		port map (
				a => and_out,
				b => product_out_h8_top,
				s => adder_out
			);
			
	multer: mlier
		port map (
			clk           => clk_1,
			load          => load_mr,
			shift_right_m => shift_mr,
			datain        => A,
			dataout       => mr_out
		);	

	prod:	producter
		port map (
			clk        		 =>  clk_1,
			reset      		 =>  reset_product_top,
			load       		 =>  load_product_top,
			shift_right_p	 =>  shift_product_top,
			datain     	 	 =>  adder_out,
			dataout    		 =>  product_out
		);	
		
		
	control: controller
		port map (
			-- External signals
			clk   => clk_1,
			reset => reset,
			start => start,
			done  => done,
			counter1 => counter,
			
			-- Control signals
			load_multiplier   => load_mr,
			shift_multiplier  => shift_mr,
			load_multiplicand => multiplicand_load,
			reset_product     => reset_product_top, 
			load_product      => load_product_top, 
			shift_product     => shift_product_top		
		);

	product_out_h8_top <= product_out (15 downto 8);
	P <= product_out;

	--clk_divisor: clock_divider	
	--    Port map( clk => clk,
	--			reset => reset,
	--           clk_100Hz => clk_1);
	--			  
	--eye <= clk_1;
	clk_1 <= clk;


end Behavioral;