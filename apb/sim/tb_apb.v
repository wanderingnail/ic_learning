module tb_apb;

localparam DATA_BW = 4,
           ADDR_BW = 4;
               
reg                        clk;
reg                        rst_n;

reg  [DATA_BW+ADDR_BW : 0] cmd_in;
reg                        cmd_vld;
wire                       cmd_rdy;

wire [DATA_BW-1 : 0]       prdata;
wire                       pready;
wire                       psel;
wire                       penable;
wire                       pwrite;
wire [ADDR_BW-1 : 0]       paddr;
wire [DATA_BW-1 : 0]       pwdata;
wire [DATA_BW-1 : 0]       read_data;
wire                       read_vld;

reg [4 : 0] cnt;
    
wire cmd_fire = cmd_rdy && cmd_vld;
    
initial begin
    $dumpfile("apb.vcd");
    $dumpvars;
end

initial begin
    clk = 0;
    forever begin
        #5;
        clk = ~clk;
    end
end

initial begin
    rst_n = 0;
    #3;
    rst_n = 1;
    #1000;
    $finish;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 'b0;
    end
    else if (cmd_fire) begin
        cnt <= cnt + 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
        cmd_vld <= 'b0;
        cmd_in  <= 'b0;
    end
    else begin
        cmd_vld <= 1'b1;
        cmd_in  <= {~cnt[4],cnt[3:0],cnt[3:0]};
    end
end
    

apb_tx #(
    .DATA_BW(DATA_BW),
    .ADDR_BW(ADDR_BW)
) apb_tx(
    .clk(clk),
    .rst_n(rst_n),
    .cmd_in(cmd_in),
    .cmd_rdy(cmd_rdy),
    .cmd_vld(cmd_vld),
    .read_vld(read_vld),
    .read_data(read_data),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
);

apb_rx #(
    .DATA_BW(DATA_BW),
    .ADDR_BW(ADDR_BW)
) apb_rx(
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
);
    
endmodule


