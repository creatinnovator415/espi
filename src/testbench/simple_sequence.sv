import uvm_pkg::*; // Imports the main UVM library package.
`include "uvm_macros.svh" // Includes UVM macros for factory registration, etc.

class simple_sequence extends uvm_sequence #(espi_seq_item); // Defines a sequence class, parameterized with the transaction type.
    // Constructor for the simple_sequence class.
    `uvm_object_utils(simple_sequence) // Registers this sequence (which is a uvm_object) with the UVM factory.
    
    function new(string name = "simple_sequence");
        super.new(name); // Calls the parent class (uvm_sequence) constructor.
    endfunction
    
    // The 'body' task contains the main logic of the sequence.
    task body();
        espi_seq_item item; // Declares a handle for the transaction item.

        item = espi_seq_item::type_id::create("item"); // Creates a new transaction object using the factory.
        item.command = 8'hA5; // Sets the command field of the transaction.
        item.write_data = 8'h5A; // Sets the write_data field of the transaction.
        start_item(item); // Sends the transaction to the driver and waits for it to be accepted.
        finish_item(item); // Waits for the driver to signal completion and updates the item with response data.
    endtask
endclass