`include "instruction_fetch.v"
module instruction_fetch_tb(clk,reset,pc,instruction);
    input clk,reset;
    output reg [8:0] pc=9'b000000000;
    output reg[31:0] instruction;
    wire [31:0]instruction_wire;
instruction_fetch uut(clk, 1'b0, 1'b0, pc, 0, 1'b0, instruction_wire);
always @(*) begin
    instruction <= instruction_wire; 
end
always @(posedge clk ) begin
    if(reset) begin
        pc<=0;
    end
    else begin
        pc <= pc + 1;
    end
        
    end
endmodule