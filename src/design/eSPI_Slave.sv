`timescale 1ns/1ps

module eSPI_Slave (
        input  logic sclk,
        input  logic cs_n,
        input  logic reset_n,
        inout  wire io0
    );

    typedef enum logic [1:0] {
                SLAVE_IDLE,
                SLAVE_RECEIVE_CMD,
                SLAVE_RESPOND
            } slave_state_t;

    slave_state_t state;
    logic [7:0] cmd_reg;
    logic [7:0] resp_data;
    logic [2:0] bit_counter;
    logic drive_bus;

    assign io0 = (drive_bus) ? resp_data[7-bit_counter] : 1'bz;

    always_ff @(posedge sclk or negedge reset_n or posedge cs_n)
    begin
        if(!reset_n)
        begin
            state <= SLAVE_IDLE;
            drive_bus <= 0;
            bit_counter <= 0;
            resp_data <= 8'hAB;
        end
        else if(cs_n)
        begin
            state <= SLAVE_IDLE;
            drive_bus <= 0;
            bit_counter <= 0;
            resp_data <= 8'hAB;
        end
        else
        begin
            case(state)
                SLAVE_IDLE:
                begin
                    bit_counter <= 0;
                    state <= SLAVE_RECEIVE_CMD;
                end

                SLAVE_RECEIVE_CMD:
                begin
                    cmd_reg[7-bit_counter] <= io0;
                    if(bit_counter == 7)
                    begin
                        bit_counter <= 0;
                        state <= SLAVE_RESPOND;
                        drive_bus <= 1;
                    end
                    else
                    begin
                        bit_counter <= bit_counter + 1;
                    end
                end

                SLAVE_RESPOND:
                begin
                    if(bit_counter == 7)
                    begin
                        drive_bus <= 0;
                        state <= SLAVE_IDLE;
                    end
                    else
                    begin
                        bit_counter <= bit_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule
