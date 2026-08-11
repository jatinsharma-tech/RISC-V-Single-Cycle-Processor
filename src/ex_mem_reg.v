`timescale 1ns/1ps

module ex_mem_reg(
    input clk,
    input reset,

    input [31:0] ex_result_in,
    input [31:0] store_data_in,
    input [4:0]  rd_in,
    input [2:0]  funct3_in,

    input        reg_write_in,
    input        mem_read_in,
    input        mem_write_in,
    input        mem_to_reg_in,

    output reg [31:0] ex_result_out,
    output reg [31:0] store_data_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,

    output reg        reg_write_out,
    output reg        mem_read_out,
    output reg        mem_write_out,
    output reg        mem_to_reg_out
);

always @(posedge clk) begin
    if (reset) begin
        ex_result_out  <= 32'd0;
        store_data_out <= 32'd0;
        rd_out         <= 5'd0;
        funct3_out     <= 3'd0;
        reg_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        mem_write_out  <= 1'b0;
        mem_to_reg_out <= 1'b0;
    end else begin
        ex_result_out  <= ex_result_in;
        store_data_out <= store_data_in;
        rd_out         <= rd_in;
        funct3_out     <= funct3_in;
        reg_write_out  <= reg_write_in;
        mem_read_out   <= mem_read_in;
        mem_write_out  <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
    end
end

endmodule