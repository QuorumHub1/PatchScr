print"hi"
local Patched = nil
local function CheckIsPatched()
    local execName = getgenv().ExecName()
    if game:FindFirstChild("Quorum") then
        Patched = true
    else
        if game:FindFirstChild(execName) ~= nil then
            print"patched"
            Patched = true
        else
            Patched = false
            print"not patched"
        end
    end
end

CheckIsPatched()
local function XenoVFSblocker()
    local function Spy()
        local notificationFrame = game:GetService("CoreGui").RobloxGui:FindFirstChild("NotificationFrame")
        if notificationFrame then
            local notification = notificationFrame:FindFirstChild("Notification")
            if notification then
                local notificationTitle = notification:FindFirstChild("NotificationTitle")
                if notificationTitle and notificationTitle.Text == "[Xeno - VFS]" then
                    notification:Destroy()
                end
            end
        end
    end
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        Spy()
    end)
end
if Patched == false then
    if game:GetService("ThirdPartyUserService") then
        if getgenv().ExecName and type(getgenv().ExecName) == "function" then
            game.ThirdPartyUserService.Name = getgenv().ExecName()
        else
            game.ThirdPartyUserService.Name = "Quorum"
        end
        XenoVFSblocker()
    else
        -- Not Xeno Edition, skip.
        local Quorum = Instance.New("Part")
        Quorum.Parent = game
        Quorum.Name = "Quorum"
    end
    getgenv().identifyexecutor = function()
        if getgenv().ExecName and type(getgenv().ExecName) == "function" and 
           getgenv().ExecVer and type(getgenv().ExecVer) == "function" then
            return getgenv().ExecName() .. " " .. getgenv().ExecVer()
        else
            return "Quorum v1.0.0"
        end
    end
    getgenv().getexecutorname = function()
        if getgenv().ExecName and type(getgenv().ExecName) == "function" then
            return getgenv().ExecName()
        else
            return "Quorum"
        end
    end
    getgenv().getidentity = function()
        if getgenv().Level and type(getgenv().Level) == "function" then
            return getgenv().Level()
        else
            return "3"
        end
    end
    local uas = "Quorum/1.0.0"
    if getgenv().CUA and type(getgenv().CUA) == "function" then
        uas = getgenv().CUA()
    else
        uas = "Quorum/1.0.0"
    end
    local oldr = request
    getgenv().request = function(options)
        if options.Headers then
            options.Headers["User-Agent"] = uas
        else
            options.Headers = {["User-Agent"] = uas}
        end
        local response = oldr(options)
        return response
    end
    Patched = true
end
