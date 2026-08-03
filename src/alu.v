`timescale 1ns/1ps
module alu(
    input [31:0] a,
    input [31:0] b,

    input [3:0] alu_control,
    
    output reg [31:0] result,
    output zero
);

always @(*) begin
    case (alu_control)
        4'b0000: begin
            result = a + b;
        end

        4'b0001: begin
            result = a - b;
        end

        4'b0010: begin
            result = a & b;
        end

        4'b0011: begin
            result = a | b;
        end

        4'b0100: begin
            result = a ^ b;
        end

        4'b0101: begin
            if ($signed(a) < $signed(b))
                result = 32'd1;
            else
                result = 32'd0;
        end

        default: begin
            result = 32'b0;
        end

    endcase

end

assign zero = (result == 32'b0);

endmodule