module valid_beats #(
    parameter DATA_WD =8
)(
    input                  clk,
    input                  rst_n,
    
    input                  valid_in,
    input  [DATA_WD-1 : 0] data_in,
    output                 ready_in,

    output                 valid_out,
    output [DATA_WD-1 : 0] data_out,
    input                  ready_out 
);

reg [DATA_WD-1 : 0] data_r;
reg                 valid_r;

wire fire_in  = valid_in  && ready_in;
wire fire_out = valid_out && ready_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_r <= 1'b0;
        data_r  <= 'b0;
    end
    else begin
        if (fire_out) begin
            valid_r <= 1'b0;
        end
        if (fire_in) begin
            valid_r <= 1'b1;
            data_r  <= data_in;
        end
    end
end

assign valid_out = valid_r;
assign data_out  = data_r;
assign ready_in  = ready_out;

endmodule