module asyn_cmp #(
    parameter ADDR_WD = 4
)(
    input  [ADDR_WD-1 : 0] rptr,
    input  [ADDR_WD-1 : 0] wptr,
    input                  wrst_n,
    output                 afull_n,
    output                 aempty_n
);

reg  dir_r;
wire set_n, rst_n;

assign set_n = ~((wptr[ADDR_WD-1] ^ rptr[ADDR_WD-2]) && (wptr[ADDR_WD-2] ~^ rptr[ADDR_WD-1]));
assign rst_n = ~(!wrst_n | ((wptr[ADDR_WD-1] ~^ rptr[ADDR_WD-2]) && (wptr[ADDR_WD-2] ^ rptr[ADDR_WD-1])));

always @(negedge rst_n or negedge set_n) begin
    if (!rst_n) begin
        dir_r <= 1'b0;
    end
    else if (!set_n) begin
        dir_r <= 1'b1;
    end
end

assign afull_n  = ~(dir_r  && (rptr == wptr));
assign aempty_n = ~(~dir_r && (rptr == wptr));

endmodule