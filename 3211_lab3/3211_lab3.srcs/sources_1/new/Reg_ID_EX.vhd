----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2023 05:18:16 PM
-- Design Name: 
-- Module Name: Reg_ID_EX - Behavioral
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

entity Reg_ID_EX is
    port ( clk                  : in  std_logic;
           rst                  : in  std_logic;

           ctrl_alu_srcIn       : in  std_logic;
           ctrl_alu_srcOut      : out std_logic;
           ctrl_MemToRegIn      : in  std_logic;
           ctrl_MemToRegOut     : out std_logic;
           ctrl_RegDstIn        : in  std_logic;
           ctrl_RegDstOut       : out std_logic;        
           ctrl_RegWriteIn      : in  std_logic;
           ctrl_RegWriteOut     : out std_logic;
           ctrl_MemWriteIn      : in  std_logic;
           ctrl_MemWriteOut     : out std_logic;
           ctrl_laIn            : in  std_logic;
           ctrl_laOut           : out std_logic;

           InstIn               : in  std_logic_vector(3 downto 0);
           InstOut              : out std_logic_vector(3 downto 0);   

           RegData1In           : in  std_logic_vector(15 downto 0);
           RegData1Out          : out std_logic_vector(15 downto 0);
           
           RegData2In           : in  std_logic_vector(15 downto 0);
           RegData2Out          : out std_logic_vector(15 downto 0);
      
           SignExtendDataIn     : in  std_logic_vector(15 downto 0);
           SignExtendDataOut    : out std_logic_vector(15 downto 0);
                      
           RegRead2In           : in  std_logic_vector(3 downto 0);
           RegRead2Out          : out std_logic_vector(3 downto 0);
           
           RegImmeIn            : in  std_logic_vector(3 downto 0);
           RegImmeOut           : out std_logic_vector(3 downto 0);
           
           RegRead1In           : in  std_logic_vector(3 downto 0);
           RegRead1Out          : out std_logic_vector(3 downto 0)
       );
end Reg_ID_EX;

architecture Behavioral of Reg_ID_EX is

begin
 reg: entity work.PipelineRegister
        generic map (n => 70)
        port map (
          clk                   => clk,
          rst                   => rst,
          write                 => '0',
          
          dIn(69 downto 66)     => RegRead1In,
          dIn(65)               => ctrl_alu_srcIn,
          dIn(64)               => ctrl_MemToRegIn,
          dIn(63)               => ctrl_RegDstIn,
          dIn(62)               => ctrl_RegWriteIn,
          dIn(61)               => ctrl_MemWriteIn,
          dIn(60)               => ctrl_laIn,
          dIn(59 downto 56)     => InstIn,
          dIn(55 downto 40)     => RegData1In,
          dIn(39 downto 24)     => RegData2In,
          dIn(23 downto 8)      => SignExtendDataIn,
          dIn(7 downto 4)       => RegRead2In,
          dIn(3 downto 0)       => RegImmeIn,
          
          dOut(69 downto 66)    => RegRead1Out,
          dOut(65)              => ctrl_alu_srcOut,
          dOut(64)              => ctrl_MemToRegOut,
          dOut(63)              => ctrl_RegDstOut,
          dOut(62)              => ctrl_RegWriteOut,
          dOut(61)              => ctrl_MemWriteOut,
          dOut(60)              => ctrl_laOut,
          dOut(59 downto 56)    => InstOut,
          dOut(55 downto 40)    => RegData1Out,
          dOut(39 downto 24)    => RegData2Out,
          dOut(23 downto 8)     => SignExtendDataOut,
          dOut(7 downto 4)      => RegRead2Out,
          dOut(3 downto 0)      => RegImmeOut
        );

end Behavioral;
