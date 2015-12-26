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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Imag_Proc_top is
    Port (  clk_i       : in  std_logic;
      rst_i       : in  std_logic;
      
		-- LED
		LED			: out std_logic_vector(15 downto 0);
		-- VGA STUFF
		vga_hs_o       : out std_logic;
      vga_vs_o       : out std_logic;
      vga_red_o      : out std_logic_vector(3 downto 0);
      vga_blue_o     : out std_logic_vector(3 downto 0);
      vga_green_o    : out std_logic_vector(3 downto 0);
		
		-- Switches
		ISEcho      : in std_logic;
		ISRealFreq  : in std_logic;
		ISPureFreq  : in std_logic;
		ISFIFO	   : in std_logic;
--		audio_write : in std_logic;
--		audio_read  : in std_logic;
		ISFast      : in std_logic;
		ISSlow      : in std_logic;
		ISVolUp		: in std_logic;
		ISVolDown   : in std_logic;
		ISSiren     : in std_logic;
		ISMusic     : in std_logic;
		FILTER_SEL: std_logic_vector (2 downto 0)
		);
end Imag_Proc_top;

architecture Imag_Proc_top_arch of Imag_Proc_top is

COMPONENT imgRom_pixGL8b
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT DataFlow_Display
PORT(
	clk_i : IN std_logic;
	rst_i : IN std_logic;
	wr_en_fifo_orig : IN std_logic;
	data_orig : IN std_logic_vector(7 downto 0);
	wr_en_fifo_proc : IN std_logic;
	data_proc : IN std_logic_vector(7 downto 0);
	data_fifo_orig_ready : IN std_logic;
	data_fifo_proc_ready : IN std_logic;
	Switch_start : IN std_logic;          
	fifo_empty_orig : OUT std_logic;
	fifo_empty_proc : OUT std_logic;
	vga_hs_o : OUT std_logic;
	vga_vs_o : OUT std_logic;
	vga_red_o : OUT std_logic_vector(3 downto 0);
	vga_blue_o : OUT std_logic_vector(3 downto 0);
	vga_green_o : OUT std_logic_vector(3 downto 0)
	);
END COMPONENT;

COMPONENT ImageFilter 
Port (din : in  std_logic_vector(7 downto 0);
		clk : in  std_logic;
		reset : in  std_logic;
		m1 : in signed(3 downto 0);
		m2 : in signed(3 downto 0);
		m3 : in signed(3 downto 0);
		m4 : in signed(3 downto 0);
		m5 : in signed(3 downto 0);
		m6 : in signed(3 downto 0);
		m7 : in signed(3 downto 0);
		m8 : in signed(3 downto 0);
		m9 : in signed(3 downto 0);
		divider_selector: in std_logic;
		WR_EN: IN STD_LOGIC;
		RD_EN: OUT STD_LOGIC;
		dout : out  std_logic_vector (7 downto 0));
END COMPONENT;

--
-- SINGAL DECLERATION
--
signal data_lena_orig : std_logic_vector(7 downto 0);
signal wr_en_fifo_orig : std_logic;
signal fifo_empty_orig : std_logic;
signal wr_en_fifo_proc : std_logic;
signal fifo_empty_proc : std_logic;
signal Switch_start : std_logic;
signal clk_int    : std_logic;
signal data_fifo_orig_ready: std_logic;
signal data_fifo_proc_ready: std_logic;

signal ena : STD_LOGIC;
signal addra : STD_LOGIC_VECTOR(13 DOWNTO 0);

signal filter_out: STD_LOGIC_VECTOR(7 downto 0);
signal filter_wr_en: STD_LOGIC;
signal filter_rd_en: STD_LOGIC;

-- Delta filter
constant delta1 : signed(3 downto 0):=x"0";
constant delta2 : signed(3 downto 0):=x"0";
constant delta3 : signed(3 downto 0):=x"0";
constant delta4 : signed(3 downto 0):=x"0";
constant delta5 : signed(3 downto 0):=x"8";
constant delta6 : signed(3 downto 0):=x"0";
constant delta7 : signed(3 downto 0):=x"0";
constant delta8 : signed(3 downto 0):=x"0";
constant delta9 : signed(3 downto 0):=x"0";

-- Bluring Filter
constant blur1 : signed(3 downto 0):=x"1";
constant blur2 : signed(3 downto 0):=x"1";
constant blur3 : signed(3 downto 0):=x"1";
constant blur4 : signed(3 downto 0):=x"1";
constant blur5 : signed(3 downto 0):=x"0";
constant blur6 : signed(3 downto 0):=x"1";
constant blur7 : signed(3 downto 0):=x"1";
constant blur8 : signed(3 downto 0):=x"1";
constant blur9 : signed(3 downto 0):=x"1";

-- Sobel Horizontal
constant sobel_hz1 : signed(3 downto 0):="1111";
constant sobel_hz2 : signed(3 downto 0):="1110";
constant sobel_hz3 : signed(3 downto 0):="1111";
constant sobel_hz4 : signed(3 downto 0):=x"0";
constant sobel_hz5 : signed(3 downto 0):=x"0";
constant sobel_hz6 : signed(3 downto 0):=x"0";
constant sobel_hz7 : signed(3 downto 0):=x"1";
constant sobel_hz8 : signed(3 downto 0):=x"2";
constant sobel_hz9 : signed(3 downto 0):=x"1";

-- Sobel Vertical
constant sobel_vr1 : signed(3 downto 0):="1111";
constant sobel_vr2 : signed(3 downto 0):=x"0";
constant sobel_vr3 : signed(3 downto 0):="0001";
constant sobel_vr4 : signed(3 downto 0):="1110";
constant sobel_vr5 : signed(3 downto 0):=x"0";
constant sobel_vr6 : signed(3 downto 0):=x"2";
constant sobel_vr7 : signed(3 downto 0):="1111";
constant sobel_vr8 : signed(3 downto 0):=x"0";
constant sobel_vr9 : signed(3 downto 0):=x"1";

-- Laplacian
constant laplace1 : signed(3 downto 0):=x"0";
constant laplace2 : signed(3 downto 0):="1111";
constant laplace3 : signed(3 downto 0):=x"0";
constant laplace4 : signed(3 downto 0):="1111";
constant laplace5 : signed(3 downto 0):=x"4";
constant laplace6 : signed(3 downto 0):="1111";
constant laplace7 : signed(3 downto 0):=x"0";
constant laplace8 : signed(3 downto 0):="1111";
constant laplace9 : signed(3 downto 0):=x"0";

signal m1 : signed(3 downto 0);
signal m2 : signed(3 downto 0);
signal m3 : signed(3 downto 0);
signal m4 : signed(3 downto 0);
signal m5 : signed(3 downto 0);
signal m6 : signed(3 downto 0);
signal m7 : signed(3 downto 0);
signal m8 : signed(3 downto 0);
signal m9 : signed(3 downto 0);
signal divider_selector: std_logic;

type LIST_STATE is (S1,S2,S3);
signal STATEG : LIST_STATE;

begin


IBUFG_inst : IBUFG
   generic map (
      IBUF_LOW_PWR => TRUE,
     IOSTANDARD => "DEFAULT")
   port map (
      O => clk_int,
      I => clk_i);
		
filter: ImageFilter PORT MAP(
	din => data_lena_orig,
	clk => clk_int,
	reset => rst_i,
	m1 => m1,
	m2 => m2,
	m3 => m3,
	m4 => m4,
	m5 => m5,
	m6 => m6,
	m7 => m7,
	m8 => m8,
	m9 => m9,
	WR_EN => filter_wr_en,
	RD_EN => filter_rd_en,
	divider_selector => divider_selector,
	dout => filter_out
);
		
Inst_DataFlow_Display: DataFlow_Display PORT MAP(
	clk_i => clk_int,
	rst_i => rst_i,
	wr_en_fifo_orig => wr_en_fifo_orig,
	fifo_empty_orig => fifo_empty_orig,
	data_orig => data_lena_orig,
	wr_en_fifo_proc => filter_rd_en,
	fifo_empty_proc => fifo_empty_proc,
	data_proc => filter_out,
	data_fifo_orig_ready => data_fifo_orig_ready,
	data_fifo_proc_ready => data_fifo_proc_ready, 
	Switch_start => Switch_start,
	vga_hs_o => vga_hs_o,
	vga_vs_o => vga_vs_o,
	vga_red_o => vga_red_o,
	vga_blue_o => vga_blue_o,
	vga_green_o => vga_green_o
);

LED(0) <= fifo_empty_orig;
LED(1) <= '1';
LED(2) <= fifo_empty_proc;
LED(3) <= rst_i;


LED(6) <= '0';
LED(7) <= '0';
LED(8) <= '0';
LED(9) <= '0';
LED(10) <= '0';
LED(11) <= '0';
LED(12) <= '0';
LED(13) <= '0';
LED(14) <= '0';
LED(15) <= '0';

img_lena_8bits : imgRom_pixGL8b
  PORT MAP (
    clka => clk_int,
    ena => ena,
    addra => addra,
    douta => data_lena_orig
  );

connection : process (clk_int, rst_i)
variable counter : integer := 0;
begin
 if (rst_i = '1') then STATEG <= S1; addra <= (others => '0'); 
 ena <= '0';LED(4) <= '0';LED(5) <= '0';wr_en_fifo_orig <= '0';filter_wr_en <= '0';
 data_fifo_orig_ready <= '0'; data_fifo_proc_ready <= '0';
								
 elsif (clk_int'event and clk_int = '1') then
		case STATEG is
		when S1 =>
			LED(5) <= '0';
			data_fifo_orig_ready <= '0'; data_fifo_proc_ready <= '0';
			if (ISEcho = '1') then STATEG <= S2; ena <= '1';
			else STATEG <= S1; ena <= '0';
			end if;
		when S2 => 
			data_fifo_orig_ready <= '0'; data_fifo_proc_ready <= '0';
			if addra = "11111111111111" then addra <= (others => '0');ena <= '0'; STATEG <= S3;LED(4) <= '0';
			else addra <= addra + '1'; ena <= '1'; STATEG <= S2; wr_en_fifo_orig <= '1';filter_wr_en <= '1';LED(4) <= '1';
			end if;
		when S3 => 
			wr_en_fifo_orig <= '0'; filter_wr_en <= '0';
			data_fifo_orig_ready <= '1'; data_fifo_proc_ready <= '1';
			LED(5) <= '1';
			if fifo_empty_orig ='1' then STATEG <= S1;
			else STATEG <= S3;
			end if;
		when others =>
          STATEG <= S1;
          
      end case;
 end if;
end process connection;

kernel_selection_proc: process(clk_int, rst_i)
begin
	if (rst_i = '1') then
		m1 <= delta1;
		m2 <= delta2;
		m3 <= delta3;
		m4 <= delta4;
		m5 <= delta5;
		m6 <= delta6;
		m7 <= delta7;
		m8 <= delta8;
		m9 <= delta9;
		divider_selector <= '0';
	elsif (clk_int'event and clk_int = '1') then
		if ( FILTER_SEL = "001" ) then
			m1 <= blur1;
			m2 <= blur2;
			m3 <= blur3;
			m4 <= blur4;
			m5 <= blur5;
			m6 <= blur6;
			m7 <= blur7;
			m8 <= blur8;
			m9 <= blur9;
			divider_selector <= '0';
		elsif ( FILTER_SEL = "010") then
			m1 <= sobel_hz1;
			m2 <= sobel_hz2;
			m3 <= sobel_hz3;
			m4 <= sobel_hz4;
			m5 <= sobel_hz5;
			m6 <= sobel_hz6;
			m7 <= sobel_hz7;
			m8 <= sobel_hz8;
			m9 <= sobel_hz9;
			divider_selector <= '0';
		elsif ( FILTER_SEL = "011") then
			m1 <= sobel_vr1;
			m2 <= sobel_vr2;
			m3 <= sobel_vr3;
			m4 <= sobel_vr4;
			m5 <= sobel_vr5;
			m6 <= sobel_vr6;
			m7 <= sobel_vr7;
			m8 <= sobel_vr8;
			m9 <= sobel_vr9;
			divider_selector <= '0';
		elsif ( FILTER_SEL = "100") then
			m1 <= laplace1;
			m2 <= laplace2;
			m3 <= laplace3;
			m4 <= laplace4;
			m5 <= laplace5;
			m6 <= laplace6;
			m7 <= laplace7;
			m8 <= laplace8;
			m9 <= laplace9;
			divider_selector <= '1';
		else -- ( SEL = "00")
			m1 <= delta1;
			m2 <= delta2;
			m3 <= delta3;
			m4 <= delta4;
			m5 <= delta5;
			m6 <= delta6;
			m7 <= delta7;
			m8 <= delta8;
			m9 <= delta9;
			divider_selector <= '0';
		end if;
	end if;
end process;
  
end Imag_Proc_top_arch;

