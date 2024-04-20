----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2023 07:45:00 AM
-- Design Name: 
-- Module Name: Forwarding_unit - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Forwarding_unit is
    port ( reg_write_ex_mem      : in  std_logic;
           reg_rd_ex_mem         : in  std_logic_vector(3 downto 0);
           reg_rs_id_ex          : in  std_logic_vector(3 downto 0);
           reg_rt_id_ex          : in  std_logic_vector(3 downto 0);
           
           reg_write_mem_wb      : in  std_logic;
           reg_rd_mem_wb         : in  std_logic_vector(3 downto 0);
           
           forward_alu_a1        : out std_logic;
           forward_alu_a2        : out std_logic;
           forward_alu_b1        : out std_logic;
           forward_alu_b2        : out std_logic );
end Forwarding_unit;

architecture Behavioral of Forwarding_unit is

begin

    forward_alu_a1      <= '1' when reg_write_ex_mem = '1' and (reg_rd_ex_mem /= "0000000000000000") and (reg_rd_ex_mem = reg_rs_id_ex) else
                               '0';
    forward_alu_a2      <= '1' when (reg_write_mem_wb = '1' and (reg_rd_mem_wb /= "0000000000000000") and (reg_rd_mem_wb = reg_rs_id_ex)) else
                               '0';
    forward_alu_b1      <= '1' when (reg_write_ex_mem = '1' and (reg_rd_ex_mem /= "0000000000000000") and (reg_rd_ex_mem = reg_rt_id_ex)) else
                               '0';
    forward_alu_b2      <= '1' when reg_write_mem_wb = '1' and (reg_rd_mem_wb /= "0000000000000000") and (reg_rd_mem_wb = reg_rt_id_ex) else
                               '0';
                       
    
end Behavioral;
