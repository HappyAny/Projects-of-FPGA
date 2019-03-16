----------------------------------------------------------------------------------
-- Company: NONE
-- Engineer: HappyAny
-- 
-- Create Date: 2019/03/15 15:41:47
-- Design Name: BTD
-- Module Name: test - Behavioral
-- Project Name: BTD
-- Target Devices: NEXYS4DDR
-- Tool Versions: Vivado 2017.4
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
Port ( 
seg7:out std_logic_vector(6 downto 0);
clk: in std_logic;
an: inout std_logic_vector(7 downto 0);
swi: in std_logic_vector(15 downto 0)
);
end test;

architecture Behavioral of test is
signal change:std_logic:='0';
signal an_temp:std_logic_vector(7 downto 0):= "11111110";
signal seg7_temp:std_logic_vector(6 downto 0);
signal segdata:integer range 0 to 15000000:=0;
signal sdata1:integer range 0 to 10;
signal sdata2:integer range 0 to 10;
signal sdata3:integer range 0 to 10;
signal sdata4:integer range 0 to 10;
signal sdata5:integer range 0 to 10;
signal sdata:integer range 0 to 10;
begin

process(clk)
variable clk_count1:integer range 0 to 15000000:=0;
begin
if clk'event and clk='1' then
	if clk_count1=50000 then change<=not change;clk_count1:=0;
	else 
        clk_count1:=clk_count1+1;
	end if;
end if;
end process;

process(change,an_temp,seg7_temp)
begin
if change'event and change='1' then
	an<=an_temp;
	an_temp<= to_stdlogicvector(to_bitvector(an_temp) ROL 1 );
	seg7<=seg7_temp;
end if;
end process;

process(clk,swi)
begin
if clk'event and clk='1' then
    segdata<=conv_integer(swi);
    sdata5<=segdata/10000;
    sdata4<=(segdata-sdata5*10000)/1000;
    sdata3<=(segdata-sdata5*10000-sdata4*1000)/100;
    sdata2<=(segdata-sdata5*10000-sdata4*1000-sdata3*100)/10;
    sdata1<=(segdata-sdata5*10000-sdata4*1000-sdata3*100-sdata2*10);
end if;
end process;

process(an)
begin
case an is
    when "11111110" =>sdata<=sdata2;
    when "11111101" =>sdata<=sdata3;
    when "11111011" =>sdata<=sdata4;
    when "11110111" =>sdata<=sdata5;
    when "01111111" =>sdata<=sdata1;
    when others=>sdata<=0;
end case;
end process;



process(sdata)
begin
case sdata is
	when 0=>seg7_temp<="0000001";		
	when 1=>seg7_temp<="1001111";
	when 2=>seg7_temp<="0010010";
	when 3=>seg7_temp<="0000110";
	when 4=>seg7_temp<="1001100";
	when 5=>seg7_temp<="0100100";
	when 6=>seg7_temp<="0100000";
	when 7=>seg7_temp<="0001111";
	when 8=>seg7_temp<="0000000";
	when 9=>seg7_temp<="0000100";		
	when others=>seg7_temp<="1111111";
end case;
end process;

end Behavioral;
