----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2023 05:06:28 PM
-- Design Name: 
-- Module Name: Pipeline_register - Behavioral
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

entity PipelineRegister is
    Generic ( n : integer );
    Port ( clk          : in std_logic;
           rst          : in std_logic;
           write        : in std_logic;
           dIn          : in std_logic_vector(n-1 downto 0);
           dOut         : out std_logic_vector(n-1 downto 0)
         );
end PipelineRegister;

architecture Behavioural of PipelineRegister is
begin
    process (rst, clk)
    begin
        if (rst = '1') then
            dOut <= (others => '0');
        elsif (clk'event and falling_edge(clk)) then
            if (write = '0') then
                dOut <= dIn;
            end if;
        end if;
    end process;
end Behavioural;
