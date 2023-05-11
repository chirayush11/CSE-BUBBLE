module instruction_decode(
  input [31:0] instruction,
  input [4:0] opcode,
  output reg [4:0] alu_op,
  output reg [1:0] data_src,
  output reg [1:0] reg_write,
  output reg [4:0] branch_op,
  output reg [4:0] jump_op
);

  always @* begin
    // default values
    alu_op = 0;
    data_src = 0;
    reg_write = 0;
    branch_op = 0;
    jump_op = 0;
    
    // decode R-type instructions
    if (opcode == 5'b00000) begin // add, sub, addu, subu, and, or, slt
      case (instruction[5:0])
        6'b100000: alu_op = 5'b00000; // add
        6'b100010: alu_op = 5'b00001; // sub
        6'b100001: alu_op = 5'b00010; // addu
        6'b100011: alu_op = 5'b00011; // subu
        6'b100100: alu_op = 5'b00100; // and
        6'b100101: alu_op = 5'b00101; // or
        6'b101010: alu_op = 5'b00110; // slt
        default: $fatal("Unknown R-type instruction"); // assert statement for nexception handling
      endcase
      data_src = 2'b11;
      reg_write = 2'b10;
    end
    
    // decode I-type instructions
    else if (opcode == 5'b00100) begin // addi, addiu, andi, ori, lw, sw, slti
      case (instruction[15:11])
        5'b00100: begin // addi, addiu
          alu_op = instruction[31] ? 5'b00001 : 5'b00000;
          data_src = 2'b10;
          reg_write = 2'b10;
        end
        5'b00110: begin // ori
          alu_op = 5'b00101;
          data_src = 2'b10;
          reg_write = 2'b10;
        end
        5'b0011: begin // andi
          alu_op = 5'b00100;
          data_src = 2'b10;
          reg_write = 2'b10;
        end
        5'b10011: begin // lw
          alu_op = 5'b00000;
          data_src = 2'b10;
          reg_write = 2'b10;
        end
        5'b10111: begin // sw
          alu_op = 5'b00000;
          data_src = 2'b11;
          reg_write = 2'b00;
        end
        5'b01010: begin // slti
          alu_op = 5'b00110;
          data_src = 2'b10;
          reg_write = 2'b10;
        end
        default: $fatal("Unknown I-type instruction"); // assert statements to check the discrepancies
      endcase
    end
    
    // decode conditional branch instructions
else if (opcode == 5'b01000) begin // beq, bne, blez, bgtz
  case (instruction[15:11])
    5'b0010: begin // beq
      alu_op = 5'b01000;
      data_src = 2'b01;
      branch_op = 5'b00001;
    end
    5'b0101: begin // bne
      alu_op = 5'b01001;
      data_src = 2'b01;
      branch_op = 5'b00001;
    end
    5'b00110: begin // blez
      alu_op = 5'b10000;
      data_src = 2'b10;
      branch_op = 5'b00001;
    end
    5'b00100: begin // bgtz
      alu_op = 5'b10001;
      data_src = 2'b10;
      branch_op = 5'b00001;
    end
    default: $fatal("Unknown conditional branch instruction"); // assert statements to check discrepancies
  endcase
end

// decode jump and jump-register instructions
else if (opcode == 5'b01001) begin // j, jal, jr
  case (instruction[31:26])
    6'b000010: begin // j
      jump_op = 5'b00001;
    end
    6'b000011: begin // jal
      jump_op = 5'b00010;
      reg_write = 2'b01;
    end
    6'b001000: begin // jr
      alu_op = 5'b01100;
      data_src = 2'b01;
    end
    default: $fatal("Unknown jump instruction"); // assert statements
  endcase
end

else begin
  $fatal("Unknown instruction opcode"); // assert styatements
end
  end
  endmodule
         
