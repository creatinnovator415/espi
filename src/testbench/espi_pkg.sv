`timescale 1ns/1ps // Sets the simulation time unit and precision.
package espi_pkg; // Defines a package named 'espi_pkg'.
    import uvm_pkg::*; // Imports the UVM library, making its contents available inside this package.
`include "uvm_macros.svh" // Includes the file containing UVM macros.
`include "espi_seq_item.sv" // Includes the transaction item definition.
`include "espi_driver.sv" // Includes the driver class definition.
`include "espi_monitor.sv" // Includes the monitor class definition.
`include "espi_agent.sv" // Includes the agent class definition.
`include "espi_scoreboard.sv" // Includes the scoreboard class definition.
`include "espi_env.sv" // Includes the environment class definition.
`include "simple_sequence.sv" // Includes the sequence class definition.
`include "base_test.sv" // Includes the test class definitions.
endpackage