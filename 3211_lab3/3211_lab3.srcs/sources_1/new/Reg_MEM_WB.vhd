----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2023 11:28:17 PM
-- Design Name: 
-- Module Name: Reg_MEM_WB - Behavioral
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

entity Reg_MEM_WB is
    port ( clk                  : in  std_logic;
           rst                  : in  std_logic;

           ctrl_laIn            : in  std_logic;
           ctrl_laOut           : out std_logic;
           ctrl_MemToRegIn      : in  std_logic;
           ctrl_MemToRegOut     : out std_logic;
           ctrl_RegDstIn        : in  std_logic;
           ctrl_RegDstOut       : out std_logic;        
           ctrl_RegWriteIn      : in  std_logic;
           ctrl_RegWriteOut     : out std_logic;

           Alu_carryIn          : in  std_logic;
           Alu_carryOut         : out std_logic;
       
           Alu_resultIn         : in  std_logic_vector(15 downto 0);
           Alu_resultOut        : out std_logic_vector(15 downto 0);
                 
           MemReadDataIn        : in  std_logic_vector(15 downto 0);
           MemReadDataOut       : out std_logic_vector(15 downto 0);
                      
           RegRead2In           : in  std_logic_vector(3 downto 0);
           RegRead2Out          : out std_logic_vector(3 downto 0);
           
           RegImmeIn            : in  std_logic_vector(3 downto 0);
           RegImmeOut           : out std_logic_vector(3 downto 0) 
       );
end Reg_MEM_WB;

architecture Behavioral of Reg_MEM_WB is

begin
 reg: entity work.PipelineRegister
        generic map (n => 45)
        port map (
          clk                   => clk,
          rst                   => rst,
          write                 => '0',
          
          dIn(44)               => ctrl_MemToRegIn,
          dIn(43)               => ctrl_RegDstIn,
          dIn(42)               => ctrl_RegWriteIn,
          dIn(41)               => ctrl_laIn,
          dIn(40)               => Alu_carryIn,
          dIn(39 downto 24)     => Alu_resultIn,
          dIn(23 downto 8)      => MemReadDataIn,
          dIn(7 downto 4)       => RegRead2In,
          dIn(3 downto 0)       => RegImmeIn,
          
          dOut(44)              => ctrl_MemToRegOut,
          dOut(43)              => ctrl_RegDstOut,
          dOut(42)              => ctrl_RegWriteOut,
          dOut(41)              => ctrl_laOut,
          dOut(40)              => Alu_carryOut,
          dOut(39 downto 24)    => Alu_resultOut,
          dOut(23 downto 8)     => MemReadDataOut,
          dOut(7 downto 4)      => RegRead2Out,
          dOut(3 downto 0)      => RegImmeOut
        );

end Behavioral;