module stream_fork #(
    parameter DATA_BW = 8
) (
    input                  clk,
    input                  rst_n,

    input  [DATA_BW-1 : 0] a_data,
    input                  a_valid,
    output                 a_ready,

    output                 b_valid,
    output [DATA_BW-1 : 0] b_data,
    input                  b_ready,

    output                 c_valid,
    output [DATA_BW-1 : 0] c_data,
    input                  c_ready 
);

wire a_fire = a_valid && a_ready;
wire b_fire = b_valid && b_ready;
wire c_fire = c_valid && c_ready;

assign b_data = a_data;
assign c_data = a_data;
/*
assign a_ready = b_fire && c_fire;
assign b_valid = a_valid;
assign c_valid = a_valid;
*/

assign a_ready = b_ready && c_ready;
assign b_valid = a_fire;
assign c_valid = a_fire;

/*
assign a_ready = b_ready && c_ready;
assign b_valid = a_valid && !b_fire;
assign c_valid = a_valid && !c_fire;
*/

endmodule