module hs_round_robin #(
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

localparam ADDR_WD =  $clog2(REQ_NUM);

reg  [REQ_NUM-1 : 0] grants_r;
reg  [ADDR_WD-1 : 0] grant_idx;
reg                  lock_r;

wire [REQ_NUM-1 : 0] grants;

wire fire_out  = valid_out && ready_out;
wire has_grant = |grants;

weighted_round_robin #(
    .REQ_NUM(REQ_NUM)
) weighted_round_robin(
    .clk(clk),
    .rst_n(rst_n),
    .reqs(valid_in),
    .grants(grants)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lock_r   <= 1'b0;
        grants_r <= 'b0;
    end
    else begin
        if (!lock_r && has_grant) begin
            lock_r   <= 1'b1;
            grants_r <= grants;
        end
        else if (fire_out & last_out) begin
            lock_r   <= 1'b0;
            grants_r <= 'b0;
        end
    end
end

// one hot code to binary code
always @(*) begin
    grant_idx = 'b0;
    for (integer i = 0; i < REQ_NUM; i = i + 1) begin
        if (grants_r[i]) begin
            grant_idx = i;
        end
    end
end

assign ready_in  = {REQ_NUM{ready_out}} & grants_r;
assign valid_out = valid_in[grant_idx] & grants_r[grant_idx];
assign data_out  = data_in[grant_idx];
assign last_out  = last_in[grant_idx] & grants_r[grant_idx];

endmodule