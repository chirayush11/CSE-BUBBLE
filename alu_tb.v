`include "alu.v"
module alu_branch_tb();
wire [31:0]instruction;
reg clk,reset;
wire [31:0] out,a,b;
wire[8:0] pc;
alu_branch uut(clk,reset,instruction,out,a,b,pc);
always #5 clk=~clk; 
initial begin
    $dumpfile("alu_branch_tb.vcd");
    $dumpvars(0,alu_branch_tb);
end
 initial begin
    clk=0;
    reset=0;
    #2050 $finish;

 end

//  initial begin
//      $monitor("time=%d,instruction=%b,out=%d,a=%d,b=%d,pc=%d",$time,instruction,out,a,b,pc);
//  end

endmodule