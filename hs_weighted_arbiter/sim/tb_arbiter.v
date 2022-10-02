module tb_arbiter;

localparam REQ_NUM = 8;

reg                  clk;
reg                  rst_n;

reg  [REQ_NUM-1 : 0] valid_in;
reg  [REQ_NUM-1 : 0] data_in;
reg  [REQ_NUM-1 : 0] last_in;
wire [REQ_NUM-1 : 0] ready_in;

wire                 valid_out;
wire                 data_out;
wire                 last_out;
reg                  ready_out;

reg  [3 : 0] counters [REQ_NUM-1 : 0];

wire [REQ_NUM-1 : 0] fire_in, last_fire_in;

assign fire_in      = valid_in & ready_in;
assign last_fire_in = fire_in & last_in;

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
    #2000;
    $finish;
end

initial begin
    $dumpfile("hs_round_robin.vcd");
    $dumpvars;
end

hs_round_robin #(
    .REQ_NUM(REQ_NUM)
) hs_round_robin(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),
    .last_in(last_in),
    .ready_in(ready_in),
    .valid_out(valid_out),
    .data_out(data_out),
    .last_out(last_out),
    .ready_out(ready_out)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready_out <= 'b0;
    end
    else begin
        ready_out <= $random;
    end
end

genvar idx;
generate 
    for (idx = 0; idx < REQ_NUM; idx = idx + 1) begin: inpu
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                valid_in[idx] <= 1'b0;
                data_in[idx]  <= 1'b0;
                last_in[idx]  <= 1'b0;
                counters[idx] <=  'b0;
            end
            else begin 
                if (!valid_in[idx] || last_fire_in[idx]) begin
                    valid_in[idx] <= $random;
                    data_in[idx]  <= $random;
                    last_in[idx]  <= 1'b0;
                    counters[idx] <= $random + 1'b1;
                end
                if (fire_in[idx]) begin
                    counters[idx] <= counters[idx] - 1'b1;
                    if (counters[idx] == 1'b1) begin
                        last_in[idx] <= 1'b1;
                    end
                end
            end
        end
    end
endgenerate

endmodule

