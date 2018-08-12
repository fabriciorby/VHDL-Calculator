library verilog;
use verilog.vl_types.all;
entity binary4_to_bcd8_vector_vlg_sample_tst is
    port(
        BIN             : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end binary4_to_bcd8_vector_vlg_sample_tst;
