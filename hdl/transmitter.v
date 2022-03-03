module transmitter (
    clk,
    i_DV,
    i_Byte, 
    o_Sig_Active,
    o_Serial_Data,
    o_Sig_Done
    );

    
    parameter FREQUENCY = 87;

    input clk;
    input i_DV;
    input [7:0] i_Byte; 

    output o_Sig_Active;
    output reg o_Serial_Data;
    output o_Sig_Done;

    reg [7:0] r_Counter = 0;
    reg [2:0] r_Index = 0;
    reg [7:0] r_Data = 0;
    reg r_Done = 0;
    reg r_Active = 0;

    reg [2:0] r_State = 0;
    reg [2:0] r_State_Idle = 3'b000;
    reg [2:0] r_State_Start = 3'b001;
    reg [2:0] r_Start_Data_Bits = 3'b010;
    reg [2:0] r_State_Stop_Bit = 3'b011;
    reg [2:0] r_State_Refresh = 3'b100;
        
    always @(posedge clk) begin
        
        case (r_State)
            r_State_Idle: begin
                o_Serial_Data <= 1'b1;         
                r_Done <= 1'b0;
                r_Counter <= 0;
                r_Index <= 0;
                    
                if (i_DV == 1'b1) begin
                    r_Active <= 1'b1;
                    r_Data <= i_Byte;
                    r_State <= r_State_Start;
                end

                else
                    r_State <= r_State_Idle;
            end 
            
            r_State_Start: begin
                o_Serial_Data <= 1'b0;
                
                if (r_Counter < FREQUENCY-1) begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_State_Start;
                end

                else begin
                    r_Counter <= 0;
                    r_State <= r_Start_Data_Bits;
                end
            end 
                
            r_Start_Data_Bits: begin
                o_Serial_Data <= r_Data[r_Index];
                    
                if (r_Counter < FREQUENCY-1) begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_Start_Data_Bits;
                end

                else begin
                    r_Counter <= 0;
                        
                    if (r_Index < 7) begin
                        r_Index <= r_Index + 1;
                        r_State <= r_Start_Data_Bits;
                    end

                    else begin
                        r_Index <= 0;
                        r_State <= r_State_Stop_Bit;
                    end
                end
            end 
                
            r_State_Stop_Bit: begin
                o_Serial_Data <= 1'b1;
                    
                if (r_Counter < FREQUENCY-1) begin
                    r_Counter <= r_Counter + 1;
                    r_State <= r_State_Stop_Bit;
                end

                else begin
                    r_Done <= 1'b1;
                    r_Counter <= 0;
                    r_State <= r_State_Refresh;
                    r_Active <= 1'b0;
                end
            end 
                
            r_State_Refresh: begin
                r_Done <= 1'b1;
                r_State <= r_State_Idle;
            end
                
            default:
                r_State <= r_State_Idle;
                
        endcase
    end

    assign o_Sig_Active = r_Active;
    assign o_Sig_Done   = r_Done;

endmodule