module mem #(
    parameter DATA_WD = 8,
    parameter ADDR_WD = 4
)(
    input                  wclk,
    input                  winc,
    input                  wfull,
    input  [DATA_WD-1 : 0] wdata,
    input  [ADDR_WD-1 : 0] waddr,
    input  [ADDR_WD-1 : 0] raddr,
    output [DATA_WD-1 : 0] rdata             
);

localparam DEPTH = 1 << ADDR_WD;

reg [DATA_WD-1 : 0] mem [DEPTH-1 : 0];

always @(posedge wclk) begin
    if (winc && !wfull) begin
        mem[waddr] <= wdata;
    end
end

assign rdata = mem[raddr];

endmodule