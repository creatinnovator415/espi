`timescale 1ns/1ps

module eSPI_tb;
    reg clk;
    reg reset_n;
    reg start_transaction;
    reg [7:0] command;
    reg [7:0] write_data;
    wire [7:0] read_data;
    wire transaction_done;
    wire sclk;
    wire cs_n;
    tri io0;

    // DUT instantiation
    eSPI_Master dut (
                    .clk(clk),
                    .reset_n(reset_n),
                    .start_transaction(start_transaction),
                    .command(command),
                    .write_data(write_data),
                    .read_data(read_data),
                    .transaction_done(transaction_done),
                    .sclk(sclk),
                    .cs_n(cs_n),
                    .io0(io0)
                );

    // Instantiate slave
    eSPI_Slave slave (
                   .sclk(sclk),
                   .cs_n(cs_n),
                   .reset_n(reset_n),
                   .io0(io0)
               );

    // Clock generation
    initial
        clk = 0;
    always #5 clk = ~clk; // 100MHz

    // Stimulus
    initial
    begin
        reset_n = 0;
        start_transaction = 0;
        command = 8'h01;
        write_data = 8'hAA;
        #20 reset_n = 1;

        #20 start_transaction = 1;
        #40 start_transaction = 0;

        wait(transaction_done);
        $display("Transaction complete, read_data = %h", read_data);

        #50 $finish;
    end
endmodule
