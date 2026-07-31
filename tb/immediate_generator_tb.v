`timescale 1ns/1ps
module immediate_generator_tb;
reg [31:0] instruction;
wire [31:0] immediate;

immediate_generator uut (
    .instruction(instruction),
    .immediate(immediate)
);

initial begin
    //I Type
    instruction= 32'h00500093; // addi x1, x0, 5
    #10;

    //S Type
    instruction= 32'h00112223; // sw x1, 0(x2)
    #10;

    //B Type
    instruction= 32'h00208463; // beq x1, x2, 8
    #10;

    //U Type
    instruction= 32'h123450b7; // lui
    #10;

    //J Type
    instruction= 32'h004000ef; // jal
    #10;

    $finish;
end

initial begin
    $dumpfile("waveforms/immediate_generator.vcd");
    $dumpvars(0, immediate_generator_tb);
end

endmodule
