module apb_tx #(
    parameter DATA_BW = 8,
    parameter ADDR_BW = 8
)(
    input                        clk,
    input                        rst_n,
    input  [DATA_BW+ADDR_BW : 0] cmd_in,
    input                        cmd_vld,
    input  [DATA_BW-1 : 0]       prdata,
    input                        pready,
    output                       cmd_rdy,
    output                       psel,
    output                       penable,
    output                       pwrite,
    output [ADDR_BW-1 : 0]       paddr,
    output [DATA_BW-1 : 0]       pwdata,
    output [DATA_BW-1 : 0]       read_data,
    output                       read_vld
);

reg [DATA_BW+ADDR_BW : 0] cmd_in_r;

reg [1 : 0] cur_state;
reg [1 : 0] next_state;

reg [DATA_BW-1 : 0] read_data_r;

reg  psel_r;
reg  penable_r;
reg  cmd_rdy_r;
reg  read_vld_r;

wire cmd_fire = cmd_vld && cmd_rdy;

localparam IDLE = 2'b00,
           SEL  = 2'b01,
           ACCE = 2'b10;
    
assign pwdata   = cmd_in_r[DATA_BW-1 : 0];
assign paddr    = cmd_in_r[DATA_BW+ADDR_BW-1 : DATA_BW];
assign pwrite   = cmd_in_r[DATA_BW+ADDR_BW];

assign psel      = psel_r;
assign penable   = penable_r;
assign cmd_rdy   = cmd_rdy_r;
assign read_vld  = read_vld_r;
assign read_data = read_data_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= 'b0;
    end
    else begin
        cur_state <= next_state;
    end
end

always @(*) begin
    next_state = IDLE;
    case (cur_state)
        IDLE: next_state = cmd_fire ? SEL : IDLE;
        SEL:  next_state = ACCE;
        ACCE: next_state = pready ? IDLE : ACCE;
    endcase
end

always @(*) begin
    psel_r     = 0;
    penable_r  = 0;
    cmd_rdy_r  = 0;
    read_vld_r = 0;
    case (cur_state)
        IDLE: cmd_rdy_r = 1;
        SEL:  psel_r    = 1;  
        ACCE: begin
            psel_r    = 1;
            penable_r = 1;
            if (!pwrite && pready) begin
                read_vld_r = 1;
            end
        end
    endcase
end
    
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cmd_in_r <= 'b0;
    end
    else if (cmd_fire) begin
        cmd_in_r <= cmd_in;
    end
end
        
/********************************************* woudl delay a clk
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {pwrite_r, paddr_r, pwdata_r} <= 'b0;
    end
    else if(cmd_fire)
       {pwrite_r, paddr_r, pwdata_r} <= cmd_in_r;
end   
**************************************************/
    
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_r <= 'b0;
    end
    else if (!pwrite) begin
        read_data_r <= prdata;
    end
end
    
endmodule
