module receiver (
    clk,
    i_Serial_Data,
    o_DV,
    o_Byte
    );

    parameter FREQUENCY = 87;

    input clk;
    input i_Serial_Data;

    output o_DV;
    output [7:0] o_Byte;

    reg r_Data_Temp = 1'b1;
    reg r_Data   = 1'b1;
    reg r_DV = 0;

    reg [7:0] r_Counter = 0;
    reg [2:0] r_Index = 0; 
    reg [7:0] r_Byte = 0;

    reg [2:0] r_State = 0;
    reg [2:0] r_State_Idle = 3'd0;
    reg [2:0] r_State_Start = 3'd1;
    reg [2:0] r_State_Start_Bits = 3'd2;
    reg [2:0] r_State_Stop_Bit = 3'd3;
    reg [2:0] r_State_Refresh = 3'd4;

    always @(posedge clk) begin
        r_Data_Temp <= i_Serial_Data;
        r_Data <= r_Data_Temp;
    end

    always @(posedge clk) begin
        
        case (r_State)
    
            r_State_Idle: begin
                r_DV <= 1'b0;
                r_Counter <= 0;
                r_Index <= 0;
                    
                if (r_Data == 1'b0)          
                    r_State <= r_State_Start;
                else
                    r_State <= r_State_Idle;
            end
                
            r_State_Start: begin
                if (r_Counter == (FREQUENCY-1)/2) begin
                    if (r_Data == 1'b0) begin
                        r_Counter <= 0; 
                        r_State <= r_State_Start_Bits;
                    
                    end
                    else
                        r_State <= r_State_Idle;
                end

                else begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_State_Start;
                end
            end 
                
            r_State_Start_Bits: begin
                if (r_Counter < FREQUENCY-1) begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_State_Start_Bits;
                end

                else begin
                    r_Counter <= 0;
                    r_Byte[r_Index] <= r_Data;
                        
                    if (r_Index < 7) begin
                        r_Index <= r_Index + 1;
                        r_State <= r_State_Start_Bits;
                    end
                    else begin
                        r_Index <= 0;
                        r_State <= r_State_Stop_Bit;
                    end
                end
            end 
            
            r_State_Stop_Bit: begin
                if (r_Counter < FREQUENCY-1) begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_State_Stop_Bit;
                end

                else begin
                    r_DV <= 1'b1;
                    r_Counter <= 0;
                    r_State <= r_State_Refresh;
                end
            end 
            
            r_State_Refresh: begin
                r_State <= r_State_Idle;
                r_DV <= 1'b0;
            end
                
            default :
                r_State <= r_State_Idle;
            
        endcase
    end   

    assign o_DV = r_DV;
    assign o_Byte = r_Byte;

endmodule 