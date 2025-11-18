class espi_monitor extends uvm_monitor; // Defines the monitor class, inheriting from the UVM base monitor.
    `uvm_component_utils(espi_monitor) // Registers this class with the UVM factory.
            virtual espi_if vif; // Declares a handle for the virtual interface to observe DUT signals.
    uvm_analysis_port #(espi_seq_item) ap; // Declares an analysis port to broadcast collected transactions.

    // Constructor for the espi_monitor class.
    function new(string name = "espi_monitor", uvm_component parent = null);
        super.new(name, parent); // Calls the parent class (uvm_monitor) constructor.
        ap = new("ap", this); // Creates the analysis port.
    endfunction

    // The build_phase is used to get configuration information.
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Calls the parent class build_phase.
        // Get the virtual interface handle from the configuration database.
        if (!uvm_config_db#(virtual espi_if)::get(this, "", "vif", vif))
        begin
        // If not found, report a fatal error.
        uvm_report_fatal("NOVIF", "Virtual interface must be set for monitor");
        end
    endfunction

    // The run_phase contains the main monitor logic.
    virtual task run_phase(uvm_phase phase);
        espi_seq_item item; // Declares a handle for the transaction item.
        forever
        begin // The monitor runs continuously, observing the bus.
            // 1. Wait for a transaction to start by observing chip select going low.
            @(negedge vif.cs_n);

            // 2. Wait for the transaction to end by observing chip select going high.
            @(posedge vif.cs_n);

            // 3. Now that the transaction is complete, sample the final values.
            item = espi_seq_item::type_id::create("item"); // Creates a new transaction object to store the data.
            item.command = vif.command; // Samples the command from the interface.
            item.write_data = vif.write_data; // Samples the write_data from the interface.
            item.read_data = vif.read_data; // Samples the read_data from the interface.
            ap.write(item); // Broadcasts the collected transaction through the analysis port.
        end
    endtask
endclass
