----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:54:20 11/22/2016 
-- Design Name: 
-- Module Name:    divider - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divider is
Port ( clk : in STD_LOGIC;
		 btns : in STD_LOGIC;
		 dividend : in STD_LOGIC_VECTOR (3 downto 0);
		 divisor : in STD_LOGIC_VECTOR (3 downto 0);
		 quot : out STD_LOGIC_VECTOR (3 downto 0);
		 remain : out STD_LOGIC_VECTOR (3 downto 0)
		);
end divider;

architecture Behavioral of divider is
component clk_divider is
Port ( 
		clk_in : in STD_LOGIC;	
		clk_out : out STD_LOGIC;
		Blink: out STD_LOGIC
		);
end component;

component pulse is
Port (
		clk : in STD_LOGIC;
		btns : in STD_LOGIC;
		pulse : out STD_LOGIC
);
end component;

component Division is
Port (
		clk : in STD_LOGIC;
		btns : in STD_LOGIC;
		Blink : in STD_LOGIC;
		pulse : in STD_LOGIC;
		dividend : in STD_LOGIC_VECTOR (3 downto 0);
		divisor : in STD_LOGIC_VECTOR (3 downto 0);
		quot : out STD_LOGIC_VECTOR (3 downto 0);
		remain : out STD_LOGIC_VECTOR (3 downto 0)
		);
end component;

signal Blink,clk_out,pulse_out: STD_LOGIC;
begin
U1 : clk_divider port map (clk,clk_out,Blink);
U2 : pulse port map(clk_out,btns,pulse_out);
U3 : Division port map(clk_out,btns,Blink,pulse_out,dividend,divisor,quot,remain);


end Behavioral;

