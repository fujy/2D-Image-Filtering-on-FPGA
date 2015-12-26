----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:23 11/19/2015 
-- Design Name: 
-- Module Name:    ImageFilter - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ImageFilter is
Port (Din : IN  STD_LOGIC_VECTOR(7 downto 0);
		CLK : IN  STD_LOGIC;
		RESET : IN  STD_LOGIC;
		WR_EN: IN STD_LOGIC;
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
		RD_EN: OUT STD_LOGIC;
		Dout : OUT  STD_LOGIC_VECTOR (7 DOWNTO 0));
end ImageFilter;

architecture Behavioral of ImageFilter is

	component fifo
    port(
         clk : IN  std_logic;
         rst : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         wr_en : IN  std_logic;
         rd_en : IN  std_logic;
         prog_full_thresh : IN  std_logic_vector(9 downto 0);
         dout : OUT  std_logic_vector(7 downto 0);
         full : OUT  std_logic;
         almost_full : OUT  std_logic;
         empty : OUT  std_logic;
         prog_full : OUT  std_logic
        );
    end component;
	 
	component FlipFlop
		generic (Bus_Width: integer := 8);
		port (D: IN STD_LOGIC_VECTOR (Bus_Width-1 downto 0); 
				Q: OUT STD_LOGIC_VECTOR (Bus_Width-1 downto 0);
				CLK: IN STD_LOGIC;
				EN: IN STD_LOGIC;
				RESET: IN STD_LOGIC);
	end component;
	
	component kernel 
		port(
				IN1 : in std_logic_vector(7 downto 0);
				IN2 : in std_logic_vector(7 downto 0);
				IN3 : in std_logic_vector(7 downto 0);
				IN4 : in std_logic_vector(7 downto 0);
				IN5 : in std_logic_vector(7 downto 0);
				IN6 : in std_logic_vector(7 downto 0);
				IN7 : in std_logic_vector(7 downto 0);
				IN8 : in std_logic_vector(7 downto 0);
				IN9 : in std_logic_vector(7 downto 0);
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
				EN: in std_logic;
				OP : out std_logic_vector(7 downto 0);
				RESET : in std_logic;
				clk : in std_logic
			  );
	end component;
	
	signal temp1 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp2 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp3 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp4 : STD_LOGIC_VECTOR(7 downto 0);
	
	signal temp5 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp6 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp7 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp8 : STD_LOGIC_VECTOR(7 downto 0);
	
	signal temp9 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp10 : STD_LOGIC_VECTOR(7 downto 0);
	signal temp11 : STD_LOGIC_VECTOR(7 downto 0);
	
	constant prog_full_thresh0 :  STD_LOGIC_VECTOR(9 downto 0) := "00" & x"7B";
	constant prog_full_thresh1 :  STD_LOGIC_VECTOR(9 downto 0) := "00" & x"7B";
	
	signal wr_en0 : std_logic := '0';
   signal rd_en0 : std_logic := '0';
	signal full0 : std_logic;
   signal almost_full0 : std_logic;
   signal empty0 : std_logic;
   signal prog_full0 : std_logic;
	
	signal wr_en1 : std_logic := '0';
   signal rd_en1 : std_logic := '0';
	signal full1 : std_logic;
   signal almost_full1 : std_logic;
   signal empty1 : std_logic;
   signal prog_full1 : std_logic;

begin

	t_0: FlipFlop generic map (8) port map (D => Din, Q => temp1, CLK => CLK, EN => '1', RESET => RESET);
	t_1: FlipFlop generic map (8) port map (D => temp1, Q => temp2, CLK => CLK, EN => '1', RESET => RESET);
	t_2: FlipFlop generic map (8) port map (D => temp2, Q => temp3, CLK => CLK, EN => '1', RESET => RESET);
	
	fif0: fifo port map(clk => clk,
          rst => RESET,
          din => temp3,
          wr_en => '1',
          rd_en => prog_full0,
          prog_full_thresh => prog_full_thresh0,
          dout =>temp4,
          full => full0,
          almost_full => almost_full0,
          empty => empty0,
          prog_full => prog_full0);
			 
	t_3: FlipFlop generic map (8) port map (D => temp4, Q => temp5, CLK => CLK, EN => '1', RESET => RESET);
	t_4: FlipFlop generic map (8) port map (D => temp5, Q => temp6, CLK => CLK, EN => '1', RESET => RESET);
	t_5: FlipFlop generic map (8) port map (D => temp6, Q => temp7, CLK => CLK, EN => '1', RESET => RESET);
	
	fif1: fifo port map(clk => clk,
          rst => RESET,
          din => temp7,
          wr_en => '1',
          rd_en => prog_full1,
          prog_full_thresh => prog_full_thresh1,
          dout =>temp8,
          full => full1,
          almost_full => almost_full1,
          empty => empty1,
          prog_full => prog_full1);
			 
	t_6: FlipFlop generic map (8) port map (D => temp8, Q => temp9, CLK => CLK, EN => '1', RESET => RESET);
	t_7: FlipFlop generic map (8) port map (D => temp9, Q => temp10, CLK => CLK, EN => '1', RESET => RESET);
	t_8: FlipFlop generic map (8) port map (D => temp10, Q => temp11, CLK => CLK, EN => '1', RESET => RESET);
	
	rd_en_proc: process(CLK, RESET)
		variable counter : integer := 0;
	begin
		if (RESET = '1') then
			counter := 0;
			rd_en <= '0';
		elsif rising_edge(clk) then
			if (wr_en = '1') then
			  -- start change
				if (counter = 130+8) then
					rd_en <= '1';
				else
					counter := counter + 1;
				end if;
			end if;
			if (wr_en = '0') then
				if (counter = 0) then
					rd_en <= '0';
				else
					counter := counter - 1;
				end if;
			end if;
		end if;
	end process;

	kernel0: kernel port map (
		IN1 => temp11,
		IN2 => temp10,
		IN3 => temp9,
		IN4 => temp7,
		IN5 => temp6,
		IN6 => temp5,
		IN7 => temp3,
		IN8 => temp2,
		IN9 => temp1,
		m1 => m1,
		m2 => m2,
		m3 => m3,
		m4 => m4,
		m5 => m5,
		m6 => m6,
		m7 => m7,
		m8 => m8,
		m9 => m9,
		divider_selector => divider_selector,
		EN => '1',
		OP => Dout,
		RESET => RESET,
		clk => clk);
	
--	Dout <= temp11;

end Behavioral;

