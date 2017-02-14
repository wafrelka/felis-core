set_property PACKAGE_PIN AK17           [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports clk_p]
set_property ODT RTT_48                 [get_ports clk_p]
create_clock -period 3.333              [get_ports clk_p]

set_property PACKAGE_PIN AK16           [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports clk_n]
set_property ODT RTT_48                 [get_ports clk_n]

set_property PACKAGE_PIN G25     [get_ports uart_rx]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rx]
set_property PACKAGE_PIN K26     [get_ports uart_tx]
set_property IOSTANDARD LVCMOS18 [get_ports uart_tx]
