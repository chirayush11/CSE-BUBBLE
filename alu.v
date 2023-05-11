`include "instruction_fetch.v"
module alu(
    clk,reset,instruction,out,a,b,addr
);
  input clk,reset;
   output [31:0]instruction;
  output reg[31:0] out,a,b;
  reg[8:0] pc=9'b000000000;
  reg [31:0] register[31:0];
  reg [31:0] p[4:0];
  reg [6:0]opcode;
  reg [31:0] datain=2;
  output reg [8:0] addr=0;
  reg write_enable=1'b0;
  instruction_fetch u1(.clk(clk), .rst(1'b0), .write_enable(write_enable), .address(addr),.mode(1'b1),.datain(datain),.dataout(instruction));
//   control u2(.opcode(instruction[5:0]), .write_enable(write_enable));
  integer i;
  reg[31:0] temp;
  initial begin
    for ( i= 0;i<32 ;i=i+1 ) begin
        register[i]=i;
    end
  end
  always @(negedge clk) begin
    if (opcode==12) begin
        register[a]=instruction;
        out=register[a];
      end
      addr=pc;
      write_enable=1'b0;
      
  end
  
  

  always@(posedge clk)
begin
    opcode=instruction[31:26];
    if(reset)begin
        for ( i= 0;i<32 ;i=i+1 ) begin
        register[i]=i;
        end
        pc=0;
    end
    case (instruction[31:26]) 
    0 : begin
        register[instruction[15:11]] = $signed(register[instruction[25:21]]) + $signed(register[instruction[20:16]]);     //data_path 0 means instruction is used for add
        a=register[instruction[25:21]];
        b=register[instruction[20:16]];
        out=register[instruction[15:11]];
         
    end 
    1 :begin
        register[instruction[15:11]] = $signed(register[instruction[25:21]]) - $signed(register[instruction[20:16]]);     //data_path 1 means instruction is used for sub
          a=register[instruction[25:21]];
          b=register[instruction[20:16]];
          out=register[instruction[15:11]];
           
    end 
    2 :begin
        register[instruction[15:11]]=register[instruction[25:21]]+register[instruction[20:16]];     //data_path 2 means instruction is used for addu
        a=register[instruction[25:21]];
        b=register[instruction[20:16]];
        out=register[instruction[15:11]];
         
    end 
    3 :begin
        register[instruction[15:11]]=register[instruction[25:21]]-register[instruction[20:16]];     //data_path 3 means instruction is used for subu
        a=register[instruction[25:21]];
        b=register[instruction[20:16]];
        out=register[instruction[15:11]];
         
    end
    4 :begin
        a=register[instruction[25:21]];
        register[instruction[20:16]] = $signed(register[instruction[25:21]]) + $signed(instruction[15:0]);       //data_path 4 means instruction is used for addi

        b=$signed(instruction[15:0]);
        out=register[instruction[20:16]];
         
    end
    5 :begin
        register[instruction[20:16]] = register[instruction[25:21]] + instruction[15:0];        //data_path 5 means instruction is used for addiu
        a=register[instruction[25:21]];
        b=instruction[15:0];
        out=register[instruction[20:16]];
         
    end
    6 :begin
        register[instruction[15:11]]=register[instruction[25:21]] & register[instruction[20:16]];        //data_path 6 means instruction is used for and
          a=register[instruction[25:21]];
          b=register[instruction[20:16]];
          out=register[instruction[15:11]];
         
    end
    7 :begin
        register[instruction[15:11]]=register[instruction[25:21]] | register[instruction[20:16]];         //data_path 7 means instruction is used for or
        a=register[instruction[25:21]];
        b=register[instruction[20:16]];
        out=register[instruction[15:11]];
         
    end
    8 :begin
        register[instruction[20:16]] = register[instruction[25:21]] & instruction[15:0];      //data_path 8 means instruction is used for andi
        a=register[instruction[25:21]];
        b=instruction[15:0];
        out=register[instruction[20:16]];
         
    end
    9 :begin
        register[instruction[20:16]] = register[instruction[25:21]] | instruction[15:0];        //data_path 9 means instruction is used for ori
        a=register[instruction[25:21]];
        b=instruction[15:0];
        out=register[instruction[20:16]];
         
    end
    10 :begin
        register[instruction[15:11]]=register[instruction[20:16]]<<register[instruction[10:6]];        //data_path 10 means instruction is used for sll
        a=register[instruction[20:16]];
        b=register[instruction[10:6]];
        out=register[instruction[15:11]];
         
    end
    11 :begin
        register[instruction[15:11]]=register[instruction[20:16]]>>register[instruction[10:6]];        //data_path 11 means instruction is used for srl
        a=register[instruction[20:16]];
        b=register[instruction[10:6]];
        out=register[instruction[15:11]];
         
    end
    12 :begin
        addr=$signed(register[instruction[25:21]])+$signed(instruction[15:0]);       //data_path 12 means instruction is used for lw
        // write_enable=1'b1;
        a=instruction[20:16];
        // b=instruction[15:0];
        b=addr;
    
    end
    13 :begin
        addr=$signed(register[instruction[25:21]])+$signed(instruction[15:0]);        //data_path 13 means instruction is used for sw
        datain=register[instruction[20:16]];
        write_enable=1'b1;
        // write_enable=1'b0;
        // register[instruction[20:16]]=instruction;
        a=addr;
        b=instruction[15:0];
        out=register[instruction[20:16]];
    end
    // Branch Operations
     14 : begin    //opcode value 14 means instruction is used for beq
            if(register[instruction[25:21]] == register[instruction[20:16]] )begin
                pc=pc+ $signed(instruction[15:0])-1;
            end
            

        end  
        15 : begin //opcode value 15 means instruction is used for bne
            if(register[instruction[25:21]] != register[instruction[20:16]] )begin
                a=register[instruction[25:21]];
                b=register[instruction[20:16]];
                out=1;
                pc=pc+ $signed(instruction[15:0])-1;
            end
            else begin
                out=0;
            end
            
        end
        16 : begin //opcode value 16 means instruction is used for bgt
            if(register[instruction[25:21]] > register[instruction[20:16]] )begin
                pc=pc+ $signed(instruction[15:0])-1;
            end
            
        end 
        17 : begin  //opcode value 17 means instruction is used for bgte
            if(register[instruction[25:21]] >= register[instruction[20:16]] )begin
                pc=pc+ $signed(instruction[15:0])-1;
            end
            
        end  
        18 : begin  //opcode value 18 means instruction is used for ble
            if(register[instruction[25:21]] < register[instruction[20:16]] )begin
                pc=pc+ $signed(instruction[15:0]);
            end
            
        end
       19 : begin  //opcode value 19 means instruction is used for bleq
            if(register[instruction[25:21]] <= register[instruction[20:16]] )begin
                pc=pc+ $signed(instruction[15:0]);
            end
            
        end
        20 : begin  //opcode value 20 means instruction is used for j 
                pc= $signed(instruction[15:0])-1;
        end
        21 : begin  //opcode value 21 means instruction is used for jr 
                pc=register[instruction[25:21]]-1;
            end
        22 : begin  //opcode value 22 means instruction is used for jal 
                register[31]=pc+1;
                pc=instruction[15:0]-1;
            end
        23 : begin
        
                register[instruction[20:16]]=instruction[15:0];
                a=instruction[15:0];
                b=instruction[20:16];
                out=register[instruction[20:16]];
            end
        24 : begin            //opcode value 24 means instruction is used for slt
            if(register[instruction[25:21]] < register[instruction[20:16]] )begin
                register[instruction[15:11]]=1;
            end
            else begin
                 register[instruction[15:11]]=0;
            end
            a=register[instruction[25:21]];
            b=register[instruction[20:16]];
            out=register[instruction[15:11]];
        end
        31 : begin 
            $monitor("Sorted Array:%d %d %d %d %d",register[17],register[18],register[19],register[20],register[21]);
        end
    endcase
    pc=pc+1;
end 
endmodule


// module control (
//     pc,opcode,write_enable
// );
//   input [9:0] pc;
//   input[5:0] opcode;
//   output reg write_enable;
//   wire [9:0] temp_pc;
//   wire mode;
//   always @(posedge clk) begin
//     if(mode==1'b1) begin
//         pc=temp_pc;
//   end
//     if(opcode==6'b001101) begin
//     write_enable=1;
//   end
//   else begin
//     write_enable=0;
//   end

//    if(opcode==6'b001100) begin
//     temp_pc=pc;
//     mode=1'b1;
//   end
//   end

// endmodule