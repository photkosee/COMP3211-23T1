---------------------------------------------------------------------------
-- single_cycle_core.vhd - A Single-Cycle Processor Implementation
--
-- Notes : 
--
-- See single_cycle_core.pdf for the block diagram of this single
-- cycle processor core.
--
-- Instruction Set Architecture (ISA) for the single-cycle-core:
--   Each instruction is 16-bit wide, with four 4-bit fields.
--
--     noop      
--        # no operation or to signal end of program
--        # format:  | opcode = 0 |  0   |  0   |   0    | 
--
--     load  rt, rs, offset     
--        # load data at memory location (rs + offset) into rt
--        # format:  | opcode = 1 |  rs  |  rt  | offset |
--
--     store rt, rs, offset
--        # store data rt into memory location (rs + offset)
--        # format:  | opcode = 3 |  rs  |  rt  | offset |
--
--     add   rd, rs, rt
--        # rd <- rs + rt
--        # format:  | opcode = 8 |  rs  |  rt  |   rd   |
--
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipelined_core is
    port ( reset  : in  std_logic;
           clk    : in  std_logic );
end pipelined_core;

architecture structural of pipelined_core is

signal sig_next_pc              : std_logic_vector(3 downto 0);
signal sig_curr_pc              : std_logic_vector(3 downto 0);
signal sig_curr_pc_id           : std_logic_vector(3 downto 0);

signal sig_one_4b               : std_logic_vector(3 downto 0);
signal sig_pc_carry_out         : std_logic;
signal sig_insn                 : std_logic_vector(15 downto 0);
signal sig_insn_id              : std_logic_vector(15 downto 0);

signal sig_write_register_a_wb  : std_logic_vector(3 downto 0);
signal sig_write_register_b_wb  : std_logic_vector(3 downto 0);
signal sig_write_data_a_wb      : std_logic_vector(15 downto 0);

signal sig_alu_src_b            : std_logic_vector(15 downto 0);
signal sig_alu_result           : std_logic_vector(15 downto 0); 
signal sig_alu_carry_out        : std_logic;
signal sig_data_mem_out         : std_logic_vector(15 downto 0);
signal sig_sign_extended_offset_id         : std_logic_vector(15 downto 0);
signal sig_sign_extended_offset_ex         : std_logic_vector(15 downto 0);

signal sig_next_pc_standard     : std_logic_vector(3 downto 0);
signal sig_next_pc_stall        : std_logic_vector(3 downto 0);

signal sig_jump                 : std_logic;

signal sig_la_op_id             : std_logic;
signal sig_la_op_ex             : std_logic;
signal sig_la_op_mem            : std_logic;
signal sig_la_op_wb             : std_logic;
signal sig_reg_write_id         : std_logic;
signal sig_reg_write_ex         : std_logic;
signal sig_reg_write_mem        : std_logic;
signal sig_reg_write_wb         : std_logic;

signal sig_alu_src_id           : std_logic;
signal sig_alu_src_ex           : std_logic;

signal sig_mem_write_id         : std_logic;
signal sig_mem_write_ex         : std_logic;
signal sig_mem_write_mem        : std_logic;

signal sig_mem_to_reg_id        : std_logic;
signal sig_mem_to_reg_ex        : std_logic;
signal sig_mem_to_reg_mem       : std_logic;
signal sig_mem_to_reg_wb        : std_logic;
signal sig_reg_dst_id           : std_logic;
signal sig_reg_dst_ex           : std_logic;
signal sig_reg_dst_mem          : std_logic;
signal sig_reg_dst_wb           : std_logic;

signal sig_alu_insn_ex          : std_logic_vector(3 downto 0);

signal sig_read_data_a_id       : std_logic_vector(15 downto 0);
signal sig_read_data_a_ex       : std_logic_vector(15 downto 0);

signal sig_alu_inp_a            : std_logic_vector(15 downto 0);
signal sig_alu_inp_b            : std_logic_vector(15 downto 0);

signal sig_read_data_b_id       : std_logic_vector(15 downto 0);
signal sig_read_data_b_ex       : std_logic_vector(15 downto 0);
signal sig_read_data_b_mem      : std_logic_vector(15 downto 0);

signal sig_reg_read_a_ex        : std_logic_vector(3 downto 0);

signal sig_reg_read_b_ex        : std_logic_vector(3 downto 0);
signal sig_reg_read_b_mem       : std_logic_vector(3 downto 0);
signal sig_reg_read_b_wb        : std_logic_vector(3 downto 0);
signal sig_imme_ex              : std_logic_vector(3 downto 0);
signal sig_imme_mem             : std_logic_vector(3 downto 0);
signal sig_imme_wb              : std_logic_vector(3 downto 0);

signal sig_alu_result_mem       : std_logic_vector(15 downto 0);
signal sig_alu_result_wb        : std_logic_vector(15 downto 0);
signal sig_alu_carry_out_mem    : std_logic;
signal sig_alu_carry_out_wb     : std_logic;

signal sig_data_mem_out_wb      : std_logic_vector(15 downto 0);
signal sig_write_data_a         : std_logic_vector(15 downto 0);

signal sig_stall                : std_logic;
signal sig_forward_alu_a1       : std_logic;
signal sig_forward_alu_b1       : std_logic;
signal sig_forward_alu_a2       : std_logic;
signal sig_forward_alu_b2       : std_logic;

begin

    sig_one_4b              <= "0001";
    sig_stall               <= --'1' when sig_reg_read_a_ex = sig_insn_id(11 downto 8) or sig_read_data_a_ex = sig_insn_id(7 downto 4) else
                               '0';
                                                   
    pc : entity work.program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc ); 

    increment_pc : entity work.adder_4b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => sig_one_4b,
               sum       => sig_next_pc_standard,   
               carry_out => sig_pc_carry_out );
    
    next_pc_stall : entity work.mux_2to1_4b
    port map (
        mux_select  => sig_stall,
        data_a      => sig_next_pc_standard,
        data_b      => sig_curr_pc,
        data_out    => sig_next_pc_stall   
    );
               
    next_pc_selection : entity work.mux_2to1_4b
    port map (
        mux_select  => sig_jump,
        data_a      => sig_next_pc_stall,
        data_b      => (sig_next_pc_stall + sig_insn_id(3 downto 0)),
        data_out    => sig_next_pc   
    );
    
    insn_mem : entity work.instruction_memory 
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn );
               
    pipeline_if_id : entity work.Reg_IF_ID
    port map ( clk      => clk,
               rst      => sig_jump,
               writeIn  => sig_stall,
          
               pcIn     => sig_curr_pc,
               instrIn  => sig_insn,
               
               pcOut    => sig_curr_pc_id,
               instrOut => sig_insn_id);

    sign_extend : entity work.sign_extend_4to16 
    port map ( data_in  => sig_insn_id(3 downto 0),
               data_out => sig_sign_extended_offset_id );

    reg_file : entity work.register_file 
    port map ( reset                => reset, 
               clk                  => clk,
               read_register_a      => sig_insn_id(11 downto 8),
               read_register_b      => sig_insn_id(7 downto 4),
               write_enable         => sig_reg_write_wb,
               write_register_a     => sig_write_register_a_wb,
               write_data_a         => sig_write_data_a_wb,
               read_data_a          => sig_read_data_a_id,
               read_data_b          => sig_read_data_b_id,
               la_enable            => sig_la_op_wb,
               write_register_b     => sig_reg_read_b_wb );
               
    ctrl_unit : entity work.control_unit 
    port map ( stall      => sig_stall,
               opcode     => sig_insn_id(15 downto 12),
               data_a     => sig_read_data_a_id,
               data_b     => sig_read_data_b_id,
               reg_dst    => sig_reg_dst_id,
               reg_write  => sig_reg_write_id,
               alu_src    => sig_alu_src_id,
               mem_write  => sig_mem_write_id,
               mem_to_reg => sig_mem_to_reg_id,
               jump_op    => sig_jump,
               la_op      => sig_la_op_id );
    
    pipeline_id_ex : entity work.Reg_ID_EX
    port map ( clk               => clk,
               rst               => sig_jump,
          
               RegRead1In        => sig_insn_id(11 downto 8),
               ctrl_alu_srcIn    => sig_alu_src_id,
               ctrl_MemToRegIn   => sig_mem_to_reg_id,
               ctrl_RegDstIn     => sig_reg_dst_id,
               ctrl_RegWriteIn   => sig_reg_write_id,
               ctrl_MemWriteIn   => sig_mem_write_id,
               ctrl_laIn         => sig_la_op_id,
               InstIn            => sig_insn_id(15 downto 12),
               RegData1In        => sig_read_data_a_id,
               RegData2In        => sig_read_data_b_id,
               SignExtendDataIn  => sig_sign_extended_offset_id,
               RegRead2In        => sig_insn_id(7 downto 4),
               RegImmeIn         => sig_insn_id(3 downto 0),
          
               RegRead1Out       => sig_reg_read_a_ex,
               ctrl_alu_srcOut   => sig_alu_src_ex,
               ctrl_MemToRegOut  => sig_mem_to_reg_ex,
               ctrl_RegDstOut    => sig_reg_dst_ex,
               ctrl_RegWriteOut  => sig_reg_write_ex,
               ctrl_MemWriteOut  => sig_mem_write_ex,
               ctrl_laOut        => sig_la_op_ex,
               InstOut           => sig_alu_insn_ex,
               RegData1Out       => sig_read_data_a_ex,
               RegData2Out       => sig_read_data_b_ex,
               SignExtendDataOut => sig_sign_extended_offset_ex,
               RegRead2Out       => sig_reg_read_b_ex,
               RegImmeOut        => sig_imme_ex );
               
    mux_alu_src : entity work.mux_2to1_16b 
    port map ( mux_select => sig_alu_src_ex,
               data_a     => sig_read_data_b_ex,
               data_b     => sig_sign_extended_offset_ex,
               data_out   => sig_alu_src_b );
               
    forwarding_unit : entity work.Forwarding_unit 
    port map ( reg_write_ex_mem      => sig_reg_write_mem,
               reg_rd_ex_mem         => sig_imme_mem,
               reg_rs_id_ex          => sig_reg_read_a_ex,
               reg_rt_id_ex          => sig_reg_read_b_ex,
           
               reg_write_mem_wb      => sig_reg_write_wb,
               reg_rd_mem_wb         => sig_imme_wb,
                
               forward_alu_a1        => sig_forward_alu_a1,
               forward_alu_a2        => sig_forward_alu_a2,
               forward_alu_b1        => sig_forward_alu_b1,
               forward_alu_b2        => sig_forward_alu_b2 );
               
    mux_alu_a : entity work.mux_3to1_16b 
    port map ( mux_select_a => sig_forward_alu_a1,
               mux_select_b => sig_forward_alu_a2,
               data_a       => sig_read_data_a_ex,
               data_b       => sig_alu_result_mem,
               data_c       => sig_data_mem_out_wb,
               data_out     => sig_alu_inp_a );
               
    mux_alu_b : entity work.mux_3to1_16b 
    port map ( mux_select_a => sig_forward_alu_b1,
               mux_select_b => sig_forward_alu_b2,
               data_a       => sig_alu_src_b,
               data_b       => sig_alu_result_mem,
               data_c       => sig_data_mem_out_wb,
               data_out     => sig_alu_inp_b );

    alu : entity work.alu_combined  
    port map ( src_a     => sig_alu_inp_a,
               src_b     => sig_alu_inp_b,
               result    => sig_alu_result,
               flag      => sig_alu_carry_out,
               operation => sig_alu_insn_ex );

    pipeline_ex_mem : entity work.Reg_EX_MEM
    port map ( clk               => clk,
               rst               => '0',
          
               ctrl_laIn         => sig_la_op_ex,
               ctrl_MemToRegIn   => sig_mem_to_reg_ex,
               ctrl_RegDstIn     => sig_reg_dst_ex,
               ctrl_RegWriteIn   => sig_reg_write_ex,
               ctrl_MemWriteIn   => sig_mem_write_ex,
               Alu_carryIn       => sig_alu_carry_out,
               Alu_resultIn      => sig_alu_result,
               RegData2In        => sig_read_data_b_ex,
               RegRead2In        => sig_reg_read_b_ex,
               RegImmeIn         => sig_imme_ex,
          
               ctrl_laOut        => sig_la_op_mem,
               ctrl_MemToRegOut  => sig_mem_to_reg_mem,
               ctrl_RegDstOut    => sig_reg_dst_mem,
               ctrl_RegWriteOut  => sig_reg_write_mem,
               ctrl_MemWriteOut  => sig_mem_write_mem,
               Alu_carryOut      => sig_alu_carry_out_mem,
               Alu_resultOut     => sig_alu_result_mem,
               RegData2Out       => sig_read_data_b_mem,
               RegRead2Out       => sig_reg_read_b_mem,
               RegImmeOut        => sig_imme_mem );
               
    data_mem : entity work.data_memory 
    port map ( reset        => reset,
               clk          => clk,
               write_enable => sig_mem_write_mem,
               write_data   => sig_read_data_b_mem,
               addr_in      => sig_alu_result_mem(3 downto 0),
               data_out     => sig_data_mem_out );
    
    pipeline_mem_wb : entity work.Reg_MEM_WB
    port map ( clk               => clk,
               rst               => '0',
          
               ctrl_MemToRegIn   => sig_mem_to_reg_mem,
               ctrl_RegDstIn     => sig_reg_dst_mem,
               ctrl_RegWriteIn   => sig_reg_write_mem,
               ctrl_laIn         => sig_la_op_mem,
               Alu_carryIn       => sig_alu_carry_out_mem,
               Alu_resultIn      => sig_alu_result_mem,
               MemReadDataIn     => sig_data_mem_out,
               RegRead2In        => sig_reg_read_b_mem,
               RegImmeIn         => sig_imme_mem,
          
               ctrl_MemToRegOut  => sig_mem_to_reg_wb,
               ctrl_RegDstOut    => sig_reg_dst_wb,
               ctrl_RegWriteOut  => sig_reg_write_wb,
               ctrl_laOut        => sig_la_op_wb,
               Alu_carryOut      => sig_alu_carry_out_wb,
               Alu_resultOut     => sig_alu_result_wb,
               MemReadDataOut    => sig_data_mem_out_wb,
               RegRead2Out       => sig_reg_read_b_wb,
               RegImmeOut        => sig_imme_wb );
                          
    mux_mem_to_reg : entity work.mux_2to1_16b 
    port map ( mux_select => sig_mem_to_reg_wb,
               data_a     => sig_alu_result_wb,
               data_b     => sig_data_mem_out_wb,
               data_out   => sig_write_data_a );
             
               
    mux_la : entity work.mux_2to1_16b 
    port map ( mux_select => sig_alu_carry_out_wb,
               data_a     => sig_write_data_a,
               data_b     => "1111111111111111",
               data_out   => sig_write_data_a_wb );
               
    mux_reg_dst : entity work.mux_2to1_4b 
    port map ( mux_select => sig_reg_dst_wb,
               data_a     => sig_reg_read_b_wb,
               data_b     => sig_imme_wb,
               data_out   => sig_write_register_a_wb );
                                       
end structural;
