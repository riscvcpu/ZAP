/*
Filename --
zap_memory_main.v

HDL --
Verilog 2005.

Description --
This stage merely acts as a buffer in between the ALU stage and the register file (i.e., writeback stage). This stage is intended
to allow the memory to use up 1 clock cycle to perform operations without the pipeline losing throughput.
*/

module zap_memory_main
#(
        // Number of physical registers.
        parameter PHY_REGS = 46
)
(
        // Clock and reset.
        input wire                          i_clk,
        input wire                          i_reset,

        // Pipeline control signals.
        input wire                          i_clear_from_writeback,
        input wire                          i_data_stall,

        // Memory stuff.
        input   wire                        i_mem_load_ff,

        // Data valid and buffered PC.
        input wire                          i_dav_ff,
        input wire [31:0]                   i_pc_plus_8_ff,

        // ALU value, flags,and where to write the value.
        input wire [31:0]                   i_alu_result_ff,
        input wire  [3:0]                   i_flags_ff,
        input wire                          i_flag_update_ff,
        input wire [$clog2(PHY_REGS)-1:0]   i_destination_index_ff,

        // Interrupts.
        input   wire                        i_irq_ff,
        input   wire                        i_fiq_ff,
        input   wire                        i_instr_abort_ff,
        input   wire                        i_swi_ff,

        // Memory SRCDEST index. For loads, this tells the register file where to
        // put the read data.
        input wire [$clog2(PHY_REGS)-1:0]   i_mem_srcdest_index_ff,     // Set to RAZ if invalid.

        // ALU result and flags.
        output reg  [31:0]                   o_alu_result_ff,
        output reg   [3:0]                   o_flags_ff,
        output reg                           o_flag_update_ff,

        // Where to write ALU and memory read target register.
        output reg [$clog2(PHY_REGS)-1:0]    o_destination_index_ff,
        output reg [$clog2(PHY_REGS)-1:0]    o_mem_srcdest_index_ff, // Set to RAZ if invalid.

        // Outputs valid and PC buffer.
        output reg                           o_dav_ff,
        output reg [31:0]                    o_pc_plus_8_ff,

        // The whole interrupt signaling scheme.
        output reg                           o_irq_ff,
        output reg                           o_fiq_ff,
        output reg                           o_swi_ff,
        output reg                           o_instr_abort_ff,

        // Memory load information is passed down.
        output reg                           o_mem_load_ff        
);

`include "regs.vh"

/*
        On reset or on a clear from WB, we will disable the vectors
        in this unit. Else, we will just flop everything out.
*/
always @ (posedge i_clk)
if ( i_reset )
begin
        o_alu_result_ff       <= 0;//i_alu_result_ff;
        o_flags_ff            <= 0;//i_flags_ff;
        o_mem_srcdest_index_ff<= 0;//i_mem_srcdest_index_ff;
        o_dav_ff              <= 0;//i_dav_ff;
        o_destination_index_ff<= 0;//i_destination_index_ff;
        o_pc_plus_8_ff        <= 0;//i_pc_plus_8_ff;
        o_irq_ff              <= 0;//i_irq_ff;
        o_fiq_ff              <= 0;//i_fiq_ff;
        o_swi_ff              <= 0;//i_swi_ff;
        o_instr_abort_ff      <= 0;//i_instr_abort_ff;
        o_mem_load_ff         <= 0;//i_mem_load_ff; 
        o_flag_update_ff      <= 0;
end
else if ( i_clear_from_writeback )
begin
        o_alu_result_ff       <= 0;//i_alu_result_ff;
        o_flags_ff            <= 0;//i_flags_ff;
        o_mem_srcdest_index_ff<= 0;//i_mem_srcdest_index_ff;
        o_dav_ff              <= 0;//i_dav_ff;
        o_destination_index_ff<= 0;//i_destination_index_ff;
        o_pc_plus_8_ff        <= 0;//i_pc_plus_8_ff;
        o_irq_ff              <= 0;//i_irq_ff;
        o_fiq_ff              <= 0;//i_fiq_ff;
        o_swi_ff              <= 0;//i_swi_ff;
        o_instr_abort_ff      <= 0;//i_instr_abort_ff;
        o_mem_load_ff         <= 0;//i_mem_load_ff; 
        o_flag_update_ff      <= 0;
end
else if ( i_data_stall )
begin
        // Stall unit. Outputs do not change.
end
else
begin
        // Just flop everything out.
        o_alu_result_ff       <= i_alu_result_ff;
        o_flags_ff            <= i_flags_ff;
        o_mem_srcdest_index_ff<= i_mem_srcdest_index_ff;
        o_dav_ff              <= i_dav_ff;
        o_destination_index_ff<= i_destination_index_ff;
        o_pc_plus_8_ff        <= i_pc_plus_8_ff;
        o_irq_ff              <= i_irq_ff;
        o_fiq_ff              <= i_fiq_ff;
        o_swi_ff              <= i_swi_ff;
        o_instr_abort_ff      <= i_instr_abort_ff;
        o_mem_load_ff         <= i_mem_load_ff; 
        o_flag_update_ff      <= i_flag_update_ff;
end

endmodule
