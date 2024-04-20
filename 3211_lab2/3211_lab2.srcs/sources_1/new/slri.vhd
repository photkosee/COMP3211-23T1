----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2023 12:17:51 PM
-- Design Name: 
-- Module Name: slri - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity slri is
    port ( Rs   : in    std_logic_vector (15 downto 0);
           Imme : in    integer range 0 to 16;
           outp : out   std_logic_vector (15 downto 0));
end slri;

architecture Behavioral of slri is
begin
outp <= Rs((15 - Imme) downto 0) & Rs(15 downto (16 - Imme));
end Behavioral;
