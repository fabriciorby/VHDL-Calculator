library verilog;
use verilog.vl_types.all;
entity binary4_to_bcd8_vector_vlg_check_tst is
    port(
        BCD0            : in     vl_logic_vector(3 downto 0);
        BCD1            : in     vl_logic_vector(3 downto 0);
        sampler_rx      : in     vl_logic
    );
end binary4_to_bcd8_vector_vlg_check_tst;
