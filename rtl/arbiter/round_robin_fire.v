module round_robin_fire #(
    parameter REQ_NUM = 8
)(
    input                  clk,
    input                  rst_n,

    input  [REQ_NUM-1 : 0] valid_in,
    input  [REQ_NUM-1 : 0] data_in,
    input  [REQ_NUM-1 : 0] last_in,
    output [REQ_NUM-1 : 0] ready_in,

    output                 valid_out,
    output                 data_out,
    output                 last_out,
    input                  ready_out
);

wire [REQ_NUM-1 : 0] grants;

round_robin #(
    .REQ_NUM(REQ_NUM)
) round_robin(
    .clk(clk),
    .rst_n(rst_n),
    .reqs(valid_in),
    .grants(grants)
);