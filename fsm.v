module fsm(
  input [5:0] opcode,
  output reg ALUOp1,
  output reg ALUOp0,
  output reg RegDst,
  output reg RegWrite,
  output reg MemRead,
  output reg MemWrite,
  output reg Branch,
  output reg Jump,
  output reg JumpReg
);

  // Define the state variables
  parameter START = 0, BEQ_INSTR = 1, REG_WRITE = 2, SUB = 3;
  reg [1:0] state = START;

  always @(*) begin
    // Default values for control signals
    ALUOp1 = 0;
    ALUOp0 = 0;
    RegDst = 0;
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 0;
    Branch = 0;
    Jump = 0;
    JumpReg = 0;
    
    // State machine logic
    case (state)
      START:
        if (opcode == 4'b0100) begin // beq instruction
          ALUOp1 = 0;
          ALUOp0 = 1;
          Branch = 1;
          state = BEQ_INSTR;
        end
        else if (opcode == 4'b1000) begin // lw instruction
          ALUOp1 = 0;
          ALUOp0 = 0;
          MemRead = 1;
          state = REG_WRITE;
        end
        else if (opcode == 4'b0000) begin // add instruction
          ALUOp1 = 0;
          ALUOp0 = 0;
          RegWrite = 1;
          RegDst = 1;
          state = REG_WRITE;
        end
        else if (opcode == 4'b0010) begin // sub instruction
          ALUOp1 = 1;
          ALUOp0 = 0;
          RegWrite = 1;
          RegDst = 1;
          state = SUB;
        end
        else begin
          // Invalid opcode
          state = START;
        end
        
      BEQ_INSTR:
        // TODO: add BEQ_INSTR state logic
        state = START;
        
      REG_WRITE:
        // TODO: add REG_WRITE state logic
        state = START;
        
      SUB:
        // TODO: add SUB state logic
        state = START;
    endcase
  end

endmodule
