module rptr_empty #(
    parameter ADDR_WD = 4
)(
    input                  rclk,
    input                  rrst_n,
    input                  rinc,
    input                  aempty_n,
    output                 rempty,
    output [ADDR_WD-1 : 0] rptr
);

reg  [ADDR_WD-1 : 0] rbin_r, rgray_r;
reg                  rq1_r,  rq2_r;
wire [ADDR_WD-1 : 0] rbnext, rgnext;

assign rbnext = rbin_r + (rinc && !rempty);
assign rgnext = (rbnext >> 1) ^ rbnext;
assign rptr   =  rgray_r;

always @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
        {rbin_r, rgray_r} <= 'b0;
    end
    else begin
        {rbin_r, rgray_r} <= {rbnext, rgnext};
    end
end

always @ (posedge rclk or negedge rrst_n or negedge aempty_n) begin
    if (!rrst_n) begin
        {rq1_r, rq2_r} <= 'b0;
    end
    else if (!aempty_n) begin
        {rq1_r, rq2_r} <= 2'b11;
    end
    else begin
        {rq1_r, rq2_r} <= {~aempty_n, rq1_r};
    end
end

assign rempty = rq2_r;

endmodule
    