library verilog;
use verilog.vl_types.all;
entity divisorDeClock_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        ENB             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end divisorDeClock_vlg_sample_tst;
