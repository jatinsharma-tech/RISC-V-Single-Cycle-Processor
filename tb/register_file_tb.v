`timescale 1ns/1ps
module register_file_tb;
reg clk;
reg reg_write;
reg[4:0] rs1;
reg[4:0] rs2;
reg[4:0] rd;
reg[31:0] write_data;

wire[31:0] read_data1;
wire[31:0] read_data2;

register_file uut (
    .clk(clk),
    .reg_write(reg_write),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

initial begin
    clk=0;
    forever #5 clk= ~clk;
end

initial begin
    $dumpfile("waveforms/register_file.vcd");
    $dumpvars(0, register_file_tb);


    //test case 1
    reg_write=0;
    rs1=0;
    rs2=0;
    rd=0;
    write_data=0;

    #10;

    // writing 25 in x5
    reg_write=1;
    rd=5;
    write_data=25;

    #10;

    // reading x5
    reg_write=0;
    rs1=5;

    #10;

    //writing in x0
    reg_write=1;
    rd=0;
    write_data=100;

    #10;

    // reading x0
    reg_write=0;
    rs1=0;

    #10;

    $finish;
end

endmodule