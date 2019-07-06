----------------------------------------------------------------------------------
-- 
-- Create Date:    00:49:10 30/03/2019 
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
		address 							: in std_logic_vector(15 downto 0);
		wrdata 								: in std_logic_vector(31 downto 0);
		rddata 								: out std_logic_vector(31 downto 0)
		);

end sync_mem;

architecture Behavioral of sync_mem is

component decoder 
    Port ( addr 	: in  STD_LOGIC_VECTOR(15 downto 0);
           cs_ram 	: out  STD_LOGIC;		-- chip select RAM
           cs_rom 	: out  STD_LOGIC);		-- chip select ROM
end component;


component rom 
    Port ( clk_rom 		: in  STD_LOGIC;
		   cs_rom 		: in  STD_LOGIC;
           read_rom 	: in  STD_LOGIC;
           ad_rom 		: in  STD_LOGIC_VECTOR (12 downto 0);
           rddata 		: out  STD_LOGIC_VECTOR (31 downto 0));
end component;


component ram 
    port(
		clk_ram    	: in  std_logic;
		cs_ram      : in  std_logic;
		read_ram    : in  std_logic;
		write_ram   : in  std_logic;
		ad_ram		: in  std_logic_vector(12 downto 0);
		wrdata  	: in  std_logic_vector(31 downto 0);
		rddata  	: out std_logic_vector(31 downto 0));
end component;


signal clk_s, read_s, write_s 	: std_logic; 
signal cs_ram_s, cs_rom_s 		: std_logic; 
--signal address_s 										: std_logic_vector(15 downto 0);
signal rddata_s 										: std_logic_vector(31 downto 0);
signal wrdata_s 										: std_logic_vector(31 downto 0);

signal ram_sonuc, rom_sonuc : STD_LOGIC_VECTOR (31 downto 0);

begin

Decoder_c : decoder 
    Port map( 	addr 		=> address,
					cs_ram 	=> cs_ram_s,
					cs_rom	=> cs_rom_s);

Rom_c : rom 
    Port map( 		clk_rom  => clk,
					cs_rom  	=> cs_rom_s,
					read_rom	=> r_smem,
					ad_rom 	=> address(12 downto 0),
					rddata  	=> rom_sonuc);

Ram_c : ram 
    port map(
		clk_ram		=> clk,
		cs_ram		=> cs_ram_s,
		read_ram  	=> r_smem,
		write_ram  	=> w_smem,
		ad_ram 		=> address(12 downto 0),
		wrdata  	=> wrdata,
		rddata  	=> ram_sonuc);

    process(clk,cs_ram_s)
    begin
    
        if (clk = '1' and clk'event) then
            if (cs_ram_s = '1') then
                rddata <= ram_sonuc;
            else
                rddata <= rom_sonuc;
            end if;
        end if;
    
    end process;

--rddata <= ram_sonuc when cs_ram_s = '1' else
--          rom_sonuc;
        

end Behavioral;

