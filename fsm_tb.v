`include "fsm.v"
module fsm_tb;

  // Inputs
  reg [5:0] opcode;

  // Outputs
  wire ALUOp1, ALUOp0, RegDst, RegWrite, MemRead, MemWrite, Branch, Jump, JumpReg;

  // Instantiate the FSM module
  fsm uut(.opcode(opcode), .ALUOp1(ALUOp1), .ALUOp0(ALUOp0), .RegDst(RegDst), .RegWrite(RegWrite),
          .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump), .JumpReg(JumpReg));

  // Generate clock signal
  reg clk = 0;
  always #5 clk = ~clk;

  // Test case 1: add instruction
  initial begin
    $display("Starting test case 1: add instruction");
    opcode = 4'b0000;
    #10;
    // assert(ALUOp1 == 0 && ALUOp0 == 0 && RegDst == 1 && RegWrite == 1 && MemRead == 0 && MemWrite == 0
    //        && Branch == 0 && Jump == 0 && JumpReg == 0);
    // $display("Test case 1 passed");
  end

  // Test case 2: lw instruction
  initial begin
    $display("Starting test case 2: lw instruction");
    opcode = 4'b1000;
    #10;
    // assert(ALUOp1 == 0 && ALUOp0 == 0 && RegDst == 0 && RegWrite == 1 && MemRead == 1 && MemWrite == 0
    //        && Branch == 0 && Jump == 0 && JumpReg == 0);
    // $display("Test case 2 passed");
  end

  // Test case 3: sub instruction
  initial begin
    $display("Starting test case 3: sub instruction");
    opcode = 4'b0010;
    #10;
    // assert(ALUOp1 == 1 && ALUOp0 == 0 && RegDst == 1 && RegWrite == 1 && MemRead == 0 && MemWrite == 0
    //        && Branch == 0 && Jump == 0 && JumpReg == 0);
    // $display("Test case 3 passed");
  end

  // Test case 4: beq instruction
  initial begin
    $display("Starting test case 4: beq instruction");
    opcode = 4'b0100;
    #10;
    // assert(ALUOp1 == 0 && ALUOp0 == 1 && RegDst == 0 && RegWrite == 0 && MemRead == 0 && MemWrite == 0
    //        && Branch == 1 && Jump == 0 && JumpReg == 0);
    // $display("Test case 4 passed");
  end

  // Test case 5: invalid opcode
  initial begin
    $display("Starting test case 5: invalid opcode");
    opcode = 4'b1111;
    #10;
    // assert(ALUOp1 == 0 && ALUOp0 == 0 && RegDst == 0 && RegWrite == 0 && MemRead == 0 && MemWrite == 0
    //        && Branch == 0 && Jump == 0 && JumpReg == 0);
    // $display("Test case 5 passed");
  end

endmodule
