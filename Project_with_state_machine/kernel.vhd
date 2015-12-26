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
signal absResTemp : std_logic_vector (7 downto 0);

signal c1 : signed(12 downto 0);
signal c2 : signed(12 downto 0);
signal c3 : signed(12 downto 0);
signal c4 : signed(12 downto 0);
signal c5 : signed(12 downto 0);
signal c6 : signed(12 downto 0);
signal c7 : signed(12 downto 0);
signal c8 : signed(12 downto 0);
signal c9 : signed(12 downto 0);


signal cc9: std_logic_vector(12 downto 0);
signal FF91: std_logic_vector(12 downto 0);
signal FF92: std_logic_vector(12 downto 0);

signal EN1, EN2, EN3: std_logic;

type LIST_STATE is (S1,S2,S3,S4,S5,S6,S7,S8,S9,S10);
signal STATEG : LIST_STATE;

begin
	
	extra91: FlipFlop generic map(13) port map(D => std_logic_vector(c9), Q => cc9, CLK => CLK, EN => EN1, RESET => RESET);
	extra92: FlipFlop generic map(13) port map(D => std_logic_vector(cc9), Q => FF91, CLK => CLK, EN => EN2, RESET => RESET);
	extra93: FlipFlop generic map(13) port map(D => std_logic_vector(FF91), Q => FF92, CLK => CLK, EN => EN3, RESET => RESET);

	connection : process (CLK, RESET)
	begin
	 if (RESET = '1') then 
		STATEG <= S1; EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '0';
	 elsif (CLK'event and CLK = '1') then
		case STATEG is
			when S1 =>
				if (WR_EN = '1') then STATEG <= S2; EN1 <= '1'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '0';
				else STATEG <= S1; EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '0';
				end if;
			when S2 =>
				STATEG <= S3; EN1 <= '1'; EN2 <= '1'; EN3 <= '0'; RD_EN <= '0';
			when S3 => 
				STATEG <= S4; EN1 <= '1'; EN2 <= '1'; EN3 <= '1'; RD_EN <= '0';
			when S4 => -- One Cycle Delay for the last addition
				STATEG <= S5; EN1 <= '1'; EN2 <= '1'; EN3 <= '1'; RD_EN <= '0';
			when S5 => -- One Cycle Delay for the division
				STATEG <= S6; EN1 <= '1'; EN2 <= '1'; EN3 <= '1'; RD_EN <= '0';
			when S6 => 
				if (WR_EN = '1') then STATEG <= S6; EN1 <= '1'; EN2 <= '1'; EN3 <= '1'; RD_EN <= '1';
				else STATEG <= S7; EN1 <= '0'; EN2 <= '1'; EN3 <= '1'; RD_EN <= '1';
				end if;
			when S7 => 
				STATEG <= S8; EN1 <= '0'; EN2 <= '0'; EN3 <= '1'; RD_EN <= '1';
			when S8 => 
				STATEG <= S9; EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '1';
			when S9 => -- One Cycle Delay for the last addition
				STATEG <= S10; EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '1';
			when S10 => -- One Cycle Delay for the division
				STATEG <= S1; EN1 <= '0'; EN2 <= '0'; EN3 <= '0'; RD_EN <= '1';
			when others =>
				 STATEG <= S1;
			end case;
		end if;
	end process connection;

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

			add12 <= (c1(c1'left) & signed(c1)) + (c2(c2'left) & signed(c2));  
			add34 <= (c3(c3'left) & signed(c3)) + (c4(c4'left) & signed(c4));
			add56 <= (c5(c5'left) & signed(c5)) + (c6(c6'left) & signed(c6));
			add78 <= (c7(c7'left) & signed(c7)) + (c8(c8'left) & signed(c8));

			add1234 <= (add12(add12'left) & signed(add12)) + (add34(add34'left) & signed(add34));
			add5678 <= (add56(add56'left) & signed(add56)) + (add78(add78'left) & signed(add78));

			add12345678 <= (add1234(add1234'left) & signed(add1234)) + (add5678(add5678'left) & signed(add5678));

			add123456789 <= abs((add12345678(add12345678'left) & signed(add12345678)) + 
			(FF92(FF92'left) & FF92(FF92'left) & FF92(FF92'left) & FF92(FF92'left) & signed(FF92)));
			
			case divider_selector is
				when '1'  => absResTemp <= std_logic_vector(add123456789(9 downto 2)) ;
				when others => absResTemp <= std_logic_vector(add123456789(10 downto 3)) ;
			end case;
			
		end if;
	end process;
	
	OP <= absResTemp;

end Behavioral;