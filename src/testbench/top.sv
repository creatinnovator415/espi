`timescale 1ns/1ps // Sets the simulation time unit and precision.

module top; // Defines the top-level module for the simulation.
    import uvm_pkg::*; // Imports the main UVM library package.
    import espi_pkg::*; // Imports the user-defined eSPI testbench package.
    logic clk = 0; // Declares the main clock signal, initialized to 0.
    always #5 clk = ~clk; // Generates a clock with a 10ns period (5ns high, 5ns low).
    espi_if tb_if(clk); // Instantiates the eSPI interface, connecting the clock.

    // Instantiates the eSPI Master DUT (Design Under Test).
    eSPI_Master master_inst(
        .clk(tb_if.clk), // Connects the DUT clock to the interface clock.
        .reset_n(tb_if.reset_n), // Connects the DUT reset to the interface reset.
        .start_transaction(tb_if.start_transaction), // Connects the DUT start signal.
        .command(tb_if.command), // Connects the DUT command bus.
        .write_data(tb_if.write_data), // Connects the DUT write data bus.
        .read_data(tb_if.read_data), // Connects the DUT read data bus.
        .transaction_done(tb_if.transaction_done), // Connects the DUT done signal.
        .sclk(tb_if.sclk), // Connects the DUT serial clock.
        .cs_n(tb_if.cs_n), // Connects the DUT chip select.
        .io0(tb_if.io0) // Connects the DUT bidirectional data line.
    );

    // Instantiates the eSPI Slave model.
    eSPI_Slave slave_inst(
        .sclk(tb_if.sclk), // Connects the slave serial clock.
        .cs_n(tb_if.cs_n), // Connects the slave chip select.
        .reset_n(tb_if.reset_n), // Connects the slave reset.
        .io0(tb_if.io0) // Connects the slave bidirectional data line.
    );

    // An initial block that executes once at the beginning of the simulation.
    initial begin
        // Places the virtual interface handle into the UVM configuration database.
        uvm_config_db#(virtual espi_if)::set(null, "*", "vif", tb_if);

        run_test("simple_test"); // Starts the UVM simulation by running the specified test.
    end
endmodule