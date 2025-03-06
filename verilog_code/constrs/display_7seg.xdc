set_property PACKAGE_PIN W5 [get_ports {BasysCLK}]
set_property PACKAGE_PIN R2 [get_ports SW_in[1]]
set_property PACKAGE_PIN T1 [get_ports SW_in[0]]
set_property PACKAGE_PIN V17 [get_ports RST_Button]
set_property PACKAGE_PIN T17 [get_ports CLKButton]

# 设置 I/O 标准
set_property IOSTANDARD LVCMOS33 [get_ports {BasysCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports SW_in[1]]
set_property IOSTANDARD LVCMOS33 [get_ports SW_in[0]]
set_property IOSTANDARD LVCMOS33 [get_ports RST_Button]
set_property IOSTANDARD LVCMOS33 [get_ports CLKButton]

# 引脚分配
set_property PACKAGE_PIN W4 [get_ports {Bits[3]}]
set_property PACKAGE_PIN V4 [get_ports {Bits[2]}]
set_property PACKAGE_PIN U4 [get_ports {Bits[1]}]
set_property PACKAGE_PIN U2 [get_ports {Bits[0]}]

# 七段数码管引脚分配
set_property PACKAGE_PIN V7 [get_ports {SegOut[7]}]
set_property PACKAGE_PIN W7 [get_ports {SegOut[0]}]
set_property PACKAGE_PIN W6 [get_ports {SegOut[1]}]
set_property PACKAGE_PIN U8 [get_ports {SegOut[2]}]
set_property PACKAGE_PIN V8 [get_ports {SegOut[3]}]
set_property PACKAGE_PIN U5 [get_ports {SegOut[4]}]
set_property PACKAGE_PIN V5 [get_ports {SegOut[5]}]
set_property PACKAGE_PIN U7 [get_ports {SegOut[6]}]

# 设置 I/O 标准（确保只设置一次）
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[0]}]


# 约束时钟引脚和 BUFG 的连接
set_property CLOCK_DEDICATED_ROUTE TRUE [get_nets reset]

