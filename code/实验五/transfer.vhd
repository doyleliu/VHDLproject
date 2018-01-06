----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:11:18 12/16/2015 
-- Design Name: 
-- Module Name:    transfer - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity transfer is
port(clk: in std_logic;
		 coord_x: in std_logic_vector(6 downto 0); --0~95
		 coord_y: in std_logic_vector(5 downto 0); --0~53
		 color: out std_logic_vector(7 downto 0));
end transfer;


architecture Behavioral of transfer is

component p96X54
	port (
	clka: in std_logic;
	addra: in std_logic_vector(12 downto 0);
	douta: out std_logic_vector(7 downto 0));
end component;

signal addr: std_logic_vector(12 downto 0):="0000000000000";
signal dout: std_logic_vector(7 downto 0);

Begin
u1: p96X54 port map(
   clk,
	addr,
	dout
);
color<=dout;

process(clk)
	begin
	if rising_edge(clk) then
	addr<=('0' & coord_y & "000000")+("00" & coord_y & "00000")+("000000" & coord_x);
	end if;
	end process;

end Behavioral;


