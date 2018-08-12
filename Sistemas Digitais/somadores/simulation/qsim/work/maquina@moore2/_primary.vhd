library verilog;
use verilog.vl_types.all;
entity maquinaMoore2 is
    port(
        CLOCK           : in     vl_logic;
        RESET           : in     vl_logic;
        W               : in     vl_logic;
        Z               : out    vl_logic
    );
end maquinaMoore2;
