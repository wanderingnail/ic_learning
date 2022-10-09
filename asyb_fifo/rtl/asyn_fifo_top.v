module asyn_fifo_top #(
    parameter DATA_WD = 8,
    parameter ADDR_WD = 4
)(
    input                  wclk,
    input                  wrst_n,
    input                  winc,
    input  [DATA_WD-1 : 0] wdata,
    output                 wfull,

    input                  rclk,
    input                  rrst_n,
    input                  rinc,
    output                 rempty,
    output [DATA_WD-1 : 0] rdata             
);

wire [ADDR_WD-1 : 0] wptr,    rptr;
wire                 afull_n, aempty_n;

mem #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD)
) mem(
    .wclk(wclk),
    .winc(winc),
    .wfull(wfull),
    .wdata(wdata),
    .rdata(rdata),
    .waddr(wptr),
    .raddr(rptr)
);

wptr_full #(
    .ADDR_WD(ADDR_WD)
) wptr_full(
    .wclk(wclk),
    .winc(winc),
    .wfull(wfull),
    .wrst_n(wrst_n),
    .afull_n(afull_n),
    .wptr(wptr)
);

rptr_empty #(
    .ADDR_WD(ADDR_WD)
) rptr_empty(
    .rclk(rclk),
    .rinc(rinc),
    .rempty(rempty),
    .rrst_n(rrst_n),
    .aempty_n(aempty_n),
    .rptr(rptr)
);

asyn_cmp #(
    .ADDR_WD(ADDR_WD)
) asyn_cmp(
    .rptr(rptr),
    .wptr(wptr),
    .wrst_n(wrst_n),
    .afull_n(afull_n),
    .aempty_n(aempty_n)
);

endmodule
