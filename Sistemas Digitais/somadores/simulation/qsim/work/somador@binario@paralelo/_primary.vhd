library verilog;
use verilog.vl_types.all;
entity somadorBinarioParalelo is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        S               : out    vl_logic_vector(3 downto 0);
        CIN             : in     vl_logic;
        COUT            : out    vl_logic
    );
end somadorBinarioParalelo;
