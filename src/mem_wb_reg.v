`timescale 1ns/1ps

module mem_wb_reg(
    input clk,
    input reset,
    
    input [31:0] ex_result_in,
    input [31:0] memory_data_in,
    input [4:0] rd_in,

    input reg_write_in,
    input mem_to_reg_in,

    output reg [31:0] ex_result_out,
    output reg [31:0] memory_data_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_to_reg_out
);

always @(posedge clk) begin
    if (reset) begin
        ex_result_out <= 32'd0;
        memory_data_out <= 32'd0;
        rd_out <= 5'd0;
        reg_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
    end else begin
        ex_result_out <= ex_result_in;
        memory_data_out <= memory_data_in;
        rd_out <= rd_in;
        reg_write_out <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
    end
end

endmodule
