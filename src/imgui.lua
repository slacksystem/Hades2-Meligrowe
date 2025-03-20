rom.gui.add_imgui(function()
    if rom.ImGui.Begin("Meligrowe") then
        drawMenu()
        rom.ImGui.End()
    end
end)

rom.gui.add_to_menu_bar(function()
    if rom.ImGui.BeginMenu("Configure") then
        drawMenu()
        rom.ImGui.EndMenu()
    end
end)

function drawMenu()
    if rom.ImGui.CollapsingHeader("Growth Settings") then

        rom.ImGui.TextWrapped("Size Change Mode")
        local scalingModes = { "Per Encounter", "Max HP" }
        rom.ImGui.PushItemWidth(200)
        if rom.ImGui.BeginCombo("###mode", config.growthMode) then
            for _, option in ipairs(scalingModes) do
                if rom.ImGui.Selectable(option, (option == config.growthMode)) then
                    config.growthMode = option
                    rom.ImGui.SetItemDefaultFocus()
                end
            end
            rom.ImGui.EndCombo()
        end
        rom.ImGui.PopItemWidth()

        if config.growthMode == "Per Encounter" then

            local sliderCap = 2.5
            if config.dangerousSizesAllowed then sliderCap = 10.0 end
            
            rom.ImGui.TextWrapped("Starting Size")
            --value, used = rom.ImGui.InputFloat("Times Normal Size##startSize", config.startingSize, 0.1, 2.5)
            value, used = rom.ImGui.SliderFloat("Times Normal Size##startSize", config.startingSize, 0.1, sliderCap, "%.1f")
            if used then
                config.startingSize = value
                config.sizeGrowthPerRoom = (config.finalSize - config.startingSize) / 40
            end

            rom.ImGui.TextWrapped("Approximate Final Size")
            --value, used = rom.ImGui.InputFloat("Times Normal Size##endSize", config.finalSize, 0.1, 2.5)
            value, used = rom.ImGui.SliderFloat("Times Normal Size##endSize", config.finalSize, 0.1, sliderCap, "%.1f")
            if used then
                config.finalSize = value
                config.sizeGrowthPerRoom = (config.finalSize - config.startingSize) / 40
            end
            rom.ImGui.TextWrapped("* Will grow/shrink 25-35% more in Olympus runs.")
            rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0.75, 0, 1)
            rom.ImGui.TextWrapped("* Can go bigger, but can cause major problems, change limits below if you're sure.")
            rom.ImGui.PopStyleColor()

            if config.startingSize > 2.5 or config.finalSize > 2.5 then
                rom.ImGui.Spacing()
                rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0, 0, 1)
                rom.ImGui.TextWrapped("Gameplay gets hard/impossible if you're too big! 2.5 or less recommended.")
                if config.startingSize > 6.0 or config.finalSize > 6.0 then
                    rom.ImGui.TextWrapped("Sizes over 6.0 can cause CRASHES, SOFTLOCKS, and CLIPPING OUT OF BOUNDS! Use the unstuck shrink hotkey or quit to main menu if you screw up.")
                end
                rom.ImGui.PopStyleColor()
            end

            rom.ImGui.Separator()

            rom.ImGui.TextWrapped("Starting Voice Pitch")
            value, used = rom.ImGui.SliderFloat("Pitch Difference##startPitch", config.startingPitch, -2.0, 2.0, "%.1f")
            if used then
                config.startingPitch = value
                config.voicePitchChangePerRoom = (config.finalPitch - config.startingPitch) / 40
            end

            rom.ImGui.TextWrapped("Approximate Final Voice Pitch")
            value, used = rom.ImGui.SliderFloat("Pitch Difference##endPitch", config.finalPitch, -2.0, 2.0, "%.1f")
            if used then
                config.finalPitch = value
                config.voicePitchChangePerRoom = (config.finalPitch - config.startingPitch) / 40
            end
            rom.ImGui.TextWrapped("* Will change 25-35% more in Olympus runs.")
            rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0.75, 0, 1)
            rom.ImGui.TextWrapped("* Voice pitch will sound very silly outside -1.4 - 0.5 range.")
            rom.ImGui.PopStyleColor()

            rom.ImGui.Separator()

            rom.ImGui.TextWrapped("Grows after this many rooms.")
            value, used = rom.ImGui.SliderInt("Rooms##roomCount", config.growEveryXRooms, 1, 10)
            if used then
                config.growEveryXRooms = value
            end
            rom.ImGui.TextWrapped("* Does not change speed of growth. More rooms = bigger bursts of growth.")

        end --End growth mode: Per Encounter

        if config.growthMode == "Max HP" then

            local sliderCap = 2.5
            if config.dangerousSizesAllowed then sliderCap = 10.0 end
            
            value, checked = rom.ImGui.Checkbox("Starting HP is default size", config.healthModeUseStartingHP)
            if checked then
                config.healthModeUseStartingHP = value
            end

            if config.healthModeUseStartingHP == false then
                rom.ImGui.TextWrapped("Normal size at:")
                value, used = rom.ImGui.SliderInt("HP##startSizeHP", config.healthModeNormalSizeHP, 30, 110)
                if used then
                    config.healthModeNormalSizeHP = value
                end
            end

            rom.ImGui.TextWrapped("Size at 400 HP:")
            value, used = rom.ImGui.SliderFloat("Times Normal Size##endSizeHP", config.healthModeBigSize, 0.1, sliderCap, "%.1f")
            if used then
                config.healthModeBigSize = value
            end
            rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0.75, 0, 1)
            rom.ImGui.TextWrapped("* Can go bigger, but can cause major problems, change limits below if you're sure.")
            rom.ImGui.PopStyleColor()

            if config.healthModeBigSize > 2.5 then
                rom.ImGui.Spacing()
                
                rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0, 0, 1)
                rom.ImGui.TextWrapped("Gameplay gets hard/impossible if you're too big! 2.5 or less recommended.")
                if config.healthModeBigSize > 6.0 then
                    rom.ImGui.TextWrapped("Sizes over 6.0 can cause CRASHES, SOFTLOCKS, and CLIPPING OUT OF BOUNDS! Use the unstuck shrink hotkey or quit to main menu if you screw up.")
                end
                rom.ImGui.PopStyleColor()
            end

            rom.ImGui.Separator()

            rom.ImGui.TextWrapped("Voice Pitch at 400 HP:")
            value, used = rom.ImGui.SliderFloat("Pitch Difference##endPitchHP", config.healthModeBigPitch, -2.0, 2.0, "%.1f")
            if used then
                config.healthModeBigPitch = value
            end
            rom.ImGui.TextWrapped("* Will change 25-35% more in Olympus runs.")
            rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0.75, 0, 1)
            rom.ImGui.TextWrapped("* Voice pitch will sound very silly outside -1.4 - 0.5 range.")
            rom.ImGui.PopStyleColor()

        end --End growth mode: Max HP

    end --End Growth Settings
    rom.ImGui.Spacing()

    if rom.ImGui.CollapsingHeader("Limits") then
        value, checked = rom.ImGui.Checkbox("Limit Size (Lower)", config.sizeUseLowerLimit)
        if checked then
            config.sizeUseLowerLimit = value
        end

        if config.sizeUseLowerLimit == true then
            rom.ImGui.TextWrapped("Lower Size Limit:")
            value, used = rom.ImGui.SliderFloat("Times Normal Size##lowerSizeCap", config.sizeLowerLimit, 0.1, 1.0, "%.1f")
            if used then
                config.sizeLowerLimit = value
            end
        end

        value, checked = rom.ImGui.Checkbox("Limit Size (Upper)", config.sizeUseUpperLimit)
        if checked then
            config.sizeUseUpperLimit = value
        end

        if config.sizeUseUpperLimit == true then
            local sliderCap = 3.5
            if config.dangerousSizesAllowed then sliderCap = 10.0 end

            rom.ImGui.TextWrapped("Upper Size Limit:")
            value, used = rom.ImGui.SliderFloat("Times Normal Size##upperSizeCap", config.sizeUpperLimit, 1.0, sliderCap, "%.1f")
            if used then
                config.sizeUpperLimit = value
            end
        end

        rom.ImGui.Separator()

        value, checked = rom.ImGui.Checkbox("Limit Pitch (Lower)", config.voicePitchUseLowerLimit)
        if checked then
            config.voicePitchUseLowerLimit = value
        end

        if config.voicePitchUseLowerLimit == true then
            rom.ImGui.TextWrapped("Lower Pitch Limit:")
            value, used = rom.ImGui.SliderFloat("Pitch Difference##lowerPitchCap", config.voicePitchLowerLimit, -2.0, 0, "%.1f")
            if used then
                config.voicePitchLowerLimit = value
            end
        end

        value, checked = rom.ImGui.Checkbox("Limit Pitch (Upper)", config.voicePitchUseUpperLimit)
        if checked then
            config.voicePitchUseUpperLimit = value
        end

        if config.voicePitchUseUpperLimit == true then
            rom.ImGui.TextWrapped("Upper Pitch Limit:")
            value, used = rom.ImGui.SliderFloat("Pitch Difference##upperPitchCap", config.voicePitchUpperLimit, 0, 2.0, "%.1f")
            if used then
                config.voicePitchUpperLimit = value
            end
        end

        rom.ImGui.Separator()
        
        value, checked = rom.ImGui.Checkbox("Allow Extreme Size Settings", config.dangerousSizesAllowed)
        if checked then
            config.dangerousSizesAllowed = value
        end

        rom.ImGui.TextWrapped("Enables very large size sliders. Can negatively effect gameplay.")
        rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.75, 0, 0, 1)
        rom.ImGui.TextWrapped("Sizes over 6.0 can cause CRASHES, SOFTLOCKS, and CLIPPING OUT OF BOUNDS!")

        if config.dangerousSizesAllowed == true then
            rom.ImGui.Spacing()
            rom.ImGui.TextWrapped("Don't say I didn't warn you. Use the unstuck shrink hotkey or quit to main menu if you screw up.")
        end
        rom.ImGui.PopStyleColor()

    end --End Limits
    rom.ImGui.Spacing()

    


end --drawMenu