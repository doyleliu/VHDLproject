----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:06:59 12/16/2015 
-- Design Name: 
-- Module Name:    segment - Behavioral 
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

entity segment is
	port( number:in std_logic_vector(3 downto 0);
			an:out std_logic_vector(3 downto 0);
			seg:out std_logic_vector(6 downto 0));
end segment;

architecture Behavioral of segment is
-- choose the segment and show the mode number
begin
	process(number)
	begin
		an <= "1110";
		case number is
--			when "0000" => seg <= "0010010";
			when "0000" => seg <= "0011001";
			when "0001" => seg <= "1111001";
			when "0010" => seg <= "0100100";
			when "0011" => seg<= "0110000";
			when "1111" => seg<= "0010010";
			when others => seg <= "1111111";
		end case;
	end process;
end Behavioral;

