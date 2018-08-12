library verilog;
use verilog.vl_types.all;
entity divisorDeClock is
    port(
        ENB             : in     vl_logic;
        CLK             : in     vl_logic;
        COUT            : out    vl_logic
    );
end divisorDeClock;
