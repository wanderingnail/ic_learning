module fork_tb;

localparam DATA_BW = 4;

reg clk;
reg rst_n;

wire [DATA_BW-1 : 0] a_data;
reg                  a_valid;
reg                  b_ready;
reg                  c_ready;

wire [DATA_BW-1 : 0] b_data;
wire                 a_ready;
wire                 b_valid;
wire                 c_valid;
wire [DATA_BW-1 : 0] c_data;

reg  [DATA_BW-1 : 0] cnt_in;

wire a_fire = a_valid && a_ready;

initial begin
    $dumpfile("fork.vcd");
    $dumpvars;
end

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst_n = 0;
    #100 rst_n = 1;
    #5000 $finish;
end

always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_valid <= 1'b0;
            cnt_in  <= 'b0;
        end
        else begin
            if (!a_valid) begin
                a_valid <= $random;
            end
            else if (a_fire) begin
                a_valid <= $random;
                cnt_in <= cnt_in + 1'b1;
            end
        end
end

assign a_data = cnt_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        b_ready <= 1'b1;
        c_ready <= 1'b1;
    end
     else begin
        b_ready <= $random;
        c_ready <= $random;
      end
end

stream_fork #(
    .DATA_BW(DATA_BW)
) stream_fork(
    .clk(clk),
    .rst_n(rst_n),
    .a_data(a_data),
    .a_ready(a_ready),
    .a_valid(a_valid),
    .b_data(b_data),
    .b_ready(b_ready),
    .b_valid(b_valid),
    .c_data(c_data),
    .c_valid(c_valid),
    .c_ready(c_ready)
);

endmodule

