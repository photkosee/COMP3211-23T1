----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2023 12:19:27 PM
-- Design Name: 
-- Module Name: compare - Behavioral
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

entity comparator_bne is
    Port ( Rs : in STD_LOGIC_VECTOR (15 downto 0);
           Rt : in STD_LOGIC_VECTOR (15 downto 0);
           outp : out STD_LOGIC );
end comparator_bne;

architecture Behavioral of comparator_bne is
begin
    outp <= '0' WHEN Rs = Rt ELSE '1';
end Behavioral;
