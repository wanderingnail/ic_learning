module apb_rx #(
    parameter DATA_BW = 8,
    parameter ADDR_BW = 8
)(
    input                    clk,
    input                    rst_n,
    input                    psel,
    input                    penable,
    input                    pwrite,
    input  [ADDR_BW - 1 : 0] paddr,
    input  [DATA_BW - 1 : 0] pwdata,
    output [DATA_BW - 1 : 0] prdata,
    output                   pready
);
    reg [DATA_BW - 1 : 0] mem [(1<<ADDR_BW) - 1 : 0];

    reg [1 : 0] cur_state;
    reg [1 : 0] next_state;

    localparam IDLE = 2'b00,
               SEL  = 2'b01,
               ACCE = 2'b10;

    assign pready = 1;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        next_state = IDLE;
        case(cur_state)
            IDLE: next_state = psel ? SEL : IDLE;
            SEL:  next_state = ACCE;
            ACCE: begin
                if(pready)
                    next_state = psel ? SEL : IDLE;
                else
                    next_state = ACCE;
            end
        endcase
    end


    always @(posedge clk or negedge rst_n) begin
        if(pwrite && pready)
            mem[paddr] <= pwdata;
    end

    assign prdata = mem[paddr];

endmodule