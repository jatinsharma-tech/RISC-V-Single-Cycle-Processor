`timescale 1ns / 1ps
module pc_tb;
reg clk;
reg reset;
wire[31:0] pc;

pc uut(
    .clk(clk),
    .reset(reset),
    .pc(pc)
);

initial begin
    clk=0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("waveforms/pc.vcd");
    $dumpvars(0, pc_tb);
    
    reset=1;
    #10;

    reset=0;
    #50;

    $finish;
end
endmodule