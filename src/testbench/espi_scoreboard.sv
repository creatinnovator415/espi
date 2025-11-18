`include "uvm_macros.svh"

class espi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(espi_scoreboard)

    // Analysis import to receive actual transactions from the monitor.
    uvm_analysis_imp #(espi_seq_item, espi_scoreboard) item_collected_imp;
    // Configuration: Expected read data value.
    bit [7:0] expected_read_data = 8'haa; // Default value

    // Constructor
    function new(string name = "espi_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase to create the analysis import
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_imp = new("item_collected_imp", this);
    endfunction

    // The `write` method is automatically called by the monitor's analysis port.
    // This is where the checking logic resides.
    virtual function void write(espi_seq_item item);
        if (item.read_data == expected_read_data) begin
            uvm_report_info("SCOREBOARD", $sformatf("CHECK PASSED: read_data matches expected value 0x%0h. Got 0x%0h", expected_read_data, item.read_data), UVM_MEDIUM);
        end else begin
            uvm_report_error("SCOREBOARD", $sformatf("CHECK FAILED: read_data mismatch. Expected 0x%0h, Got 0x%0h", expected_read_data, item.read_data));
        end
    endfunction
endclass