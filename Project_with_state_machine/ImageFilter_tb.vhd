LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY ImageFilter_tb IS
END ImageFilter_tb;
 
ARCHITECTURE behavior OF ImageFilter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ImageFilter 
    PORT(
         Din : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         RESET : IN  std_logic;
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
         Dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal Din : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
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
	signal WR_EN: std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(7 downto 0);
	signal RD_EN:  std_logic;
	
   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ImageFilter PORT MAP (
				Din => Din,
				CLK => CLK,
				RESET => RESET,
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
				WR_EN => WR_EN,
				RD_EN => RD_EN,
				Dout => Dout
        );

  -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	-- Reset process
	-- or in one line without using a process
	-- reset <= '1', '0' after 10 ns;
	rst_proc : process
	begin
		RESET <= '1';
		wait for clk_period * 5;
		RESET <= '0';
		wait for clk_period * 5;
		wait;
	end process;
	
	kernel_selection_proc: process
	variable FILTER_SEL: std_logic_vector (2 downto 0) := "000";
	begin
		wait for clk_period * 10;
		
		FILTER_SEL := "001";
		if ( FILTER_SEL = "001" ) then -- Blur Filter
			m1 <= x"1";
			m2 <= x"1";
			m3 <= x"1";
			m4 <= x"1";
			m5 <= x"0";
			m6 <= x"1";
			m7 <= x"1";
			m8 <= x"1";
			m9 <= x"1";
			divider_selector <= '0';
		elsif ( FILTER_SEL = "010") then -- Sobel Horizontal Filter
			m1 <= "1111";
			m2 <= "1110";
			m3 <= "1111";
			m4 <= x"0";
			m5 <= x"0";
			m6 <= x"0";
			m7 <= x"1";
			m8 <= x"2";
			m9 <= x"1";
			divider_selector <= '0';
		elsif ( FILTER_SEL = "011") then -- Sobel Vertical Filter
			m1 <= "1111";
			m2 <= x"0";
			m3 <= "0001";
			m4 <= "1110";
			m5 <= x"0";
			m6 <= x"2";
			m7 <= "1111";
			m8 <= x"0";
			m9 <= x"1";
			divider_selector <= '0';
		elsif ( FILTER_SEL = "100") then -- Sobel Laplacian Filter
			m1 <= x"0";
			m2 <= "1111";
			m3 <= x"0";
			m4 <= "1111";
			m5 <= x"4";
			m6 <= "1111";
			m7 <= x"0";
			m8 <= "1111";
			m9 <= x"0";
			divider_selector <= '1';
		else -- ( SEL = "00")
			m1 <= x"0";
			m2 <= x"0";
			m3 <= x"0";
			m4 <= x"0";
			m5 <= x"8";
			m6 <= x"0";
			m7 <= x"0";
			m8 <= x"0";
			m9 <= x"0";
			divider_selector <= '0';
		end if;
		
		wait;
	end process;

   -- Stimulus process
   stim_proc1: process
   FILE datain : text;
	variable linein : line;
	variable linein_var :std_logic_vector (7 downto 0);
   begin
		wait for clk_period * 10;
		
		wait for clk_period * 1;
		
		wr_en <= '1';
		file_open (datain,"Lena128x128g_8bits.dat", read_mode);
		while not endfile(datain) loop	
			readline (datain,linein);
			read (linein, linein_var);
			din <= linein_var;  --push 1 pixel/all of its 8 bits into queue
			wait for clk_period * 1;
		end loop;
		file_close (datain);
		wr_en <= '0';
--		prog_full_thresh <= "00" & x"02";
--		assert false report "NONE. End of your simulation." severity failure;
		wait;
   end process;
	
	stim_proc2: process
   FILE dataout : text;
	variable lineout : line;
	variable lineout_var :std_logic_vector (7 downto 0);
   begin
		wait for clk_period * 10;
		
		while rd_en = '0' loop
			wait for clk_period * 1;
		end loop;
		
		file_open (dataout,"Lena128x128g_8bits_o.dat", write_mode);
		while rd_en = '1' loop
			lineout_var := dout;
			write (lineout,lineout_var);
			writeline (dataout,lineout);
			wait for clk_period * 1;
		end loop;
		file_close (dataout);
		
		wait for clk_period * 10;
		assert false report "NONE. End of your simulation." severity failure;
		
   end process;

END;