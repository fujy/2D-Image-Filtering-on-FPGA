--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:10:11 12/03/2015
-- Design Name:   
-- Module Name:   /home/student/workspace_Xilinx/lena1/kernel_tb.vhd
-- Project Name:  lena1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: kernel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY kernel_tb IS
END kernel_tb;
 
ARCHITECTURE behavior OF kernel_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT kernel
    PORT(
         IN1 : IN  std_logic_vector(7 downto 0);
         IN2 : IN  std_logic_vector(7 downto 0);
         IN3 : IN  std_logic_vector(7 downto 0);
         IN4 : IN  std_logic_vector(7 downto 0);
         IN5 : IN  std_logic_vector(7 downto 0);
         IN6 : IN  std_logic_vector(7 downto 0);
         IN7 : IN  std_logic_vector(7 downto 0);
         IN8 : IN  std_logic_vector(7 downto 0);
         IN9 : IN  std_logic_vector(7 downto 0);
         EN : IN  std_logic;
         m1 : IN  signed(3 downto 0);
         m2 : IN  signed(3 downto 0);
         m3 : IN  signed(3 downto 0);
         m4 : IN  signed(3 downto 0);
         m5 : IN  signed(3 downto 0);
         m6 : IN  signed(3 downto 0);
         m7 : IN  signed(3 downto 0);
         m8 : IN  signed(3 downto 0);
         m9 : IN  signed(3 downto 0);
         divider_selector : IN  std_logic;
         OP : OUT  std_logic_vector(7 downto 0);
         RESET : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IN1 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN2 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN3 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN4 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN5 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN6 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN7 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN8 : std_logic_vector(7 downto 0) := (others => '0');
   signal IN9 : std_logic_vector(7 downto 0) := (others => '0');
   signal EN : std_logic := '0';
   signal m1 : signed(3 downto 0) := (others => '0');
   signal m2 : signed(3 downto 0) := (others => '0');
   signal m3 : signed(3 downto 0) := (others => '0');
   signal m4 : signed(3 downto 0) := (others => '0');
   signal m5 : signed(3 downto 0) := (others => '0');
   signal m6 : signed(3 downto 0) := (others => '0');
   signal m7 : signed(3 downto 0) := (others => '0');
   signal m8 : signed(3 downto 0) := (others => '0');
   signal m9 : signed(3 downto 0) := (others => '0');
   signal divider_selector : std_logic := '0';
   signal RESET : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal OP : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: kernel PORT MAP (
          IN1 => IN1,
          IN2 => IN2,
          IN3 => IN3,
          IN4 => IN4,
          IN5 => IN5,
          IN6 => IN6,
          IN7 => IN7,
          IN8 => IN8,
          IN9 => IN9,
          EN => EN,
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
          OP => OP,
          RESET => RESET,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
		wait for clk_period * 5;
		reset <= '0';
		EN <= '1';		
		m1 <= "1111";
		m2 <= "1110";
		m3 <= "1111";
		m4 <= x"0";
		m5 <= x"0";
		m6 <= x"0";
		m7 <= x"1";
		m8 <= x"2";
		m9 <= x"1";
		wait for clk_period * 5;
		
		in1<=x"08";
		in2<=x"01";
		in3<=x"01";
		in4<=x"01";
		in5<=x"01";
		in6<=x"01";
		in7<=x"0c";
		in8<=x"31";
		in9<=x"11";
		wait for clk_period*1;
		
		in1<=x"02";
		in2<=x"02";
		in3<=x"02";
		in4<=x"02";
		in5<=x"02";
		in6<=x"02";
		in7<=x"02";
		in8<=x"02";
		in9<=x"02";
      
		wait for clk_period*1;
		
		in1<=x"03";
		in2<=x"03";
		in3<=x"03";
		in4<=x"03";
		in5<=x"07";
		in6<=x"03";
		in7<=x"03";
		in8<=x"03";
		in9<=x"03";
		
		wait for clk_period*1;
		
		in1<="11111111";
		in2<="11111111";
		in3<="11111111";
		in4<="11111111";
		in5<="11111110";
		in6<="11111111";
		in7<="11111111";
		in8<="11111111";
		in9<="11111111";
		
		wait for clk_period*1;
		
		in1<="11111111";
		in2<="11111111";
		in3<="11111111";
		in4<="11111111";
		in5<="11111110";
		in6<=x"22";
		in7<=x"22";
		in8<=x"0a";
		in9<=x"0a";
		
		wait for clk_period*1;
		
		in1<=x"f2";
		in2<=x"02";
		in3<=x"33";
		in4<=x"aa";
		in5<=x"bb";
		in6<=x"bc";
		in7<=x"23";
		in8<=x"2a";
		in9<=x"1a";


      wait for clk_period * 20;
		assert false report "NONE. End of your simulation." severity failure;
   end process;

END;
