dofile_once("mods/kummitus_wand_viewer/files/libs/fn.lua")
local GetHeldWand = Compose(GetEntityHeldWand, GetPlayer)
local function ClickSound()
    GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos())
end

local deg57_5 = math.rad(-57.5)
local RowMax = 10
local ColMax = 5
local TableMax = RowMax * ColMax
local RowGap = 23
local ColGap = 23
local SlotBG = "data/ui_gfx/inventory/full_inventory_box.png"
local HLSlotBG = "data/ui_gfx/inventory/full_inventory_box_highlight.png"
local function DrawWandSlot(id, k, KData)
	local wand = KData[1]
	local world_entity_id = GameGetWorldStateEntity()
    local comp_worldstate = EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
    local inf_spells_enable = ComponentGetValue2(comp_worldstate, "perk_infinite_spells")

    local sprite
    local s = strip(wand.sprite_file)
    if string.sub(s, #s - 3) == ".xml" then --特殊文件需要处理
        local SpriteXml = ParseXmlAndBase(wand.sprite_file)
        sprite = SpriteXml.attr.filename
    else
        sprite = wand.sprite_file
    end
    k = k - 1
    local thisSlot
    if UI.UserData["WandDepotKHighlight"] == k then
        thisSlot = HLSlotBG
    else
        thisSlot = SlotBG
    end
    local column = math.floor(k % (RowMax))
    local row = math.floor(k / (RowMax))
    local x = ColGap * column
    local y = row * RowGap
	GuiZSetForNextWidget(UI.gui,UI.GetZDeep())
	local left_click, right_click = GuiImageButton(UI.gui, UI.NewID(id..tostring(k).."BG"), 0 + x, 12 + y, "", thisSlot)
    local _, _, hover = GuiGetPreviousWidgetInfo(UI.gui)
    if hover then
        local rightMargin = 70
        local function NewLine(str1, str2)
            local text = GameTextGetTranslatedOrNot(str1)
            local w = GuiGetTextDimensions(UI.gui, text)
            GuiLayoutBeginHorizontal(UI.gui, 0, 0, true, 2, -1)
            GuiText(UI.gui, 0, 0, text)
            GuiRGBAColorSetForNextWidget(UI.gui, 255, 222, 173, 255)
            GuiText(UI.gui, rightMargin - w, 0, str2)
            GuiLayoutEnd(UI.gui)
        end
        local SecondWithSign = Compose(NumToWithSignStr, tonumber, FrToSecondStr)
        UI.BetterTooltipsNoCenter(function()
            GuiLayoutBeginVertical(UI.gui, 0, 0, true)
            if InputIsKeyDown(Key_LCTRL) or InputIsKeyDown(Key_RCTRL) then
				if wand.always_use_item_name_in_ui then
                    GuiText(UI.gui, 0, 0, GameTextGetTranslatedOrNot(wand.item_name))
                else
					GuiText(UI.gui, 0, 0, GameTextGetTranslatedOrNot("$item_wand"))
				end
				GuiLayoutAddVerticalSpacing(UI.gui, 1)
                
                local shuffle
                if wand.shuffle_deck_when_empty then
                    shuffle = GameTextGet("$menu_yes")
                else
                    shuffle = GameTextGet("$menu_no")
                end
                NewLine("$inventory_shuffle", shuffle)
                NewLine("$inventory_actionspercast", wand.actions_per_round)
                NewLine("$inventory_castdelay", SecondWithSign(wand.fire_rate_wait) .. "s(" .. wand.fire_rate_wait ..
                    "f)")
                NewLine("$inventory_rechargetime", SecondWithSign(wand.reload_time) .. "s(" .. wand.reload_time .. "f)")
                NewLine("$inventory_manamax", math.floor(wand.mana_max))
                NewLine("$inventory_manachargespeed", math.floor(wand.mana_charge_speed))
                NewLine("$inventory_capacity", wand.deck_capacity)
                NewLine("$inventory_spread", wand.spread_degrees .. GameTextGet("$kummitus_wand_viewer_deg"))
                NewLine("$kummitus_wand_viewer_speed_multiplier", "x" .. string.format("%.8f", wand.speed_multiplier))
				NewLine("$kummitus_wand_viewer_path", KData[2])
            else
                GuiLayoutBeginHorizontal(UI.gui, 0, 0, true)
                for i = 1, #wand.spells.always do
                    local v = wand.spells.always[i]
                    GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 101)
                    GuiImage(UI.gui, UI.NewID(id .. "always_full_BG" .. tostring(i)), 0, 0,
                        "data/ui_gfx/inventory/full_inventory_box.png", 1, 0.5)
                    local _, _, _, weigthX, _, weigthW = GuiGetPreviousWidgetInfo(UI.gui)
                    if spellData[v.id] ~= nil then --判空，防止法术数据异常
                        GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 102)
                        GuiImage(UI.gui, UI.NewID(id .. v.id .. "always" .. tostring(i)), -12, 0,
                            SpellTypeBG[spellData[v.id].type],
                            1, 0.5)
                        GuiLayoutBeginHorizontal(UI.gui, -11, 0, true, -8, 4) --使得正确的布局实现
                        GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 103)
                        GuiImage(UI.gui, UI.NewID(id .. v.id .. "always_spell" .. tostring(i) .. "BG"), 0, 1,
                            spellData[v.id].sprite, 1, 0.5)

                        GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 104)
                        GuiImage(UI.gui, UI.NewID(id .. v.id .. "Always_icon" .. tostring(k)), 0, 0,
                            "mods/kummitus_wand_viewer/files/gui/images/always_icon.png",
                            1, 0.5)
                        GuiLayoutEnd(UI.gui)
                    end
                    if weigthX + weigthW >= UI.ScreenWidth - 80 then
                        GuiLayoutEnd(UI.gui)
                        GuiLayoutBeginHorizontal(UI.gui, 0, 0, true)
                    end
                end
                for i = 1, #wand.spells.spells do
                    local v = wand.spells.spells[i]
                    GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 101)
                    GuiImage(UI.gui, UI.NewID(id .. "full_BG" .. tostring(i)), 0, 0,
                        "data/ui_gfx/inventory/full_inventory_box.png", 1, 0.5)
                    local _, _, _, weigthX, _, weigthW = GuiGetPreviousWidgetInfo(UI.gui)
                    if v ~= "nil" and spellData[v.id] ~= nil then --判空，防止法术数据异常
                        GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 102)
                        GuiImage(UI.gui, UI.NewID(id .. v.id .. tostring(i) .. "BG"), -12, 0,
                            SpellTypeBG[spellData[v.id].type],
                            1, 0.5)
                        GuiLayoutBeginHorizontal(UI.gui, -11, 0, true, -8, 4) --使得正确的布局实现
                        GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 103)
                        GuiImage(UI.gui, UI.NewID(id .. v.id .. "spell" .. tostring(i)), 0, 1, spellData[v.id].sprite, 1,
                            0.5)
                        local DrawUses = function(thisUses)
                            GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 104)
                            if thisUses then
                                GuiText(UI.gui, 0, 0, tostring(thisUses), 0.5, "data/fonts/font_small_numbers.xml")
                            else
                                GuiText(UI.gui, 0, 0, tostring(v.uses_remaining), 0.5,
                                    "data/fonts/font_small_numbers.xml")
                            end
                        end
                        if v.uses_remaining ~= -1 and inf_spells_enable and spellData[v.id].never_unlimited then --开启无限法术了，还不为空，那么就直接作为结果
                            DrawUses()
                            --没开启无限法术，使用次数为无限，但是查询其有使用次数为有限的那么就拿查询的作为结果
                        elseif not inf_spells_enable and (v.uses_remaining == -1 or v.uses_remaining == nil) and (spellData[v.id].max_uses and spellData[v.id].max_uses ~= -1) then
                            DrawUses(spellData[v.id].max_uses)
                        elseif v.uses_remaining ~= -1 and not inf_spells_enable then
                            DrawUses()
                        end
                        GuiLayoutEnd(UI.gui)
                    end
                    if weigthX + weigthW >= UI.ScreenWidth - 80 then
                        GuiLayoutEnd(UI.gui)
                        GuiLayoutBeginHorizontal(UI.gui, 0, 0, true)
                    end
                end
                GuiLayoutEnd(UI.gui)
                GuiColorSetForNextWidget(UI.gui, 0.5, 0.5, 0.5, 1.0)
                GuiText(UI.gui, 0, 0, GameTextGet("$kummitus_wand_viewer_wand_depot_wand_desc"))
            end
            GuiLayoutEnd(UI.gui)
        end, UI.GetZDeep() - 100, 10)
    end
	
	if left_click then
		if UI.UserData["WandDepotKHighlight"] == k then
			UI.UserData["WandDepotKHighlight"] = nil
		else
			UI.UserData["WandDepotKHighlight"] = k
		end
	end
	GuiZSetForNextWidget(UI.gui, UI.GetZDeep() - 1)
    GuiImage(UI.gui, UI.NewID(id .. tostring(k)), 5 + x, 22 + y, sprite, 1, 1, 0, deg57_5)
end

function DarwWandContainer()
	local WandDepotH = 135
	local WandDepotW = 234
    UI.ScrollContainer("WandDepot", 20, 64, WandDepotW, WandDepotH, 2, 2)
    UI.AddAnywhereItem("WandDepot", function()
        for k, v in pairs(KummitusWands) do
			DrawWandSlot("KummitusWandsSlot",k,v)
		end
	end)
    UI.DrawScrollContainer("WandDepot", false) --绘制框内控件和框

	local RewriteWandCB = function(left_click)
		if left_click then
            ClickSound()
            if UI.UserData["WandDepotKHighlight"] == nil then
                return
            end
			local k = UI.UserData["WandDepotKHighlight"] + 1
			local held = GetHeldWand()
			if held == nil then
				return
			end
			InitWand(KummitusWands[k][1], held)
			UI.OnceCallOnExecute(function()
				RefreshHeldWands()
			end)
		end
	end
	GuiZSetForNextWidget(UI.gui, UI.GetZDeep())
	UI.MoveImageButton("WandDepotRewriteWand", 25, 64 + WandDepotH + 7,
		"mods/kummitus_wand_viewer/files/gui/images/kummitus_rewritewand.png", nil, function()
			GuiTooltip(UI.gui, GameTextGet("$kummitus_wand_viewer_wand_depot_rewritewand"), "")
		end, RewriteWandCB, false, true)

	local LoadWandCB = function(left_click)
		if left_click then
			ClickSound()
            if UI.UserData["WandDepotKHighlight"] == nil then
                return
            end

			local k = UI.UserData["WandDepotKHighlight"] + 1
			InitWand(KummitusWands[k][1], nil, Compose(EntityGetTransform, GetPlayer)())
		end
	end
	GuiZSetForNextWidget(UI.gui, UI.GetZDeep())
	UI.MoveImageButton("WandDepotLoadWand", 50, 64 + WandDepotH + 7,
		"mods/kummitus_wand_viewer/files/gui/images/kummitus_loadwand.png", nil, function()
			GuiTooltip(UI.gui, GameTextGet("$kummitus_wand_viewer_wand_depot_loadwand"), "")
        end, LoadWandCB, false, true)
end
