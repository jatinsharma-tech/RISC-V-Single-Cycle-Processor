module pc(
    input clk,
    input reset,
    output reg[31:0] pc
);

always@(posedge clk or posedge reset)
begin
    if(reset)
        pc<= 32'd0;
    else
        pc<= pc + 32'd4;
end
endmodule