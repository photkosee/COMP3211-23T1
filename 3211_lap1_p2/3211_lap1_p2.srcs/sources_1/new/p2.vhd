----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2023 08:11:16 PM
-- Design Name: 
-- Module Name: p2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voter is
    generic ( n : integer := 30);
    port ( votes : in std_logic_vector (n downto 0);
           majority : out std_logic);
end voter;

architecture behavioral of voter is

begin

process (votes)
    variable c : unsigned(9 downto 0) := "0000000000";
begin
    c := "0000000000";
    for i in 0 to n loop
        if votes(i) = '1' then
            c := c + 1;
        end if;
    end loop;
    if c >= (n/2) + 1 then
        majority <= '1';
    else
        majority <= '0';
    end if;
end process;
end behavioral;
