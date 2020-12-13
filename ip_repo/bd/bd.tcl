proc init { cell_name undefined_params } {}

proc post_config_ip { cell_name args } {
    set ip [get_bd_cells $cell_name]
    set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $cell_name/rst]
    if {[get_property CONFIG.AXIS $ip] == 0} {
        if {[get_property CONFIG.ASYNC $ip] == 0} {
            set_property CONFIG.ASSOCIATED_BUSIF {fifo_wr:fifo_rd} [get_bd_pins $cell_name/clk]
        } else {
            set_property CONFIG.ASSOCIATED_BUSIF {fifo_wr} [get_bd_pins $cell_name/wr_clk]
            set_property CONFIG.ASSOCIATED_BUSIF {fifo_rd} [get_bd_pins $cell_name/rd_clk]
        }
    } else {
        if {[get_property CONFIG.ASYNC $ip] == 0} {
            set_property CONFIG.ASSOCIATED_BUSIF {s_axis:m_axis} [get_bd_pins $cell_name/clk]
        } else {
            set_property CONFIG.ASSOCIATED_BUSIF {s_axis} [get_bd_pins $cell_name/s_axis_aclk]
            set_property CONFIG.ASSOCIATED_BUSIF {m_axis} [get_bd_pins $cell_name/m_axis_aclk]
        }
    }
}

proc propagate { cell_name prop_info } {}