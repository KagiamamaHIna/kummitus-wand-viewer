function GUIUpdate()
    if UI == nil then
        --初始化
        ---@class Gui
        UI = dofile_once("mods/kummitus_wand_viewer/files/libs/gui.lua")
		spellData = dofile_once("mods/kummitus_wand_viewer/files/gui/GetSpellData.lua") --读取法术数据
        KummitusWands = dofile_once("mods/kummitus_wand_viewer/files/gui/KummitusWand.lua")
		dofile_once("mods/kummitus_wand_viewer/files/gui/KummitusWandGui.lua")
		
		UI.MainTickFn["Main"] = function()
            if GameIsInventoryOpen() then
                return
            end
			local MainCB = function (left_click, right_click, x, _, enable)
                if not enable then
                    return
                end
				DarwWandContainer()
			end
			UI.MoveImagePicker("MainButtonKummitus", 200, 10, 8, 0, GameTextGet("$kummitus_wand_viewer_main_button"),
                "mods/kummitus_wand_viewer/files/gui/images/menu.png", nil, MainCB, nil, false, nil, false)
			if UI.GetPickerHover("MainButtonKummitus") and InputIsKeyJustDown(Key_c) then
				Cpp.SetClipboard(ModLink)
			end
		end
    end
	UI.DispatchMessage()
end
