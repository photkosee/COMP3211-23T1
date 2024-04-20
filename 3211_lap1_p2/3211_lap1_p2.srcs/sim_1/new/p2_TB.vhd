----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2023 12:10:03 AM
-- Design Name: 
-- Module Name: p2_TB - Behavioral
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

entity vote_tb is
--  Port ( );
end vote_tb;

architecture Behavioral of vote_tb is
    signal votes : std_logic_vector(30 downto 0);
    signal decision : std_logic;
begin

uut: entity work.voter  
    port map (
        votes,
        majority => decision
    );

process begin
 
    votes <= "1111111111111111111110000000000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111000000000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111100000000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111110000000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111111000000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111111100000"; wait for 50ns; -- 1
    votes <= "1111111111111111111111111111111"; wait for 50ns; -- 1
    votes <= "0101010101010101010101010101010"; wait for 50ns; -- 0
    votes <= "1010101010101010101010101010101"; wait for 50ns; -- 1
end process;
end Behavioral;
