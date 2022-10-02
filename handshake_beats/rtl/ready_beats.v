module ready_beats #(
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
reg                 ready_r;

wire fire_in  = valid_in  && ready_in;
wire fire_out = valid_out && ready_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_r <= 1'b0;
        data_r  <=  'b0;
    end
    else begin
        if (ready_in && !ready_out) begin
            valid_r <= valid_in;
            data_r  <= data_in;
        end
        else if (ready_out && !ready_in) begin
            valid_r <= 1'b0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready_r <= 1'b0;
    end
    else begin
        ready_r <= ready_out;
    end
end

assign valid_out = valid_in || valid_r;
assign data_out  = valid_r ? data_r : data_in;
assign ready_in  = ready_r  || !valid_r;

endmodule