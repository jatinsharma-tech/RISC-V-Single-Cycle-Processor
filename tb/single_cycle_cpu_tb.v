`timescale 1ns/1ps

module single_cycle_cpu_tb;

reg clk;
reg reset;

single_cycle_cpu uut(
    .clk(clk),
    .reset(reset)
);

// Clock Generation
always #5 clk = ~clk;

initial begin

    $dumpfile("waveforms/cpu.vcd");
    $dumpvars(0, uut);
    $monitor(
    "t=%0t PC=%d Instr=%h rd=%d rs1=%d rs2=%d RegWrite=%b WB=%d x1=%d x2=%d x3=%d x4=%d",
    $time,
    uut.pc,
    uut.instruction,
    uut.instruction[11:7],
    uut.instruction[19:15],
    uut.instruction[24:20],
    uut.reg_write,
    uut.write_back_data,
    uut.register_file_inst.registers[1],
    uut.register_file_inst.registers[2],
    uut.register_file_inst.registers[3],
    uut.register_file_inst.registers[4]
    );

    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    #200;

    $finish;

end

endmodule