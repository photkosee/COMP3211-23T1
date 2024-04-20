----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2023 05:08:53 PM
-- Design Name: 
-- Module Name: Reg_IF_ID - Behavioral
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

entity Reg_IF_ID is
    port ( clk          : in  std_logic;
           rst          : in  std_logic;
           writeIn      : in  std_logic;
           
           pcIn         : in  std_logic_vector(3 downto 0);
           pcOut        : out std_logic_vector(3 downto 0);
           
           instrIn      : in  std_logic_vector(15 downto 0);
           instrOut     : out std_logic_vector(15 downto 0)
         );
end Reg_IF_ID;

architecture Behavioral of Reg_IF_ID is

begin
    reg: entity work.PipelineRegister
        generic map (n => 20)
        port map (
            clk                 => clk,
            rst                 => rst,
            write               => writeIn,
            
            dIn(19 downto 16)   => pcIn,
            dIn(15 downto 0)    => instrIn,
            
            dOut(19 downto 16)  => pcOut,
            dOut(15 downto 0)   => instrOut
        );

end Behavioral;
