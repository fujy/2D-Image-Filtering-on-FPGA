----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:50:28 11/26/2015 
-- Design Name: 
-- Module Name:    kernel - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kernel is
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
		EN: in std_logic;
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
		OP : out std_logic_vector(7 downto 0);
		RESET : in std_logic;
		clk : in std_logic
	  );
end kernel;

architecture Behavioral of kernel is

component FlipFlop
	generic (Bus_Width: integer := 8);
	port (D: IN STD_LOGIC_VECTOR (Bus_Width-1 downto 0); 
		Q: OUT STD_LOGIC_VECTOR (Bus_Width-1 downto 0);
		CLK: IN STD_LOGIC;
		EN: IN STD_LOGIC;
		RESET: IN STD_LOGIC);
end component;

signal add12 : signed(13 downto 0);
signal add34 : signed(13 downto 0);
signal add56 : signed(13 downto 0);
signal add78 : signed(13 downto 0);
signal add1234 : signed(14 downto 0);
signal add5678 : signed(14 downto 0);
signal add12345678 : signed(15 downto 0);
signal add123456789 : signed(16 downto 0);
signal absRes : signed(16 downto 0);

signal c1 : signed(12 downto 0);
signal c2 : signed(12 downto 0);
signal c3 : signed(12 downto 0);
signal c4 : signed(12 downto 0);
signal c5 : signed(12 downto 0);
signal c6 : signed(12 downto 0);
signal c7 : signed(12 downto 0);
signal c8 : signed(12 downto 0);
signal c9 : signed(12 downto 0);

-- first stage
signal cc1: std_logic_vector(12 downto 0);
signal cc2: std_logic_vector(12 downto 0);
signal cc3: std_logic_vector(12 downto 0);
signal cc4: std_logic_vector(12 downto 0);
signal cc5: std_logic_vector(12 downto 0);
signal cc6: std_logic_vector(12 downto 0);
signal cc7: std_logic_vector(12 downto 0);
signal cc8: std_logic_vector(12 downto 0);
signal cc9: std_logic_vector(12 downto 0);

signal FF91: std_logic_vector(12 downto 0);
signal FF92: std_logic_vector(12 downto 0);
signal FF93: std_logic_vector(12 downto 0);

-------------------------------------------------------

signal temp12 : std_logic_vector(13 downto 0);
signal temp34 : std_logic_vector(13 downto 0);


signal temp56 : std_logic_vector(13 downto 0);
signal temp78 : std_logic_vector(13 downto 0);


signal temp1234 : std_logic_vector(14 downto 0);
signal temp5678 : std_logic_vector(14 downto 0);

signal temp12345678 : std_logic_vector(15 downto 0);

signal tempc9: std_logic_vector(12 downto 0);
signal tempc9tempc9 : std_logic_vector(12 downto 0);
signal tempc9tempc9tempc9 : std_logic_vector(12 downto 0);

begin
	--first stage
	extra1: FlipFlop generic map(13) port map(D => std_logic_vector(c1), Q => cc1, CLK => CLK, EN => EN, RESET => RESET);
	extra2: FlipFlop generic map(13) port map(D => std_logic_vector(c2), Q => cc2, CLK => CLK, EN => EN, RESET => RESET);
	extra3: FlipFlop generic map(13) port map(D => std_logic_vector(c3), Q => cc3, CLK => CLK, EN => EN, RESET => RESET);
	extra4: FlipFlop generic map(13) port map(D => std_logic_vector(c4), Q => cc4, CLK => CLK, EN => EN, RESET => RESET);
	extra5: FlipFlop generic map(13) port map(D => std_logic_vector(c5), Q => cc5, CLK => CLK, EN => EN, RESET => RESET);
	extra6: FlipFlop generic map(13) port map(D => std_logic_vector(c6), Q => cc6, CLK => CLK, EN => EN, RESET => RESET);
	extra7: FlipFlop generic map(13) port map(D => std_logic_vector(c7), Q => cc7, CLK => CLK, EN => EN, RESET => RESET);
	extra8: FlipFlop generic map(13) port map(D => std_logic_vector(c8), Q => cc8, CLK => CLK, EN => EN, RESET => RESET);
	extra9: FlipFlop generic map(13) port map(D => std_logic_vector(c9), Q => cc9, CLK => CLK, EN => EN, RESET => RESET);

	--sum12: FlipFlop generic map(14) port map(D => std_logic_vector(add12), Q => temp12, CLK => CLK, EN => EN, RESET => RESET);
	--sum34: FlipFlop generic map(14) port map(D => std_logic_vector(add34), Q => temp34, CLK => CLK, EN => EN, RESET => RESET);
	--sum56: FlipFlop generic map(14) port map(D => std_logic_vector(add56), Q => temp56, CLK => CLK, EN => EN, RESET => RESET);
	--sum78: FlipFlop generic map(14) port map(D => std_logic_vector(add78), Q => temp78, CLK => CLK, EN => EN, RESET => RESET);

	--sum1234: FlipFlop generic map(15) port map(D => std_logic_vector(add1234), Q => temp1234, CLK => CLK, EN => EN, RESET => RESET);
	--sum5678: FlipFlop generic map(15) port map(D => std_logic_vector(add5678), Q => temp5678, CLK => CLK, EN => EN, RESET => RESET);

	--sum12345678: FlipFlop generic map(16) port map(D => std_logic_vector(add12345678), Q => temp12345678, CLK => CLK, EN => EN, RESET => RESET);

	extraFF9a: FlipFlop generic map(13) port map(D => std_logic_vector(cc9), Q => FF91, CLK => CLK, EN => EN, RESET => RESET);
	extraFF9b: FlipFlop generic map(13) port map(D => std_logic_vector(FF91), Q => FF92, CLK => CLK, EN => EN, RESET => RESET);
	extraFF9c: FlipFlop generic map(13) port map(D => std_logic_vector(FF92), Q => tempc9tempc9tempc9, CLK => CLK, EN => EN, RESET => RESET);
--	extra9a: FlipFlop generic map(13) port map(D => std_logic_vector(FF93), Q => tempc9tempc9tempc9, CLK => CLK, EN => EN, RESET => RESET);
--	extra9b: FlipFlop generic map(13) port map(D => std_logic_vector(tempc9), Q => tempc9tempc9, CLK => CLK, EN => EN, RESET => RESET);
--	extra9c: FlipFlop generic map(13) port map(D => std_logic_vector(tempc9tempc9), Q => tempc9tempc9tempc9, CLK => CLK, EN => EN, RESET => RESET);
	

	add_proc: process(CLK)
	begin
		if rising_edge(CLK) then
			c1 <= m1*signed("0" & in1);
			c2 <= m2*signed("0" & in2);
			c3 <= m3*signed("0" & in3);
			c4 <= m4*signed("0" & in4);
			c5 <= m5*signed("0" & in5);
			c6 <= m6*signed("0" & in6);
			c7 <= m7*signed("0" & in7);
			c8 <= m8*signed("0" & in8);
			c9 <= m9*signed("0" & in9);

			add12 <= (cc1(cc1'left) & signed(cc1)) + (cc2(cc2'left) & signed(cc2));  
			add34 <= (cc3(cc3'left) & signed(cc3)) + (cc4(cc4'left) & signed(cc4));
			add56 <= (cc5(cc5'left) & signed(cc5)) + (cc6(cc6'left) & signed(cc6));
			add78 <= (cc7(cc7'left) & signed(cc7)) + (cc8(cc8'left) & signed(cc8));

			add1234 <= (add12(add12'left) & signed(add12)) + (add34(add34'left) & signed(add34));
			add5678 <= (add56(add56'left) & signed(add56)) + (add78(add78'left) & signed(add78));

			add12345678 <= (add1234(add1234'left) & signed(add1234)) + (add5678(add5678'left) & signed(add5678));

			add123456789 <= (add12345678(add12345678'left) & signed(add12345678)) + 
			(tempc9tempc9tempc9(tempc9tempc9tempc9'left) & tempc9tempc9tempc9(tempc9tempc9tempc9'left) & 
			tempc9tempc9tempc9(tempc9tempc9tempc9'left) & tempc9tempc9tempc9(tempc9tempc9tempc9'left) & 
			signed(tempc9tempc9tempc9));
		end if;
		
--		if falling_edge(clk) then
			absRes <= (abs(add123456789));
--		end if;
		
	end process;
	
	
	
	OP <= std_logic_vector(absRes(9 downto 2)) when divider_selector = '1' else	
					std_logic_vector(absRes(10 downto 3));

end Behavioral;