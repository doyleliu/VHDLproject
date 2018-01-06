library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FIFO is
generic(
FIFO_Depth : integer :=16;
DataWidth : integer := 8;
AddrSize : integer :=  4
);
port(
Sys_Clk : in STD_LOGIC;
Sys_Rst : in STD_LOGIC;
Wr_en : in STD_LOGIC;
Rd_en : in STD_LOGIC;
FIFO_Full : out STD_LOGIC;
FIFO_Empty : out STD_LOGIC;
Wr_en_ram  : out STD_LOGIC;
Wr_Addr_r : out INTEGER RANGE 0 TO FIFO_Depth-1;
Rd_en_ram : out STD_LOGIC;
Rd_Addr_r : out INTEGER RANGE 0 TO FIFO_Depth-1
);
end FIFO;

architecture Behavioral of FIFO is
signal position : integer range 0 to FIFO_Depth;
begin

--the position of the pointer
process(Sys_Clk,Sys_Rst)
begin
if(Sys_Rst = '1') then
	position <= 0;
--elsif(rising_edge(Sys_Clk)) then
elsif(Sys_Clk' event and Sys_Clk = '1') then  --read enable
	if((Rd_en = '1') and not(Wr_en = '1') and (position > 0 )) then
		position <= position - 1;
	elsif((Wr_en = '1') and not(Rd_en = '1') and (position < FIFO_Depth)) then  --write enable
		position <= position + 1;
	end if;
end if;
end process;


-- process(Sys_Clk,Sys_Rst)
-- begin
-- if(Sys_Rst = '1') then
	-- position <= 0;
-- elsif(Sys_Clk' event and Sys_Clk = '1') then  
	-- if(Rd_en = '1' and position >0) then
		-- position <= position - 1;
	-- elsif(Wr_en = '1' position < FIFO_Depth) then 
		-- position <= position + 1;
	-- end if;
-- end if;
-- end process;


--write process
process(Sys_Clk,Sys_Rst)
variable wcnt : INTEGER range 0 to FIFO_Depth;
begin
if(Sys_Rst = '1') then
	wcnt := 0;
--elsif(rising_edge(Sys_Clk)) then
elsif(Sys_Clk' event and Sys_Clk = '1') then
	if(Wr_en = '1' and position < FIFO_Depth) then
		wcnt := wcnt + 1;
		if(wcnt > FIFO_Depth-1) then wcnt := 0;
		end if;
	end if;
end if;
Wr_Addr_r <= wcnt;-- the write pointer
end process;

--read prcocess
process(Sys_Clk,Sys_Rst)
variable rcnt : integer range 0 to FIFO_Depth;
begin
if(Sys_Rst = '1') then
	rcnt := 0;
--elsif(rising_edge(Sys_Clk)) then
elsif(Sys_Clk' event and Sys_Clk = '1') then
	if(Rd_en = '1' and position > 0) then
		rcnt := rcnt + 1;
		if(rcnt > FIFO_Depth-1) then
		rcnt := 0;
		end if;
	end if;
end if;
Rd_Addr_r <= rcnt;--the read pointer
end process;


Wr_en_ram <= '0' when(position = FIFO_Depth) else
Wr_en;
Rd_en_ram <= Rd_en;

FIFO_Full <= '1' when (position = FIFO_Depth) else '0';
FIFO_Empty <= '1' when (position = 0) else '0';
end Behavioral;


