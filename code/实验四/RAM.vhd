library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity RAM is
generic(
FIFO_Depth : integer :=16;
DataWidth : integer := 8;
AddrSize : integer :=  4
);
port(
WrData : in STD_LOGIC_VECTOR(DataWidth-1 downto 0);
Sys_Clk : in STD_LOGIC;
Sys_Rst : in STD_LOGIC;
Wr_en : in STD_LOGIC;
Wr_Addr : in INTEGER RANGE 0 TO 2**AddrSize-1;
RdData : out STD_LOGIC_VECTOR(DataWidth-1 downto 0);
Rd_en : in STD_LOGIC;
Rd_Addr : in INTEGER RANGE 0 TO 2**AddrSize-1
);
end RAM;

architecture Behavioral of RAM is
constant RAM_Depth : integer := 2**AddrSize;
Type ram_array is array(0 to RAM_Depth-1) of STD_LOGIC_VECTOR(DataWidth-1 downto 0);
signal memory : ram_array;

begin
--write procedure
process(Sys_Clk , Wr_en , Sys_Rst)
begin
if(Sys_Rst = '1') then
	for i in 0 to RAM_Depth-1 loop
-- for i in 0 to 2**AddrSize-1 loop
-- memory(i) <= '0';
	memory(i) <= (others => '0');--reset and wipe off all the data
	end loop;
elsif(Wr_en = '1') then-- write the data into the memory
	--elsif(rising_edge(Sys_Clk)) then
	if(Sys_Clk' event and Sys_Clk = '1') then
	memory(Wr_Addr) <= WrData;
	end if;
end if;
end process;

--read procedure
process(Sys_Clk , Rd_en)
begin
if(Rd_en = '1') then--read the data
	--elsif(rising_edge(Sys_Clk)) then
	if(Sys_Clk' event and Sys_Clk = '1') then
	RdData <= memory(Rd_Addr);
	end if;
end if;
end process;

end Behavioral;