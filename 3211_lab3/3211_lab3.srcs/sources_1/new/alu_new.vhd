----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2023 12:15:41 PM
-- Design Name: 
-- Module Name: alu_new - Behavioral
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

entity alu_combined is
    port ( src_a       : in    std_logic_vector(15 downto 0);
           src_b       : in    std_logic_vector(15 downto 0);
           result      : out   std_logic_vector(15 downto 0);
           flag        : out   std_logic;
           operation   : in    std_logic_vector(3 downto 0) );
end alu_combined;

architecture Behavioral of alu_combined is
    SIGNAL add_result   : std_logic_vector(15 downto 0);
    SIGNAL add_flag     : std_logic;
    SIGNAL slri_result  : std_logic_vector(15 downto 0);
    SIGNAL bne_result   : std_logic;
    SIGNAL la_result    : std_logic;
begin

    add_device: entity work.adder_16b 
    port map ( src_a     => src_a,
               src_b     => src_b,
               sum       => add_result,
               carry_out => add_flag );
    
    bne_device : entity work.comparator_bne
    port map ( Rs       => src_a,
               Rt       => src_b,
               outp     => bne_result );
               
    la_device : entity  work.comparator_la 
    port map ( Rs       => src_a,
               Rt       => src_b,
               outp     => la_result );
    
    slri_device: entity work.slri
    port map ( Rs       => src_a,
               Imme     => to_integer(unsigned(src_b(3 downto 0))),
               outp     => slri_result );

    result  <= "0000000000000000"           when operation = "0000" else
               slri_result   when operation = "1100" else
               src_b         when operation = "1011" else 
               add_result;
               
    flag    <= '0'           when operation = "0000" else
               bne_result    when operation = "1010" else 
               la_result     when operation = "1011" else
               add_flag;

end Behavioral;
