module weighted_round_robin #(
    parameter REQ_NUM = 8
)(
    input                  clk,
    input                  rst_n, 
    input  [REQ_NUM-1 : 0] reqs,
    output [REQ_NUM-1 : 0] grants
);

localparam ADDR_WD = $clog2(REQ_NUM);

reg [REQ_NUM-1 : 0] mask_r;
reg [ADDR_WD   : 0] weights_r [REQ_NUM-1 : 0]; 
reg [ADDR_WD-1 : 0] grant_idx;

wire [REQ_NUM-1 : 0] masked_reqs     = reqs & mask_r;
wire [REQ_NUM-1 : 0] masked_grants   = masked_reqs & ~(masked_reqs - 1'b1);
wire [REQ_NUM-1 : 0] unmasked_grants = reqs & ~(reqs - 1'b1);
wire [REQ_NUM-1 : 0] grants          = has_maksed_reqs ? masked_grants : unmasked_grants;

wire has_maksed_reqs = |masked_reqs;
wire clean_weignts   = ~(|mask_r);

always @(*) begin
    grant_idx = 'b0;
    for (integer i = 0; i < REQ_NUM; i = i + 1) begin
        if (grants[i]) begin
            grant_idx = i;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < REQ_NUM; i = i + 1) begin
            weights_r[i] <= i + 1;
        end
    end
    else if (has_maksed_reqs) begin
        weights_r[grant_idx] <= weights_r[grant_idx] -1'b1;
    end
    else if (clean_weignts) begin
        for (integer i = 0; i < REQ_NUM; i = i + 1) begin
             weights_r[i] <= i + 1;
         end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mask_r <= {REQ_NUM{1'b1}};
    end
    else if (has_maksed_reqs) begin
        mask_r[grant_idx] <= weights_r[grant_idx] != 1;
    end
    else if (clean_weignts) begin
        mask_r <= {REQ_NUM{1'b1}};
    end
end

endmodule