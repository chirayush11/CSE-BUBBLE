module veda (
  input clk, // clock input
  input mode, // memory mode input
  input [4:0] address, // address input
  input [31:0] data_in, // input data
  output reg [31:0] data_out // output data
);

reg [31:0] mem [0:31]; // 32x32 memory

always @(posedge clk) begin
  if (mode == 0) begin // scribble mode
    mem[address] <= data_in; // write data to memory
    data_out <= data_in; // output input data
  end else begin // interpret mode
    data_out <= mem[address]; // output data from memory
  end
end

endmodule


// This code defines a module called single_port_memory that has inputs for the clock signal (clk), the memory mode (mode),the memory address
// (address), and the input data (data_in), as well as an output for the output data (data_out).
// Inside the module, there is a 32x32 memory array (mem) that is defined using a register (reg) data type. The always block is triggered 
// on every positive edge of the clock signal (posedge clk). If the memory is in scribble mode (mode == 0), the input data is written to the
// memory at the specified address (mem[address] <= data_in) and also driven to the output port (data_out <= data_in). If the memory is in
// interpret mode (mode == 1), the data previously written in the memory will be provided at the output port (data_out <= mem[address]).