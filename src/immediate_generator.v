module immediate_generator(
    input [31:0] instruction,
    output reg [31:0] immediate
);

always @(*) begin
    case (instruction[6:0])
        
        //i type
        7'b0010011,
        7'b0000011:
        begin 
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        end

        //s type
        7'b0100011:
        begin
            immediate = {{20{instruction[31]}},
                        instruction[31:25], 
                        instruction[11:7]};
        end
        
        //b type 
        7'b1100011:
        begin
            immediate = {{19{instruction[31]}},
                        instruction[31], 
                        instruction[7], 
                        instruction[30:25], 
                        instruction[11:8], 
                        1'b0};
        end

        //u type
        7'b0110111,
        7'b0010111:
        begin
            immediate = {instruction[31:12], 12'b0};
        end

        //j type
        7'b1101111:
        begin 
            immediate = {{11{instruction[31]}},
                        instruction[31], 
                        instruction[19:12], 
                        instruction[20], 
                        instruction[30:21], 
                        1'b0};
        end

        default:
        begin
            immediate = 32'b0;
        end

    endcase

end

endmodule