`include "uvm_macros.svh"
class espi_seq_item extends uvm_sequence_item;
    `uvm_object_utils(espi_seq_item)
    rand bit [7:0] command;
    rand bit [7:0] write_data;
    bit [7:0] read_data;

    function new(string name = "espi_seq_item");
        super.new(name);
    endfunction
endclass