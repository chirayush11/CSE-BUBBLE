`include "instruction_decode.v"
module instruction_decode_tb;

  // Inputs
  reg [31:0] instruction;
  reg [4:0] opcode;

  // Outputs
  wire [4:0] alu_op;
  wire [1:0] data_src;
  wire [1:0] reg_write;
  wire [4:0] branch_op;
  wire [4:0] jump_op;

  // Instantiate the unit under test (UUT)
  instruction_decode uut (
    .instruction(instruction),
    .opcode(opcode),
    .alu_op(alu_op),
    .data_src(data_src),
    .reg_write(reg_write),
    .branch_op(branch_op),
    .jump_op(jump_op)
  );

  initial begin
    // Test R-type instruction decoding
    opcode = 5'b00000;
    instruction = 32'h00431020; // add $v0, $v0, $s3
    #10;
    if (alu_op != 5'b00000 || data_src != 2'b11 || reg_write != 2'b10 ||
        branch_op != 5'b00000 || jump_op != 5'b00000)
      $fatal("Test failed: R-type instruction decoding");

    // Test I-type instruction decoding
    opcode = 5'b00100;
    instruction = 32'h20310234; // addi $s1, $s1, 4660
    #10;
    if (alu_op != 5'b00000 || data_src != 2'b10 || reg_write != 2'b10 ||
        branch_op != 5'b00000 || jump_op != 5'b00000)
      $fatal("Test failed: I-type instruction decoding");

    // Test conditional branch instruction decoding
    opcode = 5'b01000;
    instruction = 32'h10a0fffb; // beq $s4, $zero, -5
    #10;
    if (alu_op != 5'b01000 || data_src != 2'b01 || reg_write != 2'b00 ||
        branch_op != 5'b00001 || jump_op != 5'b00000)
      $fatal("Test failed: conditional branch instruction decoding");

    // Test jump instruction decoding
    opcode = 5'b01001;
    instruction = 32'h08000010; // j 0x00400040
    #10;
    if (alu_op != 5'b00000 || data_src != 2'b00 || reg_write != 2'b00 ||
        branch_op != 5'b00000 || jump_op != 5'b00001)
      $fatal("Test failed: jump instruction decoding");

    $display("All tests passed");
    $finish;
  end

endmodule
