`timescale 1ns/1ps
module data_memory(
    input clk,
    input mem_write,
    input mem_read,

    // funct3 of the current instruction selects access width/signedness:
    // 000=LB/SB  001=LH/SH  010=LW/SW  100=LBU  101=LHU
    // Left unconnected (defaults to word access) by callers that don't
    // care, e.g. the original word-only testbench.
    input [2:0] funct3,

    input [31:0] address,
    input [31:0] write_data,

    output reg [31:0] read_data
);

parameter MEM_BYTES = 4096; // 4KB byte-addressable data memory

reg [7:0] memory[0:MEM_BYTES-1];

integer i;

initial begin
    for(i = 0; i < MEM_BYTES; i = i + 1)
        memory[i] = 8'd0;
end

wire [$clog2(MEM_BYTES)-1:0] addr = address[$clog2(MEM_BYTES)-1:0];

// Read (combinational)
always @(*) begin
    if (mem_read) begin
        case (funct3)
            3'b000:  read_data = {{24{memory[addr][7]}}, memory[addr]};                                   // LB
            3'b001:  read_data = {{16{memory[addr+1][7]}}, memory[addr+1], memory[addr]};                 // LH
            3'b100:  read_data = {24'b0, memory[addr]};                                                   // LBU
            3'b101:  read_data = {16'b0, memory[addr+1], memory[addr]};                                   // LHU
            default: read_data = {memory[addr+3], memory[addr+2], memory[addr+1], memory[addr]};          // LW
        endcase
    end else begin
        read_data = 32'd0;
    end
end

// Write (synchronous)
always @(posedge clk) begin
    if (mem_write) begin
        case (funct3)
            3'b000: begin // SB
                memory[addr] <= write_data[7:0];
            end
            3'b001: begin // SH
                memory[addr]   <= write_data[7:0];
                memory[addr+1] <= write_data[15:8];
            end
            default: begin // SW
                memory[addr]   <= write_data[7:0];
                memory[addr+1] <= write_data[15:8];
                memory[addr+2] <= write_data[23:16];
                memory[addr+3] <= write_data[31:24];
            end
        endcase
    end
end

endmodule