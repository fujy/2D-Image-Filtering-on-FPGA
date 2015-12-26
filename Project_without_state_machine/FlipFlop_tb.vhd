--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:31:17 12/13/2015
-- Design Name:   
-- Module Name:   /home/student/workspace_Xilinx/lena1/FlipFlop_tb.vhd
-- Project Name:  lena1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FlipFlop
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
--USE ieee.numeric_std.ALL;
 
ENTITY FlipFlop_tb IS
END FlipFlop_tb;
 
ARCHITECTURE behavior OF FlipFlop_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FlipFlop
    PORT(
         D : IN  std_logic_vector(7 downto 0);
         Q : OUT  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         EN : IN  std_logic;
         RESET : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal D : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal EN : std_logic := '0';
   signal RESET : std_logic := '0';

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FlipFlop PORT MAP (
          D => D,
          Q => Q,
          CLK => CLK,
          EN => EN,
          RESET => RESET
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET <= '1';
      wait for 100 ns;	
		RESET <= '0';
      wait for CLK_period*10;

      EN <= '1';
		D <= x"FF";
		
		wait for clk_period * 20;
		assert false report "NONE. End of your simulation." severity failure;
		
   end process;

END;
