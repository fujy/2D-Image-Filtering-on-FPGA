----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:53 11/29/2014 
-- Design Name: 
-- Module Name:    AudioProject - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
library unisim;
use unisim.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DataFlow_Display is
Port (  
		clk_i       		: in  std_logic;
      rst_i       		: in  std_logic;
		wr_en_fifo_orig	: in  std_logic;
		fifo_empty_orig	: out std_logic;
		data_orig			: in std_logic_vector (7 downto 0);
		wr_en_fifo_proc	: in  std_logic;
		fifo_empty_proc	: out std_logic;
		data_proc			: in std_logic_vector (7 downto 0);
		data_fifo_orig_ready : IN std_logic;
		data_fifo_proc_ready : IN std_logic;		
		Switch_start  		: in std_logic;
		vga_hs_o       	: out std_logic;
      vga_vs_o       	: out std_logic;
      vga_red_o      	: out std_logic_vector(3 downto 0);
      vga_blue_o     	: out std_logic_vector(3 downto 0);
      vga_green_o    	: out std_logic_vector(3 downto 0)
		
		);
end DataFlow_Display;

architecture DataFlow_Display_arch of DataFlow_Display is

COMPONENT fifo_imag_9b_16700
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    prog_full_thresh : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT Vga_df
PORT(
	CLK_I : IN std_logic;
	pxl_clk_O : out STD_LOGIC;
	
   fifo_full_orig : IN STD_LOGIC;
   fifo_empty_orig : IN STD_LOGIC;
   fifo_prog_full_orig : IN STD_LOGIC;
	rd_en_fifo_orig : OUT STD_LOGIC;
	fifo_orig_out	: IN STD_LOGIC_VECTOR (8 downto 0);
	
	fifo_full_proc : IN STD_LOGIC;
   fifo_empty_proc : IN STD_LOGIC;
   fifo_prog_full_proc : IN STD_LOGIC;
	rd_en_fifo_proc : OUT STD_LOGIC;
	fifo_proc_out	: IN STD_LOGIC_VECTOR (8 downto 0);
	
	data_fifo_orig_ready : IN std_logic;
	data_fifo_proc_ready : IN STD_LOGIC;
	
	VGA_HS_O : OUT std_logic;
	VGA_VS_O : OUT std_logic;
	VGA_RED_O : OUT std_logic_vector(3 downto 0);
	VGA_GREEN_O : OUT std_logic_vector(3 downto 0);
	VGA_BLUE_O : OUT std_logic_vector(3 downto 0)
	);
END COMPONENT;
		

--
-- SINGAL DECLERATION
--
signal fifo_prog_full_orig, fifo_prog_full_proc : std_logic;
signal rd_en_fifo_orig, rd_en_fifo_proc : std_logic;
signal fifo_empty_orig_t, fifo_empty_proc_t : std_logic;
signal fifo_full_orig, fifo_full_proc : std_logic;
signal fifo_orig_out, fifo_proc_out : std_logic_vector(8 downto 0);
signal din_orig, din_proc : std_logic_vector(8 downto 0);
signal clk_int, pxl_clk_O    : std_logic;

begin

fifo_empty_orig <= fifo_empty_orig_t;
fifo_empty_proc <= fifo_empty_proc_t;

din_orig <= ('0'& data_orig);
din_proc <= ('0'& data_proc);
--data_int <= data_int_temp;
				
--
-- USER CHOICE OPTION
--



fifo_orig : fifo_imag_9b_16700
  PORT MAP (
    rst => rst_i,
	 wr_clk => clk_i,
    rd_clk => pxl_clk_O,
    din => din_orig,
    wr_en => wr_en_fifo_orig,
    rd_en => rd_en_fifo_orig,
    prog_full_thresh => "111111000000000",
    dout => fifo_orig_out,
    full => fifo_full_orig,
    empty => fifo_empty_orig_t,
    prog_full => fifo_prog_full_orig
  ); 


fifo_proc : fifo_imag_9b_16700
  PORT MAP (
    rst => rst_i,
	 wr_clk => clk_i,
    rd_clk => pxl_clk_O,
    din => din_proc,
    wr_en => wr_en_fifo_proc,
    rd_en => rd_en_fifo_proc,
    prog_full_thresh => "111111000000000",
    dout => fifo_proc_out,
    full => fifo_full_proc,
    empty => fifo_empty_proc_t,
    prog_full => fifo_prog_full_proc
  );		
--------------------------------------------------------		
--
-- VGA INSTANT		
--	
	   Inst_VGA: Vga_df
		port map(
      clk_i          		=> clk_i,
		pxl_clk_O				=> pxl_clk_O,
		
		fifo_full_orig 		=> fifo_full_orig,
		fifo_empty_orig		=> fifo_empty_orig_t,
		fifo_prog_full_orig 	=> fifo_prog_full_orig,
		rd_en_fifo_orig 		=> rd_en_fifo_orig,
		fifo_orig_out			=> fifo_orig_out,
		
		fifo_full_proc 		=> fifo_full_proc,
		fifo_empty_proc 		=> fifo_empty_proc_t,
		fifo_prog_full_proc 	=> fifo_prog_full_proc,
		rd_en_fifo_proc 		=> rd_en_fifo_proc,
		fifo_proc_out			=> fifo_proc_out,
		
		data_fifo_orig_ready => data_fifo_orig_ready,
		data_fifo_proc_ready => data_fifo_proc_ready,
		
      vga_hs_o       		=> vga_hs_o,
      vga_vs_o       		=> vga_vs_o,
      vga_red_o      		=> vga_red_o,
      vga_blue_o     		=> vga_blue_o,
      vga_green_o    		=> vga_green_o
      
--      MIC_M_DATA_I   => pdm_data_i,
--      MIC_M_CLK_RISING => pdm_clk_o,
--		MIC_M_CLK_RISING_OP => clk_slow,
--		MIC_M_DATA_I_OP => mono_out 
     
      );
		

end DataFlow_Display_arch;

