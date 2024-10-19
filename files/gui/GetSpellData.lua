dofile_once("mods/kummitus_wand_viewer/files/libs/fn.lua")
dofile_once("mods/kummitus_wand_viewer/files/libs/unsafe.lua")
dofile_once("data/scripts/gun/gun.lua")

--用于获取一部分需要的数据，不完整
local result = {}
for k,v in pairs(actions)do
	result[v.id] = v
end
return result
