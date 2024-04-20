----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/15/2023 09:44:25 PM
-- Design Name: 
-- Module Name: mux_3to1_16b - Behavioral
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

entity mux_3to1_16b is
    port ( mux_select_a : in  std_logic;
           mux_select_b : in  std_logic;
           data_a       : in  std_logic_vector(15 downto 0);
           data_b       : in  std_logic_vector(15 downto 0);
           data_c       : in  std_logic_vector(15 downto 0);
           data_out     : out std_logic_vector(15 downto 0) );
end mux_3to1_16b;

architecture Behavioral of mux_3to1_16b is

signal tmp_data_out     : std_logic_vector(15 downto 0); 

begin

    mux_a : entity work.mux_2to1_16b
    port map ( mux_select => mux_select_a,
               data_a     => data_a,
               data_b     => data_b, 
               data_out   => tmp_data_out );
               
    mux_b : entity work.mux_2to1_16b
    port map ( mux_select => mux_select_b,
               data_a     => data_c,
               data_b     => tmp_data_out, 
               data_out   => data_out );

end Behavioral;
