----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:07 11/13/2016 
-- Design Name: 
-- Module Name:    lib1 - Behavioral 
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

entity lib1 is
port(
		btnl : in STD_LOGIC;
		btnr : in STD_LOGIC;
		btns : in STD_LOGIC;
		clk : in STD_LOGIC;
		an : out STD_LOGIC_VECTOR(3 downto 0);
		seg : out STD_LOGIC_VECTOR(6 downto 0);
		led : out STD_LOGIC_VECTOR(3 downto 0)
	);
end lib1;

architecture Behavioral of lib1 is

component clk_devider is
port(
		iclk : in STD_LOGIC;
		oclk : out STD_LOGIC
	);
end component;

component pulse is
port(
		btnl : in STD_LOGIC;
		btnr : in STD_LOGIC;
		clk : in STD_LOGIC;
		sign_out : out STD_LOGIC;
		pulse_out : out STD_LOGIC
	);
end component;

component state_machine is
port(
		clk : in STD_LOGIC;
		input_s : in STD_LOGIC;
		pulse_in : in STD_LOGIC;
		rst : in STD_LOGIC;
		led : out STD_LOGIC_VECTOR(3 downto 0)
	);
end component;

component segment is
port(
		clk : in STD_LOGIC;
		pulse : in STD_LOGIC;
		sign : in STD_LOGIC;
		rst : in STD_LOGIC;
		an : out STD_LOGIC_VECTOR(3 downto 0);
		seg : out STD_LOGIC_VECTOR(6 downto 0)
	);
end component;

type state is (zero, one , two , three, four);--states that the project have
signal pr_state, nx_state : state;
signal clk_divided : STD_LOGIC;
signal sig,pul : STD_LOGIC;
--pulse is determined whether there are inputs while signal is determined whether the input is '0' or '1';
begin
U1 : clk_devider port map(clk,clk_divided);
U2 : pulse port map(btnl,btnr,clk_divided,sig,pul);
U3 : state_machine port map(clk_divided,sig,pul,btns,led);
U4 : segment port map(clk_divided,pul,sig,btns,an,seg);

end Behavioral;