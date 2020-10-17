-- WireShark packet dissector for Schönherz Mátrix 4 packet format
-- @author CsokiCraft
-- Licensed under GPL 2.0 or later

-- Command values
vs_cmds = {
	[0] = "NOP",
	[1] = "REBOOT"
} -- TODO

-- WireShark objects
local p_mtx4 = Proto("schmatrix4", "SCH Matrix4")

local f_cmd    = ProtoField.uint16("schmatrix4.cmd"   , "Command"   , base.HEX, vs_cmds)
local f_magic  = ProtoField.uint16("schmatrix4.magic" , "Magic bytes")
local f_data   = ProtoField.string("schmatrix4.data"  , "Data"      , base.HEX)

p_mtx4.fields = { f_cmd, f_magic, f_data }

-- Config for UDP port
p_mtx4.prefs.udp_port=Pref.uint("UDP port", 1500, "UDP port used by Matrix")

-- Raw data dissector (used for payload)
local d_data = Dissector.get("data")

-- Main dissector function
function p_mtx4.dissector(buf, pinfo, tree)
	local t_mtx4=tree:add(p_mtx4, buf())
	t_mtx4:add_le(f_magic, buf(0, 3))
--	i_repl=buf(6, 2):le_uint()
--	if i_cmd == 11 then
--		t_mtx4:add(f_text, buf(8))
--	else
--		d_data:call(buf(8):tvb(), pinfo, t_mtx4)
--	end
end

-- Register Proto to UDP port
local udp_encap_table = DissectorTable.get("udp.port")
udp_encap_table:add(p_mtx4.prefs.udp_port, p_mtx4)
