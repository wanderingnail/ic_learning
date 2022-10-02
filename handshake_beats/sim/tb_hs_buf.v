module tb_hs_buf ();

localparam HAL_CYCLE = 5;
localparam DATA_WD = 4;

reg clk;
reg rst_n;

reg                  valid_in;
reg  [DATA_WD-1 : 0] cnt_in;
reg                  ready_out;

wire [DATA_WD-1 : 0] data_in;
wire                 ready_in;
wire                 fire_in;
wire                 fire_out;
wire                 valid_out;
wire [DATA_WD-1 : 0] data_out;

assign data_in = cnt_in;

assign fire_in = valid_in && ready_in;
assign fire_out = valid_out && ready_out;

initial begin
    $dumpfile("hs_buf.vcd");
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

valid_beats #(
    .DATA_WD(DATA_WD)
) valid_beats(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .data_in(data_in),
    .ready_in(ready_in),
    .valid_out(valid_out),
    .data_out(data_out),
    .ready_out(ready_out)
);


localparam RANDOM_FIRE = 1'b1;

generate if (RANDOM_FIRE) begin // random fire

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_in <= 1'b0;
            cnt_in <= 'b0;
        end
        else begin
            if (!valid_in) begin
                valid_in <= $random;
            end
            else if (fire_in) begin
                valid_in <= $random;
                cnt_in <= cnt_in + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready_out <= 1'b1;
        end
        else begin
            ready_out <= $random;
        end
    end

end
else begin // fire always

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_in <= 1'b0;
            cnt_in <= 'b0;
        end
        else begin
            valid_in <= 1'b1;
            if (fire_in) begin
                cnt_in <= cnt_in + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready_out <= 1'b1;
        end
        else begin
            ready_out <= 1'b1;
        end
    end

end
endgenerate

endmodule
