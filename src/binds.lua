keycodeMap = {
    [0] = "Escape",
    [1] = "F1",
    [2] = "F2",
    [3] = "F3",
    [4] = "F4",
    [5] = "F5",
    [6] = "F6",
    [7] = "F7",
    [8] = "F8",
    [9] = "F9",
    [10] = "F10",
    [11] = "F11",
    [12] = "F12",
    [32] = "Space",
    [39] = "OemQuotes",
    [44] = "OemComma",
    [45] = "OemMinus",
    [46] = "OemPeriod",
    [48] = "D0",
    [49] = "D1",
    [50] = "D2",
    [51] = "D3",
    [52] = "D4",
    [53] = "D5",
    [54] = "D6",
    [55] = "D7",
    [56] = "D8",
    [57] = "D9",
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z",
    [91] = "LeftWindows",
    [92] = "RightWindows",
    [96] = "NumPad0",
    [97] = "NumPad1",
    [98] = "NumPad2",
    [99] = "NumPad3",
    [100] = "NumPad4",
    [101] = "NumPad5",
    [102] = "NumPad6",
    [103] = "NumPad7",
    [104] = "NumPad8",
    [105] = "NumPad9",
    [106] = "Multiply",
    [107] = "Add",
    [109] = "OemMinus",
    [110] = "OemPeriod",
    [111] = "Divide",
    [160] = "LeftShift",
    [161] = "RightShift",
    [162] = "LeftControl",
    [163] = "RightControl",
    [164] = "LeftAlt",
    [165] = "RightAlt",
    [186] = "OemSemicolon",
    [187] = "OemPlus",
    [188] = "OemComma",
    [189] = "OemMinus",
    [190] = "OemPeriod",
    [191] = "OemQuestion",
    [192] = "OemTilde",
    [219] = "OemOpenBrackets",
    [220] = "OemPipe",
    [221] = "OemCloseBrackets",
    [222] = "OemQuotes",
    Escape = 0,
    F1 = 1,
    F2 = 2,
    F3 = 3,
    F4 = 4,
    F5 = 5,
    F6 = 6,
    F7 = 7,
    F8 = 8,
    F9 = 9,
    F10 = 10,
    F11 = 11,
    F12 = 12,
    Space = 32,
    OemQuotes = 222,
    OemComma = 188,
    OemMinus = 189,
    OemPeriod = 190,
    D0 = 48,
    D1 = 49,
    D2 = 50,
    D3 = 51,
    D4 = 52,
    D5 = 53,
    D6 = 54,
    D7 = 55,
    D8 = 56,
    D9 = 57,
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90,
    LeftWindows = 91,
    RightWindows = 92,
    NumPad0 = 96,
    NumPad1 = 97,
    NumPad2 = 98,
    NumPad3 = 99,
    NumPad4 = 100,
    NumPad5 = 101,
    NumPad6 = 102,
    NumPad7 = 103,
    NumPad8 = 104,
    NumPad9 = 105,
    Multiply = 106,
    Add = 107,
    Divide = 111,
    LeftShift = 160,
    RightShift = 161,
    LeftControl = 162,
    RightControl = 163,
    LeftAlt = 164,
    RightAlt = 165,
    OemSemicolon = 186,
    OemPlus = 187,
    OemQuestion = 191,
    OemTilde = 192,
    OemOpenBrackets = 219,
    OemPipe = 220,
    OemCloseBrackets = 221,
}

BindNames = {"unstuck", "reset", "bigger", "muchBigger", "smaller", "muchSmaller"}
CurrentBinds = CurrentBinds or {}

function setBinds()

    for _, bindName in ipairs(BindNames) do
        local modConfigName = bindName .. "Modifier"
        local keyConfigName = bindName .. "Key"
        local fullBindName = config[modConfigName] .. " " .. config[keyConfigName]
        local fullBindConfigName = bindName .. "Bind"
        config[fullBindConfigName] = fullBindName

        if CurrentBinds[bindName] ~= nil then
            rom.inputs.remove_on_key_pressed(CurrentBinds[bindName])
        end

        --unfortunately we have to switch-case in a loop because funi lambda functions lmao (making functions just for this ain't much better)
        if bindName == "unstuck" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Unstuck Toggle (Always Available)",
                function()
                    GrowUnstuck = not GrowUnstuck

                    if GrowUnstuck then
                        thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "UnstuckEnablePopUp", PreDelay = 0, Duration = 2.5, Cooldown = 1.0 } )
                    else
                        thread( InCombatTextArgs, { TargetId = CurrentRun.Hero.ObjectId, Text = "UnstuckDisablePopUp", PreDelay = 0, Duration = 2.5, Cooldown = 1.0 } )
                    end

                    GrowTraitUpdate()
                end
            })
        elseif bindName == "reset" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Reset Size to Run Start",
                function()
                    if config.sizeControlInRuns == true or (CurrentHubRoom ~= nil and config.sizeControl == true) then
                        GrowHero({ sizeAbsolute = true })
                    end
                end
            })
        elseif bindName == "bigger" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Get Bigger",
                function()
                    if config.sizeControlInRuns == true or (CurrentHubRoom ~= nil and config.sizeControl == true) then
                        if config.growthMode == "Max HP" then AddMaxHealth(10, nil) end
                        GrowHero({ changeValue = 1, doPresentation = true })
                    end
                end
            })
        elseif bindName == "muchBigger" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Get Bigger (5x)",
                function()
                    if config.sizeControlInRuns == true or (CurrentHubRoom ~= nil and config.sizeControl == true) then
                        if config.growthMode == "Max HP" then AddMaxHealth(50, nil) end
                        GrowHero({ changeValue = 5, doPresentation = true })
                    end
                end
            })
        elseif bindName == "smaller" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Get Smaller",
                function()
                    if config.sizeControlInRuns == true or (CurrentHubRoom ~= nil and config.sizeControl == true) then
                        if config.growthMode == "Max HP" then AddMaxHealth(-10, nil) end
                        GrowHero({ changeValue = -1, doPresentation = true })
                    end
                end
            })
        elseif bindName == "muchSmaller" then
            CurrentBinds[bindName] = rom.inputs.on_key_pressed({
                fullBindName,
                Name = "Get Smaller (5x)",
                function()
                    if config.sizeControlInRuns == true or (CurrentHubRoom ~= nil and config.sizeControl == true) then
                        if config.growthMode == "Max HP" then AddMaxHealth(-50, nil) end
                        GrowHero({ changeValue = -5, doPresentation = true })
                    end
                end
            })
        end 
    end
end