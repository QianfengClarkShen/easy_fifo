
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/easy_fifo_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set ASYNC [ipgui::add_param $IPINST -name "ASYNC" -parent ${Page_0} -widget comboBox]
  set_property tooltip {input and output clock are asynchronouse} ${ASYNC}
  set AXIS [ipgui::add_param $IPINST -name "AXIS" -parent ${Page_0} -widget comboBox]
  set_property tooltip {choose whether to use AXIS interface or not} ${AXIS}
  ipgui::add_param $IPINST -name "DEPTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "INPUT_REG" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "OUTPUT_REG" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "DWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEST_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "USER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HAS_KEEP" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "HAS_LAST" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "HAS_STRB" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.DEST_WIDTH { PARAM_VALUE.DEST_WIDTH PARAM_VALUE.AXIS } {
	# Procedure called to update DEST_WIDTH when any of the dependent parameters in the arguments change
	
	set DEST_WIDTH ${PARAM_VALUE.DEST_WIDTH}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_DEST_WIDTH_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $DEST_WIDTH
	} else {
		set_property enabled false $DEST_WIDTH
	}
}

proc validate_PARAM_VALUE.DEST_WIDTH { PARAM_VALUE.DEST_WIDTH } {
	# Procedure called to validate DEST_WIDTH
	return true
}

proc update_PARAM_VALUE.HAS_KEEP { PARAM_VALUE.HAS_KEEP PARAM_VALUE.AXIS } {
	# Procedure called to update HAS_KEEP when any of the dependent parameters in the arguments change
	
	set HAS_KEEP ${PARAM_VALUE.HAS_KEEP}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_HAS_KEEP_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $HAS_KEEP
	} else {
		set_property enabled false $HAS_KEEP
	}
}

proc validate_PARAM_VALUE.HAS_KEEP { PARAM_VALUE.HAS_KEEP } {
	# Procedure called to validate HAS_KEEP
	return true
}

proc update_PARAM_VALUE.HAS_LAST { PARAM_VALUE.HAS_LAST PARAM_VALUE.AXIS } {
	# Procedure called to update HAS_LAST when any of the dependent parameters in the arguments change
	
	set HAS_LAST ${PARAM_VALUE.HAS_LAST}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_HAS_LAST_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $HAS_LAST
	} else {
		set_property enabled false $HAS_LAST
	}
}

proc validate_PARAM_VALUE.HAS_LAST { PARAM_VALUE.HAS_LAST } {
	# Procedure called to validate HAS_LAST
	return true
}

proc update_PARAM_VALUE.HAS_STRB { PARAM_VALUE.HAS_STRB PARAM_VALUE.AXIS } {
	# Procedure called to update HAS_STRB when any of the dependent parameters in the arguments change
	
	set HAS_STRB ${PARAM_VALUE.HAS_STRB}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_HAS_STRB_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $HAS_STRB
	} else {
		set_property enabled false $HAS_STRB
	}
}

proc validate_PARAM_VALUE.HAS_STRB { PARAM_VALUE.HAS_STRB } {
	# Procedure called to validate HAS_STRB
	return true
}

proc update_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH PARAM_VALUE.AXIS } {
	# Procedure called to update ID_WIDTH when any of the dependent parameters in the arguments change
	
	set ID_WIDTH ${PARAM_VALUE.ID_WIDTH}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_ID_WIDTH_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $ID_WIDTH
	} else {
		set_property enabled false $ID_WIDTH
	}
}

proc validate_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH } {
	# Procedure called to validate ID_WIDTH
	return true
}

proc update_PARAM_VALUE.USER_WIDTH { PARAM_VALUE.USER_WIDTH PARAM_VALUE.AXIS } {
	# Procedure called to update USER_WIDTH when any of the dependent parameters in the arguments change
	
	set USER_WIDTH ${PARAM_VALUE.USER_WIDTH}
	set AXIS ${PARAM_VALUE.AXIS}
	set values(AXIS) [get_property value $AXIS]
	if { [gen_USERPARAMETER_USER_WIDTH_ENABLEMENT $values(AXIS)] } {
		set_property enabled true $USER_WIDTH
	} else {
		set_property enabled false $USER_WIDTH
	}
}

proc validate_PARAM_VALUE.USER_WIDTH { PARAM_VALUE.USER_WIDTH } {
	# Procedure called to validate USER_WIDTH
	return true
}

proc update_PARAM_VALUE.ASYNC { PARAM_VALUE.ASYNC } {
	# Procedure called to update ASYNC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ASYNC { PARAM_VALUE.ASYNC } {
	# Procedure called to validate ASYNC
	return true
}

proc update_PARAM_VALUE.AXIS { PARAM_VALUE.AXIS } {
	# Procedure called to update AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS { PARAM_VALUE.AXIS } {
	# Procedure called to validate AXIS
	return true
}

proc update_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to update DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEPTH { PARAM_VALUE.DEPTH } {
	# Procedure called to validate DEPTH
	return true
}

proc update_PARAM_VALUE.DWIDTH { PARAM_VALUE.DWIDTH } {
	# Procedure called to update DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DWIDTH { PARAM_VALUE.DWIDTH } {
	# Procedure called to validate DWIDTH
	return true
}

proc update_PARAM_VALUE.INPUT_REG { PARAM_VALUE.INPUT_REG } {
	# Procedure called to update INPUT_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_REG { PARAM_VALUE.INPUT_REG } {
	# Procedure called to validate INPUT_REG
	return true
}

proc update_PARAM_VALUE.OUTPUT_REG { PARAM_VALUE.OUTPUT_REG } {
	# Procedure called to update OUTPUT_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_REG { PARAM_VALUE.OUTPUT_REG } {
	# Procedure called to validate OUTPUT_REG
	return true
}


proc update_MODELPARAM_VALUE.ASYNC { MODELPARAM_VALUE.ASYNC PARAM_VALUE.ASYNC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ASYNC}] ${MODELPARAM_VALUE.ASYNC}
}

proc update_MODELPARAM_VALUE.AXIS { MODELPARAM_VALUE.AXIS PARAM_VALUE.AXIS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS}] ${MODELPARAM_VALUE.AXIS}
}

proc update_MODELPARAM_VALUE.DWIDTH { MODELPARAM_VALUE.DWIDTH PARAM_VALUE.DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DWIDTH}] ${MODELPARAM_VALUE.DWIDTH}
}

proc update_MODELPARAM_VALUE.DEPTH { MODELPARAM_VALUE.DEPTH PARAM_VALUE.DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEPTH}] ${MODELPARAM_VALUE.DEPTH}
}

proc update_MODELPARAM_VALUE.INPUT_REG { MODELPARAM_VALUE.INPUT_REG PARAM_VALUE.INPUT_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_REG}] ${MODELPARAM_VALUE.INPUT_REG}
}

proc update_MODELPARAM_VALUE.OUTPUT_REG { MODELPARAM_VALUE.OUTPUT_REG PARAM_VALUE.OUTPUT_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_REG}] ${MODELPARAM_VALUE.OUTPUT_REG}
}

proc update_MODELPARAM_VALUE.HAS_KEEP { MODELPARAM_VALUE.HAS_KEEP PARAM_VALUE.HAS_KEEP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_KEEP}] ${MODELPARAM_VALUE.HAS_KEEP}
}

proc update_MODELPARAM_VALUE.HAS_LAST { MODELPARAM_VALUE.HAS_LAST PARAM_VALUE.HAS_LAST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_LAST}] ${MODELPARAM_VALUE.HAS_LAST}
}

proc update_MODELPARAM_VALUE.HAS_STRB { MODELPARAM_VALUE.HAS_STRB PARAM_VALUE.HAS_STRB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_STRB}] ${MODELPARAM_VALUE.HAS_STRB}
}

proc update_MODELPARAM_VALUE.DEST_WIDTH { MODELPARAM_VALUE.DEST_WIDTH PARAM_VALUE.DEST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEST_WIDTH}] ${MODELPARAM_VALUE.DEST_WIDTH}
}

proc update_MODELPARAM_VALUE.USER_WIDTH { MODELPARAM_VALUE.USER_WIDTH PARAM_VALUE.USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USER_WIDTH}] ${MODELPARAM_VALUE.USER_WIDTH}
}

proc update_MODELPARAM_VALUE.ID_WIDTH { MODELPARAM_VALUE.ID_WIDTH PARAM_VALUE.ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID_WIDTH}] ${MODELPARAM_VALUE.ID_WIDTH}
}

