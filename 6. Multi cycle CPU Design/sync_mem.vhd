----------------------------------------------------------------------------------
-- 
-- Create Date:    16:55:18 09/09/2009 
-- Design Name: 
-- Module Name:    sync_mem - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_mem is
	port(
		clk,    r_smem, w_smem,reset		: in std_logic;
		address 								: in std_logic_vector(15 downto 0);
		buttons 								: in std_logic_vector(3 downto 0);
		wrdata 								: in std_logic_vector(31 downto 0);
		rddata 								: out std_logic_vector(31 downto 0);
		dp  								: out  STD_LOGIC;
        sel 								: out  STD_LOGIC_VECTOR (3 downto 0);
        segment 							: out  STD_LOGIC_VECTOR (6 downto 0));

end sync_mem;

architecture Behavioral of sync_mem is

component decoder 
    Port ( addr 	: in  STD_LOGIC_VECTOR(15 downto 0);
           cs_di 	: out  STD_LOGIC;		-- chip select button
		   cs_do 	: out  STD_LOGIC;		-- chip select Seven Segment Display
           cs_ram 	: out  STD_LOGIC;		-- chip select RAM
           cs_rom 	: out  STD_LOGIC);		-- chip select ROM
end component;


component rom 
    Port ( cs_rom 		: in  STD_LOGIC;
           clk_rom 		: in  STD_LOGIC;
           read_rom 	: in  STD_LOGIC;
           ad_rom 		: in  STD_LOGIC_VECTOR (9 downto 0);
           rddata 		: out  STD_LOGIC_VECTOR (31 downto 0));
end component;


component ram 
    port(
		clk_ram    	: in  std_logic;
		cs_ram      : in  std_logic;
		read_ram    : in  std_logic;
		write_ram   : in  std_logic;
		ad_ram		: in  std_logic_vector(9 downto 0);
		wrdata  	: in  std_logic_vector(31 downto 0);
		rddata  	: out std_logic_vector(31 downto 0));
end component;

component seven_segment 
    port(
		clk, reset, r_disp, w_disp, cs_disp 	: in std_logic;
		address								: in std_logic_vector(1 downto 0);
		rddata  							: out std_logic_vector(31 downto 0);
		wrdata  							: in  std_logic_vector(31 downto 0);
		dp  								: out  STD_LOGIC;
        sel 								: out  STD_LOGIC_VECTOR (3 downto 0);
        segment 							: out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component button_cpu
    port(
		clk, reset, r_button, w_button, cs_button	: in std_logic;
		address										: in std_logic;
		rddata  									: out std_logic_vector(31 downto 0);
		wrdata  									: in  std_logic_vector(31 downto 0);
		buttons										: in std_logic_vector(3 downto 0)
	);
end component;

signal clk_s, read_s, write_s 					: std_logic; 
signal cs_di_s, cs_do_s, cs_ram_s, cs_rom_s 	: std_logic; 
--signal address_s 										: std_logic_vector(15 downto 0);
signal rddata_s 										: std_logic_vector(31 downto 0);
signal wrdata_s 										: std_logic_vector(31 downto 0);


begin

Decoder_c : decoder 
    Port map( 	addr 		=> address,
					cs_di 	=> cs_di_s,
					cs_do 	=> cs_do_s,
					cs_ram 	=> cs_ram_s,
					cs_rom	=> cs_rom_s);

Rom_c : rom 
    Port map( 	cs_rom  	=> cs_rom_s,
					clk_rom  => clk,
					read_rom	=> r_smem,
					ad_rom 	=> address(9 downto 0),
					rddata  	=> rddata);

Ram_c : ram 
    port map(
		clk_ram		=> clk,
		cs_ram		=> cs_ram_s,
		read_ram  	=> r_smem,
		write_ram  	=> w_smem,
		ad_ram 		=> address(9 downto 0),
		wrdata  		=> wrdata,
		rddata  		=> rddata);
		
		
Seven_Segment_Display : seven_segment 
    port map(
		clk => clk,
		reset => reset,
		r_disp => r_smem,
		w_disp => w_smem,
		cs_disp => cs_do_s,
		address => address(3 downto 2),
		rddata => rddata,
		wrdata => wrdata,
		dp  => dp,
        sel => sel,
        segment => segment 
		);		
		
Button_c : button_cpu
    port map(
		clk => clk_1,
		reset => reset,
		r_button => r_smem,
		w_button => w_smem,
		cs_button => cs_di_s,
		address => address(3),
		rddata => rddata,
		wrdata => wrdata,
		buttons =>  buttons );		


end Behavioral;

