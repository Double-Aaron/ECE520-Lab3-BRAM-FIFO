`timescale 1ns / 1ps

module tb_sc_fifo;

//clock
reg clk;
initial clk =0;
always #10 clk = ~clk;

//inputs
reg srst;
reg [15:0] data_in;
reg write_enable;
reg read_enable;

//outputs
wire [15:0] data_out;
wire valid;
wire full;
wire empty;
wire almost_full;
wire almost_empty;
wire [5:0] data_count;

//Dut
sc_fifo dut (
.clk(clk),
.srst(srst),
.data_in(data_in),
.write_enable(write_enable),
.read_enable(read_enable),
.data_out(data_out),
.valid(valid),
.full(full),
.empty(empty),
.almost_full(almost_full),
.almost_empty(almost_empty),
.data_count(data_count)
);

integer i;
reg [15:0] expected_data;
reg [15:0] test_data [0:31];

initial begin
$readmemh("input_data.txt", test_data);

//Test reset behavior
srst =1;
data_in =0;
write_enable =0;
read_enable =0;

repeat (2) @(negedge clk);
srst =0;
#1;

if (empty !== 1'b1 || full !== 1'b0 || data_count !== 6'b0 || valid !== 1'b0 || data_out !== 16'h0000)
$fatal(1, "Fail reset");
else 
$display("pass reset");

//Test data pattens 1's and 0's
for(i=0; i<4;i=i+1) begin
@(negedge clk);
write_enable =1;
case(i)

0: expected_data = 16'hFFFF;
1: expected_data = 16'h0000;
2: expected_data = 16'hAAAA;
3: expected_data = 16'h5555;
endcase

data_in = expected_data;
@(negedge clk);
write_enable = 0;
read_enable = 1;

@(posedge clk);
#1;

if (valid !== 1'b1 || data_out !== expected_data)
$fatal(1, "Fail: Pattern %0d", i);

@(negedge clk);
read_enable = 0;

end
$display("Data patterns passed");

//TEST 3: Fill all 32 locations
@(negedge clk);
write_enable = 1;
read_enable = 0;

for (i = 0; i < 32; i = i + 1) begin
data_in = test_data[i];
@(negedge clk);
end

write_enable = 0;
#1;

if (full !== 1'b1 ||
almost_full !== 1'b1 ||
data_count !== 6'd32)
$fatal(1, "FAIL: Full FIFO");

// Read all 32 locations
for (i = 0; i < 32; i = i + 1) begin

@(negedge clk);
read_enable = 1;

@(posedge clk);
#1;

if (valid !== 1'b1 || data_out !== test_data[i])
$fatal(1, "FAIL: Read index %0d", i);
@(negedge clk);
read_enable = 0;

end

#1;

if (empty !== 1'b1 ||
almost_empty !== 1'b1 ||
data_count !== 6'd0)
$fatal(1, "FAIL: Empty FIFO");
$display("PASS: Full/Empty FIFO");


// TEST 4: Disabled read/write
@(negedge clk);
write_enable = 0;
read_enable = 0;
data_in = 16'hAAAA;

repeat(2) @(posedge clk);
#1;

if (data_count !== 6'd0 ||
empty !== 1'b1 ||
valid !== 1'b0)
$fatal(1, "FAIL: Enable test");

$display("PASS: Enable test");

$display("ALL TESTS PASSED");

$finish;
end

endmodule
