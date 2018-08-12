library verilog;
use verilog.vl_types.all;
entity atividadeMoore is
    port(
        CLOCK           : in     vl_logic;
        RESET           : in     vl_logic;
        w               : in     vl_logic;
        z               : out    vl_logic_vector(1 downto 0)
    );
end atividadeMoore;
