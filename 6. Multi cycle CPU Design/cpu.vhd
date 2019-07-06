----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:16 10/11/2009 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
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

entity cpu is
    Port ( clk 		: in  STD_LOGIC;
           reset_n 	: in  STD_LOGIC;
           rddata 	: in  STD_LOGIC_VECTOR (31 downto 0);
           rstart 	: out  STD_LOGIC;
           address 	: out  STD_LOGIC_VECTOR (15 downto 0);
           wrdata 	: out  STD_LOGIC_VECTOR (31 downto 0);
           wstart 	: out  STD_LOGIC);
end cpu;

architecture Behavioral of cpu is
--components
component alu
	PORT(a 	: in STD_LOGIC_VECTOR(31 downto 0);
		 b 	: in STD_LOGIC_VECTOR(31 downto 0);
		 op : in STD_LOGIC_VECTOR(5 downto 0);
		 s 	: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component extend
	PORT(signed_out : IN STD_LOGIC;
		 imm16 : IN STD_LOGIC_VECTOR(15 downto 0);
		 imm32 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component ir
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 D : IN STD_LOGIC_VECTOR(31 downto 0);
		 Q : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component mux2x16
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(15 downto 0);
		 i1 : IN STD_LOGIC_VECTOR(15 downto 0);
		 o : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
end component;

component mux2x5
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(4 downto 0);
		 i1 : IN STD_LOGIC_VECTOR(4 downto 0);
		 o : OUT STD_LOGIC_VECTOR(4 downto 0)
	);
end component;

component mux2x32
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(31 downto 0);
		 i1 : IN STD_LOGIC_VECTOR(31 downto 0);
		 o : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component pc  -- The PC holds the address of the next instruction
   port(
		clk     : in  std_logic;
		reset_n : in  std_logic;
		en      : in  std_logic;
		sel_a   : in  std_logic;
		sel_imm : in  std_logic;
		add_imm : in  std_logic;
		imm     : in  std_logic_vector(15 downto 0);
		a       : in  std_logic_vector(15 downto 0);
		addr    : out std_logic_vector(31 downto 0)
	);
end component;

component controller --state machine of the CPU
	port(
		clk        : in  std_logic;
		reset_n    : in  std_logic;
		-- instruction opcode
		op         : in  std_logic_vector(5 downto 0);
		opx        : in  std_logic_vector(5 downto 0);
		-- activates branch condition
		branch_op  : out std_logic;
		-- immediate value sign extention
		imm_signed : out std_logic;
		-- instruction register enable
		ir_en      : out std_logic;
		-- PC control signals
		pc_add_imm : out std_logic;
		pc_en      : out std_logic;
		pc_sel_a   : out std_logic;
		pc_sel_imm : out std_logic;
		-- register file enable
		rf_wren    : out std_logic;
		-- multiplexers selections
		sel_addr   : out std_logic;
		sel_b      : out std_logic;
		sel_mem    : out std_logic;
		sel_pc     : out std_logic;
		sel_ra     : out std_logic;
		sel_rC     : out std_logic;
		-- write memory output
		rstart      : out std_logic;
		wstart      : out std_logic;
		-- alu op
		op_alu     : out std_logic_vector(5 downto 0)
	);	
end component;

component register_file
    Port ( clk 	: in  STD_LOGIC;
           aa 		: in  STD_LOGIC_VECTOR (4 downto 0);
           ab 		: in  STD_LOGIC_VECTOR (4 downto 0);
           aw 		: in  STD_LOGIC_VECTOR (4 downto 0);
           wren 	: in  STD_LOGIC;
           wrdata : in  STD_LOGIC_VECTOR (31 downto 0);
           a 		: out  STD_LOGIC_VECTOR (31 downto 0);
           b 		: out  STD_LOGIC_VECTOR (31 downto 0));
end component;

--internal signal declarations
signal	a :  STD_LOGIC_VECTOR(31 downto 0);
signal	alu_res :  STD_LOGIC_VECTOR(31 downto 0);
signal	aw :  STD_LOGIC_VECTOR(4 downto 0);
signal	b :  STD_LOGIC_VECTOR(31 downto 0);
signal	branch_op :  STD_LOGIC;
signal	branch_taken :  STD_LOGIC;
signal	imm :  STD_LOGIC_VECTOR(31 downto 0);
signal	imm_signed :  STD_LOGIC;
signal	instr :  STD_LOGIC_VECTOR(31 downto 0);
signal	ir_en :  STD_LOGIC;
signal	op_alu :  STD_LOGIC_VECTOR(5 downto 0);
signal	op_b :  STD_LOGIC_VECTOR(31 downto 0);
signal	pc_add_imm :  STD_LOGIC;
signal	pc_addr :  STD_LOGIC_VECTOR(31 downto 0);
signal	pc_en :  STD_LOGIC;
signal	pc_sel_a :  STD_LOGIC;
signal	pc_sel_imm :  STD_LOGIC;
signal	pc_wren :  STD_LOGIC;
signal	ra :  STD_LOGIC_VECTOR(4 downto 0);
signal	rf_wren :  STD_LOGIC;
signal	sel_addr :  STD_LOGIC;
signal	sel_b :  STD_LOGIC;
signal	sel_mem :  STD_LOGIC;
signal	sel_pc :  STD_LOGIC;
signal	sel_ra :  STD_LOGIC;
signal	sel_rC :  STD_LOGIC;
signal	wire_mux_out :  STD_LOGIC_VECTOR(4 downto 0);
signal	wire_pc :  STD_LOGIC;
signal	wire_mux_in :  STD_LOGIC_VECTOR(31 downto 0);
signal	wire_wrdata :  STD_LOGIC_VECTOR(31 downto 0);



begin

alu_0 : alu
PORT MAP(a => a,
		 b => op_b,
		 op => op_alu,
		 s => alu_res);

branch_taken <= branch_op AND alu_res(0);

controller_0 : controller
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 op => instr(5 downto 0),
		 opx => instr(16 downto 11),
		 branch_op => branch_op,
		 imm_signed => imm_signed,
		 ir_en => ir_en,
		 pc_add_imm => pc_add_imm,
		 pc_en => pc_wren,
		 pc_sel_a => pc_sel_a,
		 pc_sel_imm => pc_sel_imm,
		 rf_wren => rf_wren,
		 sel_addr => sel_addr,
		 sel_b => sel_b,
		 sel_mem => sel_mem,
		 sel_pc => sel_pc,
		 sel_ra => sel_ra,
		 sel_rC => sel_rC,
		 wstart => wstart,
		 rstart => rstart,
		 op_alu => op_alu);

extend_0 : extend
PORT MAP(signed_out => imm_signed,
		 imm16 => instr(21 downto 6),
		 imm32 => imm);

IR_0 : ir
PORT MAP(clk => clk,
		 enable => ir_en,
		 D => rddata,
		 Q => instr);

mux_addr : mux2x16
PORT MAP(sel => sel_addr,
		 i0 => pc_addr(15 downto 0),
		 i1 => alu_res(15 downto 0),
		 o => address);

mux_aw : mux2x5
PORT MAP(sel => sel_rC,
		 i0 => wire_mux_out,
		 i1 => instr(21 downto 17),
		 o => aw);

mux_b : mux2x32
PORT MAP(sel => sel_b,
		 i0 => imm,
		 i1 => b,
		 o => op_b);

mux_data : mux2x32
PORT MAP(sel => wire_pc,
		 i0 => alu_res,
		 i1 => wire_mux_in,
		 o => wire_wrdata);

mux_mem : mux2x32
PORT MAP(sel => sel_mem,
		 i0 => pc_addr,
		 i1 => rddata,
		 o => wire_mux_in);

mux_ra : mux2x5
PORT MAP(sel => sel_ra,
		 i0 => instr(26 downto 22),
		 i1 => ra,
		 o => wire_mux_out);

pc_en <= pc_wren OR branch_taken;

PC_0 : pc
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 en => pc_en,
		 sel_a => pc_sel_a,
		 sel_imm => pc_sel_imm,
		 add_imm => pc_add_imm,
		 a => a(15 downto 0),
		 imm => instr(21 downto 6),
		 addr => pc_addr);

wire_pc <= sel_pc OR sel_mem;

register_file_0 : register_file
PORT MAP(clk => clk,
		 wren => rf_wren,
		 aa => instr(31 downto 27),
		 ab => instr(26 downto 22),
		 aw => aw,
		 wrdata => wire_wrdata,
		 a => a,
		 b => b);
		 
wrdata <= b;

ra <= "11111";

end Behavioral;

