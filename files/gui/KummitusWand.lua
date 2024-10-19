dofile_once("mods/kummitus_wand_viewer/files/libs/fn.lua")
local DebugGame = DebugGetIsDevBuild()
local KummitusPath
if DebugGame then--获取文件路径，需要判断是否是debug游戏
    KummitusPath = Cpp.CurrentPath().."/"
else
    KummitusPath = SavePath
end
KummitusPath = KummitusPath .. "save00/persistent/bones_new/"
local t = Cpp.GetDirectoryPath(KummitusPath)--获取文件列表
local WandXmlList = {}
for _, v in pairs(t.File) do                 --筛选xml文件
    if string.sub(v, string.len(v) - 3) == ".xml" then
		local name = Cpp.PathGetFileName(v)
		local path = "mods/kummitus_wand_viewer/files/virtual_files/"..name
        WandXmlList[#WandXmlList + 1] = {path,name}
        IGET_ModTextFileSetContent(path, ReadFileAll(v))--让游戏创建虚拟文件
    end
end
local KummitusWandList = {}

for _,v in pairs(WandXmlList)do
	local id = EntityLoad(v[1])
	EntitySetTransform(id, 0, 0)
	local comps = EntityGetAllComponents(id)
    for _, comp in pairs(comps) do
        EntitySetComponentIsEnabled(id, comp, true)
    end
    KummitusWandList[#KummitusWandList + 1] = {GetWandData(id),"save00/persistent/bones_new/"..v[2]}
	EntityKill(id)
end
return KummitusWandList
