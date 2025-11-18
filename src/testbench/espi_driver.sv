class espi_driver extends uvm_driver #(espi_seq_item); // Defines the driver class, parameterized with the transaction type.
    `uvm_component_utils(espi_driver) // Registers this class with the UVM factory.
    virtual espi_if vif; // Declares a handle for the virtual interface to drive the DUT.

    // Constructor for the espi_driver class.
    function new(string name = "espi_driver", uvm_component parent = null);
        super.new(name, parent); // Calls the parent class (uvm_driver) constructor.
    endfunction

    // The build_phase is used to get configuration information, like the virtual interface.
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Calls the parent class build_phase.
        // Get the virtual interface handle from the configuration database.
        if (!uvm_config_db#(virtual espi_if)::get(this, "", "vif", vif))
        begin
            uvm_report_fatal("NOVIF", "Virtual interface must be set for driver"); // Report fatal error if not found.
        end
    endfunction

          // The run_phase contains the main driver logic.
    virtual task run_phase(uvm_phase phase);
        espi_seq_item item; // Declares a handle for the transaction item.
        forever
        begin // The driver runs continuously, processing transactions.
            seq_item_port.get_next_item(item); // Blocks until a new transaction is available from the sequencer.

            // Start the transaction by asserting chip select
            vif.cs_n <= 0;

            // Drive the command and data based on the DUT's simple host interface
            vif.start_transaction <= 1; // Assert the start signal on the interface.
            vif.command <= item.command; // Drive the command from the transaction item.
            vif.write_data <= item.write_data; // Drive the write_data from the transaction item.
            @(posedge vif.clk); // Wait for one clock cycle.
            vif.start_transaction <= 0; // De-assert the start signal.

            // Wait for the DUT to signal completion
            wait(vif.transaction_done); // Wait for the DUT to signal that the transaction is complete.

            // End the transaction by de-asserting chip select
            vif.cs_n <= 1;

            item.read_data = vif.read_data; // Capture the read_data from the interface back into the item.
            seq_item_port.item_done(); // Unblocks the sequence, indicating the transaction is finished.
        end
    endtask

endclass
