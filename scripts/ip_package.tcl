set ip_name [lindex $argv 0]
set part_name [lindex $argv 1]
set project_name ${ip_name}_ip
create_project ${project_name} ${project_name} -part $part_name
import_files ${ip_name}.v
ipx::package_project -root_dir ${project_name}/${project_name}.srcs/sources_1/imports -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $ip_name [ipx::current_core]
set_property display_name $ip_name [ipx::current_core]
set_property core_revision 2 [ipx::current_core]
foreach intf [ipx::get_bus_interfaces -filter "NAME != clk && NAME != rst"] {
	ipx::associate_bus_interfaces -busif [lindex ${intf} end] -clock clk [ipx::current_core]
}

set_property widget {comboBox} [ipgui::get_guiparamspec -name "RAM_STYLE" -component [ipx::current_core] ]
set_property value_format string [ipx::get_user_parameters RAM_STYLE -of_objects [ipx::current_core]]
set_property value_format string [ipx::get_hdl_parameters RAM_STYLE -of_objects [ipx::current_core]]
set_property value_validation_type pairs [ipx::get_user_parameters RAM_STYLE -of_objects [ipx::current_core]]
set_property value_validation_pairs {{Auto} "auto" {Block RAM} "block" {Distributed RAM} "distributed"} [ipx::get_user_parameters RAM_STYLE -of_objects [ipx::current_core]]
set_property widget {checkBox} [ipgui::get_guiparamspec -name "HAS_DATA" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters HAS_DATA -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters HAS_DATA -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters HAS_DATA -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters HAS_DATA -of_objects [ipx::current_core]]
set_property widget {checkBox} [ipgui::get_guiparamspec -name "HAS_KEEP" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters HAS_KEEP -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters HAS_KEEP -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters HAS_KEEP -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters HAS_KEEP -of_objects [ipx::current_core]]
set_property widget {checkBox} [ipgui::get_guiparamspec -name "HAS_LAST" -component [ipx::current_core] ]
set_property value true [ipx::get_user_parameters HAS_LAST -of_objects [ipx::current_core]]
set_property value true [ipx::get_hdl_parameters HAS_LAST -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_user_parameters HAS_LAST -of_objects [ipx::current_core]]
set_property value_format bool [ipx::get_hdl_parameters HAS_LAST -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports m_axis_tdata -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_DATA = 1} [ipx::get_ports m_axis_tdata -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports m_axis_tkeep -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_KEEP = 1} [ipx::get_ports m_axis_tkeep -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports m_axis_tlast -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_LAST = 1} [ipx::get_ports m_axis_tlast -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports s_axis_tdata -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_DATA = 1} [ipx::get_ports s_axis_tdata -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports s_axis_tkeep -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_KEEP = 1} [ipx::get_ports s_axis_tkeep -of_objects [ipx::current_core]]
set_property driver_value 0 [ipx::get_ports s_axis_tlast -of_objects [ipx::current_core]]
set_property enablement_dependency {$HAS_LAST = 1} [ipx::get_ports s_axis_tlast -of_objects [ipx::current_core]]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project 
exit
