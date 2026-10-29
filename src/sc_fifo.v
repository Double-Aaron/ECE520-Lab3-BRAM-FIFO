`timescale 1ns / 1ps


module sc_fifo #(
//Parameters 2.1 
parameter WIDTH = 16,
parameter DEPTH = 32,
parameter ALMOST_EMPTY_THRESHOLD = 1,
parameter ALMOST_FULL_THRESHOLD =31,
parameter READ_LATENCY =1
)

// 5 inputs
(
input wire clk,
input wire srst,
input wire [WIDTH-1:0] data_in,
input wire write_enable,
input wire read_enable,

//7 outputs
output wire [WIDTH-1:0] data_out,
output wire valid,
output wire full,
output wire empty,
output wire almost_full,
output wire almost_empty,
output wire [$clog2(DEPTH+1)-1:0] data_count
);

//pointer and counter widtha
localparam ADDR_WIDTH = $clog2(DEPTH);
localparam COUNT_WIDTH = $clog2(DEPTH+1);

//Bram Memory
(*ram_style ="block" *)
reg [WIDTH-1:0] memory [0:DEPTH-1];

//FIFO POINT
reg [ADDR_WIDTH-1:0] write_ptr;
reg [ADDR_WIDTH-1:0] read_ptr;

//# of stored words
reg [COUNT_WIDTH-1:0] count;

//Operations
wire write_success;
wire read_success;
assign write_success = write_enable && !full && !srst;
assign read_success = read_enable && !empty && !srst;

//outputs
assign data_count = count;
assign full = (count== DEPTH);
assign empty = (count == 0);
assign almost_full = (count >= ALMOST_FULL_THRESHOLD);
assign almost_empty = (count <= ALMOST_EMPTY_THRESHOLD);

//Bram and pointer write
always @(posedge clk) begin
if(srst) begin
write_ptr <=0;
end
else if(write_success) begin
memory[write_ptr] <= data_in;
write_ptr<= write_ptr +1'b1;
end
end

//pointer read
always @(posedge clk) begin
if(srst)
read_ptr <=0;
else if (read_success)
read_ptr <= read_ptr +1'b1;
end

//Word count
always @(posedge clk) begin
if (srst)
count <= 0;
else begin
case ({write_success, read_success})
2'b10: count <= count + 1'b1;
2'b01: count <= count - 1'b1;
default: count <= count;
endcase
end
end

//output OP
reg [WIDTH-1:0] data_pipe [0:READ_LATENCY-1];
reg [READ_LATENCY-1:0] valid_pipe;
integer i;

always @(posedge clk) begin
if (srst) begin
valid_pipe <= 0;
for (i = 0; i<READ_LATENCY; i=i+1)
data_pipe[i] <=0;
end

else begin
valid_pipe[0] <= read_success;
if (read_success)
data_pipe[0] <= memory[read_ptr];

for (i = 1; i < READ_LATENCY; i = i+1) begin
valid_pipe[i] <= valid_pipe[i-1];
data_pipe[i] <= data_pipe[i-1];
end
end
end
assign data_out = data_pipe[READ_LATENCY-1];
assign valid = valid_pipe[READ_LATENCY-1];
endmodule
