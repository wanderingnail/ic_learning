module valid_beats #(
    parameter DATA_WD =8
)(
    input                  clk,
    input                  rst_n,
    
    input                  valid_in,
    input  [DATA_WD-1 : 0] data_in,
    output                 ready_in,

    output                 valid_out,
    output [DATA_WD-1 : 0] data_out,
    input                  ready_out 
);

wire [DATA_WD-1 : 0] data_mid;
wire                 valid_mid;
wire                 ready_mid;

wire fire_in  = valid_in  && ready_in;
wire fire_out = valid_out && ready_out;

ready_beats #(
    .DATA_WD(DATA_WD)
) ready_beats(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .ready_in(ready_in),
    .data_in(data_in),
    .valid_out(valid_mid),
    .ready_out(ready_mid),
    .data_out(data_mid)
);

valid_beats #(
    .DATA_WD(DATA_WD)
) valid_beats(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_mid),
    .ready_in(ready_mid),
    .data_in(data_mid),
    .valid_out(valid_out),
    .ready_out(ready_out),
    .data_out(data_out)
);

endmodule