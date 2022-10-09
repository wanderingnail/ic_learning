module tb_asyn_fifo;

parameter DATA_WD = 8;
parameter ADDR_WD = 4;

reg                  wclk;
reg                  wrst_n;
reg                  winc;
reg  [DATA_WD-1 : 0] wdata;
wire                 wfull;

reg                  rclk;
reg                  rrst_n;
reg                  rinc;
wire                 rempty;
wire [DATA_WD-1 : 0] rdata;

initial begin
    $dumpfile("asyn_fifo.vcd");
    $dumpvars;
end

initial begin
    wclk = 1'b0;
    forever begin
        #3;
        wclk = ~wclk;
    end
end

initial begin
    rclk = 1'b0;
    forever begin
        #6;
        rclk = ~rclk;
    end
end

initial begin
    winc   = 1'b1;
    rinc   = 1'b1;
    wrst_n = 1'b0;
    rrst_n = 1'b0;
    #2;
    wrst_n = 1'b1;
    rrst_n = 1'b1;
    #400;
    $finish;
end

always #5 begin
    wdata = {$random} % 128;
end

asyn_fifo_top #(
    .ADDR_WD(ADDR_WD),
    .DATA_WD(DATA_WD)
) asyn_fifo_top(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .wfull(wfull),
    .wdata(wdata),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .rdata(rdata),
    .rempty(rempty)
);

endmodule