module instruction_memory(
    input [31:0] address,
    output [31:0] instruction
);

reg [31:0] memory[0:255];

initial begin
    $readmemh("mem/instructions.mem", memory);
end

assign instruction = memory[address >> 2];

endmodule