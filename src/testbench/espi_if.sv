`timescale 1ns/1ps // Sets the simulation time unit to 1 nanosecond and precision to 1 picosecond.

interface espi_if(input logic clk); // Defines an interface named 'espi_if' which takes 'clk' as an input port.
    logic reset_n; // Active-low reset signal.
    logic start_transaction; // Signal to initiate a transaction with the DUT.
    logic [7:0] command; // 8-bit command bus.
    logic [7:0] write_data; // 8-bit data to be written to the DUT.
    logic [7:0] read_data; // 8-bit data read from the DUT.
    logic transaction_done; // Signal from the DUT indicating transaction completion.
    logic sclk; // The serial clock for the eSPI bus.
    logic cs_n; // The active-low chip select signal.
    wire io0; // The bidirectional data line. 'wire' is used for physical connections.
endinterface