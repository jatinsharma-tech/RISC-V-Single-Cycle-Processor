`timescale 1ns/1ps

module pipelined_cpu_tb;

reg clk;
reg reset;

pipelined_cpu uut(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("waveforms/pipeline.vcd");
    $dumpvars(0, uut);
    $monitor(
    "t=%0t PC=%3d IF=%h stall=%b flush=%b | ID/EX rd=%2d rw=%b | EX/MEM rd=%2d rw=%b exres=%h | MEM/WB rd=%2d rw=%b wb=%h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d",
    $time,
    uut.pc,
    uut.if_instruction,
    uut.stall,
    uut.flush,
    uut.id_ex_rd, uut.id_ex_reg_write,
    uut.ex_mem_rd, uut.ex_mem_reg_write, uut.ex_mem_ex_result,
    uut.mem_wb_rd, uut.mem_wb_reg_write, uut.wb_write_back_data,
    uut.register_file_inst.registers[1],
    uut.register_file_inst.registers[2],
    uut.register_file_inst.registers[3],
    uut.register_file_inst.registers[4],
    uut.register_file_inst.registers[5]
    );

    clk = 0;
    reset = 1;

    #10;
    reset = 0;

    #300;

    $finish;

end

endmodule