`timescale 1ns/1ps
module instruction_memory_tb;

reg [31:0] address;
wire [31:0] instruction;

instruction_memory uut(
    .address(address),
    .instruction(instruction)
);

initial begin
    $dumpfile("waveforms/im.vcd");
    $dumpvars(0, instruction_memory_tb);
    
    address=0;
    #10;

    address=4;
    #10;

    address=8;
    #10;

    address=12;
    #10;

    $finish;
end
endmodule