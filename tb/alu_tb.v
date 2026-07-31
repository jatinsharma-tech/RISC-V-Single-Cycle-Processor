`timescale 1ns/1ps
module alu_tb;

reg [31:0] a;
reg [31:0] b;
reg [3:0] alu_control;

wire [31:0] result;
wire zero;

alu uut (
    .a(a),
    .b(b),
    .alu_control(alu_control),
    .result(result),
    .zero(zero)
);

initial begin
    // ADD
    a=20;
    b=10;
    alu_control=4'b0000;
    #10;

    // SUB
    a=20;
    b=10;
    alu_control=4'b0001;
    #10;

    // AND
    a= 32'hF0F0;
    b= 32'h0FF0;
    alu_control=4'b0010;
    #10;

    // OR
    a= 32'hF0F0;
    b= 32'h0FF0;
    alu_control=4'b0011;
    #10;

    // XOR
    a= 32'hF0F0;
    b= 32'h0FF0;
    alu_control=4'b0100;
    #10;

    // SLT (True)
    a= -5;
    b=3;
    alu_control=4'b0101;
    #10;

    // SLT (False)
    a= 10;
    b= 5;
    alu_control=4'b0101;
    #10;

    //Zero flag test
    a=15;
    b=15;
    alu_control=4'b0001; 
    #10;

    $finish;
end


initial begin
    $dumpfile("waveforms/alu.vcd");
    $dumpvars(0, alu_tb);
end

endmodule