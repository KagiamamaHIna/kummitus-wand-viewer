dofile_once("mods/kummitus_wand_viewer/files/libs/unsafe.lua")
dofile_once("mods/kummitus_wand_viewer/files/libs/fn.lua")
dofile_once("mods/kummitus_wand_viewer/files/gui/update.lua")
dofile_once("data/scripts/lib/utilities.lua")
local SrcCsv = ModTextFileGetContent("data/translations/common.csv")--设置新语言文件
local AddCsv = ModTextFileGetContent("mods/kummitus_wand_viewer/files/lang/lang.csv")
ModTextFileSetContent("data/translations/common.csv", SrcCsv .. AddCsv)
IGET_ModTextFileSetContent = ModTextFileSetContent
--GUI绘制
function OnWorldPostUpdate()
    GUIUpdate()
end
