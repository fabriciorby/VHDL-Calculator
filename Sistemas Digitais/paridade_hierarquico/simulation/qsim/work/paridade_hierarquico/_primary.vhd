library verilog;
use verilog.vl_types.all;
entity paridade_hierarquico is
    port(
        p               : out    vl_logic;
        x1              : in     vl_logic;
        x2              : in     vl_logic;
        x3              : in     vl_logic
    );
end paridade_hierarquico;
