module wptr_full #(
    parameter ADDR_WD = 4
)(
    input                  wclk,
    input                  wrst_n,
    input                  winc,
    input                  afull_n,
    output                 wfull,
    output [ADDR_WD-1 : 0] wptr
);

reg  [ADDR_WD-1 : 0] wbin_r, wgray_r;
reg                  wq1_r,  wq2_r;
wire [ADDR_WD-1 : 0] wbnext, wgnext;

assign wbnext = wbin_r + (winc && !wfull);
assign wgnext = (wbnext >> 1) ^ wbnext;
assign wptr   =  wgray_r;

always @(posedge wclk or negedge wrst_n) begin
    if (!wrst_n) begin
        {wbin_r, wgray_r} <= 'b0;
    end
    else begin
        {wbin_r, wgray_r} <= {wbnext, wgnext};
    end
end

always @ (posedge wclk or negedge wrst_n or negedge afull_n) begin
    if (!wrst_n) begin
        {wq1_r, wq2_r} <= 'b0;
    end
    else if (!afull_n) begin
        {wq1_r, wq2_r} <= 2'b11;
    end
    else begin
        {wq1_r, wq2_r} <= {~afull_n, wq1_r};
    end
end

assign wfull = wq2_r;

endmodule
    