`timescale 1ns/1ps

module data_memory_tb;

reg clk;
reg mem_write;
reg mem_read;
reg [31:0] address;
reg [31:0] write_data;

wire [31:0] read_data;

data_memory uut(
    .clk(clk),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $dumpfile("waveforms/data_memory.vcd");
    $dumpvars(0, data_memory_tb);

    $monitor(
        "Time=%0t addr=%d mem_write=%b mem_read=%b write_data=%d read_data=%d",
        $time,
        address,
        mem_write,
        mem_read,
        write_data,
        read_data
    );

    // -------------------------
    // Initial state
    // -------------------------
    mem_write  = 0;
    mem_read   = 0;
    address    = 0;
    write_data = 0;

    #10;

    // -------------------------
    // Write 25 to address 0
    // -------------------------
    mem_write  = 1;
    mem_read   = 0;
    address    = 0;
    write_data = 25;

    #10;

    // -------------------------
    // Read address 0
    // -------------------------
    mem_write = 0;
    mem_read  = 1;
    address   = 0;

    #10;

    // -------------------------
    // Write 100 to address 4
    // -------------------------
    mem_write  = 1;
    mem_read   = 0;
    address    = 4;
    write_data = 100;

    #10;

    // -------------------------
    // Read address 4
    // -------------------------
    mem_write = 0;
    mem_read  = 1;
    address   = 4;

    #10;

    // -------------------------
    // Read address 8
    // (should be 0 if never written)
    // -------------------------
    mem_write = 0;
    mem_read  = 1;
    address   = 8;

    #10;

    $finish;

end

endmodule