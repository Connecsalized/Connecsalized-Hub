local getgc = getgc
local getconstants = getconstants or debug.getconstants
local setconstant = setconstant or debug.setconstant
local setupvalue = setupvalue or debug.setupvalue
local islclosure = islclosure

local targetConstants = {"WalkSpeed", "JumpPower", "MaxHealth", "Sit", "PlatformStand"}

for _, func in ipairs(getgc()) do
    if typeof(func) == "function" and islclosure(func) and not isexecutorclosure(func) then
        local constants = getconstants(func)

        local matches = 0
        for _, word in ipairs(targetConstants) do
            if table.find(constants, word) then
                matches = matches + 1
            end
        end

        if matches >= #targetConstants then
            for i, constant in ipairs(constants) do
                if constant == "h" then
                    setconstant(func, i, "InvalidObject")
                end
            end

            local success = pcall(function()
                setupvalue(func, 1, nil)
            end)
            
            if success then
                warn("Method 2 Loaded!")
            end
        end
    end
end
