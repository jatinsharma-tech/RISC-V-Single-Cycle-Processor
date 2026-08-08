`timescale 1ns/1ps
module if_id_reg(
    input clk,
    input reset,
    input stall,
    input flush,

    input [31:0] pc_in,
    input [31:0] instr_in,
    input [31:0] pc4_in,

    output reg [31:0] pc_out,
    output reg [31:0] instr_out,
    output reg [31:0] pc4_out
);


always @(posedge clk) begin
    if (reset || flush) begin
        pc_out <= 32'd0;
        pc4_out <= 32'd0;
        instr_out <= 32'h00000013; // NOP (addi x0,x0,0)
    end else if (!stall) begin
        pc_out <= pc_in;
        pc4_out <= pc4_in;
        instr_out <= instr_in;
    end
end


endmodule