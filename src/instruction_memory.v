`timescale 1ns/1ps
module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

parameter MEM_WORDS = 4096; // 16KB instruction memory

reg [31:0] memory [0:MEM_WORDS-1];
integer i;

initial begin
    // Fill all locations with NOP
    for(i = 0; i < MEM_WORDS; i = i + 1)
        memory[i] = 32'h00000013;

    // Load actual program
    $readmemh("mem/instructions.mem", memory);
end

assign instruction = memory[address >> 2];

endmodule