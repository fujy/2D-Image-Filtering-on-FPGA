library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FlipFlop is

generic (Bus_Width : integer := 8);
    Port (D: IN STD_LOGIC_VECTOR (Bus_Width-1 downto 0);
			 Q: OUT STD_LOGIC_VECTOR (Bus_Width-1 downto 0);
			 CLK: IN STD_LOGIC;
			 EN: IN STD_LOGIC;
			 RESET: IN STD_LOGIC);
end FlipFlop;

architecture Behavioral of FlipFlop is

signal temp : STD_LOGIC_VECTOR (Bus_Width-1 downto 0) := (others => '0');

begin

proc: process (clk,reset)
begin

	if (reset ='1') then temp <= (others => '0');
	elsif rising_edge(clk)
	then
		if ( en = '1') then temp <= D;
		else temp <= (others => '0');
		end if;
	end if;

end process proc;

Q <= temp;

end Behavioral;

