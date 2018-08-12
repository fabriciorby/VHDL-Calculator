library verilog;
use verilog.vl_types.all;
entity xor_vhdl is
    port(
        x1              : in     vl_logic;
        x2              : in     vl_logic;
        f               : out    vl_logic
    );
end xor_vhdl;
