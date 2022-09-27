module round_robin #(
    parameter REQ_NUM = 8
)(
    input                  clk,
    input                  rst_n, 
    input  [REQ_NUM-1 : 0] reqs,
    output [REQ_NUM-1 : 0] grants
);

req [REQ_NUM-1 : 0] mask;

wire masked_reqs   = reqs & mask;
wire masked_grants = masked_reqs & ~(masked_reqs - 1'b1);
wire unmasked_grants = reqs & ~(reqs - 1'b1);

grants = |masked_reqs ? masked_grants : unmasked_grants;
 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mask <= 'b1;
    end
    else if (|masked_grants) begin
        mask <= ~((grants - 1'b1) | grants);
    end
    else if (~(|mask)) begin
        mask <= 'b1;
    end
end

endmodule