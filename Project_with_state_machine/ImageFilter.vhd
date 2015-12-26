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
				WR_EN: in std_logic;
				RD_EN: out std_logic;
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
	
	constant prog_full_thresh1 :  STD_LOGIC_VECTOR(9 downto 0) := "00" & x"7B";
	constant prog_full_thresh2 :  STD_LOGIC_VECTOR(9 downto 0) := "00" & x"7B";
	
	signal wr_en1 : std_logic := '0';
   signal rd_en1 : std_logic := '0';
	signal full1 : std_logic;
   signal empty1 : std_logic;
   signal prog_full1 : std_logic;
	
	signal wr_en2 : std_logic := '0';
   signal rd_en2 : std_logic := '0';
	signal full2 : std_logic;
   signal empty2 : std_logic;
   signal prog_full2 : std_logic;
	
	signal KWR_EN: std_logic;
	signal KRD_EN: std_logic;
	
	signal EN1: std_logic;
	signal EN2: std_logic;
	signal EN3: std_logic;
	
	signal ENF1: std_logic;
	
	signal EN4: std_logic;
	signal EN5: std_logic;
	signal EN6: std_logic;
	
	signal ENF2: std_logic;
	
	signal EN7: std_logic;
	signal EN8: std_logic;
	signal EN9: std_logic;
	
	type LIST_STATE is (S0,S1,S2);
	signal STATEG : LIST_STATE;

begin

	t_1: FlipFlop generic map (8) port map (D => Din, Q => temp1, CLK => CLK, EN => EN1, RESET => RESET);
	t_2: FlipFlop generic map (8) port map (D => temp1, Q => temp2, CLK => CLK, EN => EN2, RESET => RESET);
	t_3: FlipFlop generic map (8) port map (D => temp2, Q => temp3, CLK => CLK, EN => EN3, RESET => RESET);
	
	fif1: fifo port map(clk => clk,
          rst => RESET,
          din => temp3,
          wr_en => ENF1,
          rd_en => prog_full1,
          prog_full_thresh => prog_full_thresh1,
          dout =>temp4,
          full => full1,
          empty => empty1,
          prog_full => prog_full1);
			 
	t_4: FlipFlop generic map (8) port map (D => temp4, Q => temp5, CLK => CLK, EN => EN4, RESET => RESET);
	t_5: FlipFlop generic map (8) port map (D => temp5, Q => temp6, CLK => CLK, EN => EN5, RESET => RESET);
	t_6: FlipFlop generic map (8) port map (D => temp6, Q => temp7, CLK => CLK, EN => EN6, RESET => RESET);
	
	fif2: fifo port map(clk => clk,
          rst => RESET,
          din => temp7,
          wr_en => ENF2,
          rd_en => prog_full2,
          prog_full_thresh => prog_full_thresh2,
          dout =>temp8,
          full => full2,
          empty => empty2,
          prog_full => prog_full2);
			 
	t_7: FlipFlop generic map (8) port map (D => temp8, Q => temp9, CLK => CLK, EN => EN7, RESET => RESET);
	t_8: FlipFlop generic map (8) port map (D => temp9, Q => temp10, CLK => CLK, EN => EN8, RESET => RESET);
	t_9: FlipFlop generic map (8) port map (D => temp10, Q => temp11, CLK => CLK, EN => EN9, RESET => RESET);
	
	connection : process (CLK, RESET)
	begin
	 if (RESET = '1') then 
		STATEG <= S0;
		EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; ENF1 <= '0'; 
		EN4 <= '0'; EN5 <= '0'; EN6 <= '0'; ENF2 <= '0'; 
		EN7 <= '0'; EN8 <= '0'; EN9 <= '0'; 
	 elsif (CLK'event and CLK = '1') then
		case STATEG is
			when S0 =>
				if (WR_EN = '1') then 
					STATEG <= S1;
					EN1 <= '1'; EN2 <= '1'; EN3 <= '1'; ENF1 <= '1'; 
					EN4 <= '1'; EN5 <= '1'; EN6 <= '1'; ENF2 <= '1'; 
					EN7 <= '1'; EN8 <= '1'; EN9 <= '1'; 
				else 
					STATEG <= S0; KWR_EN <= '0';
				end if;
			when S1 => --  Kernel Delay State
				if (KRD_EN = '1') then STATEG <= S2;
				else STATEG <= S1; KWR_EN <= '1';
				end if;
			when S2 => --  Kernel Output State
				if (WR_EN = '0') then STATEG <= S0;
				else STATEG <= S2; KWR_EN <= '1';
				end if;
			when others =>
				 STATEG <= S0;
			end case;
		end if;
	end process connection;

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
		WR_EN => KWR_EN,
		RD_EN => KRD_EN,
		OP => Dout,
		RESET => RESET,
		clk => clk);
		
		RD_EN <= KRD_EN;
	
--	Dout <= temp11;

end Behavioral;

