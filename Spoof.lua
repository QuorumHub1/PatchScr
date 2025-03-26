local Patched = nil

local function CheckIsPatched()
    local quorumExists = game:FindFirstChild("Quorum") ~= nil
    local execExists = getgenv().ExecName and type(getgenv().ExecName) == "function"
    
    Patched = quorumExists or execExists
end

CheckIsPatched()

local function XenoVFSblocker()
    local function Spy(notification)
        if notification then
            local title = notification:FindFirstChild("NotificationTitle")
            if title and title.Text == "[Xeno - VFS]" then
                notification:Destroy()
            end
        end
    end

    local notificationFrame = game:GetService("CoreGui"):FindFirstChild("RobloxGui") and
                              game.CoreGui.RobloxGui:FindFirstChild("NotificationFrame")

    if notificationFrame then
        notificationFrame.ChildAdded:Connect(Spy)
    end
end

if not Patched then
    local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
    
    if ThirdPartyUserService then
        ThirdPartyUserService.Name = (getgenv().ExecName and type(getgenv().ExecName) == "function") and
                                     getgenv().ExecName() or "Quorum"
        XenoVFSblocker()
    else
        local quorum = Instance.new("Part")
        quorum.Parent = game
        quorum.Name = "Quorum"
    end

    getgenv().identifyexecutor = function()
        return (getgenv().ExecName and type(getgenv().ExecName) == "function" and
                getgenv().ExecVer and type(getgenv().ExecVer) == "function") and
                (getgenv().ExecName() .. getgenv().ExecVer()) or "Quorum v1.0.0"
    end

    getgenv().getexecutorname = function()
        return (getgenv().ExecName and type(getgenv().ExecName) == "function") and
               getgenv().ExecName() or "Quorum"
    end

    getgenv().getidentity = function()
        return (getgenv().Level and type(getgenv().Level) == "function") and
               getgenv().Level() or "3"
    end

    local uas = (getgenv().CUA and type(getgenv().CUA) == "function") and getgenv().CUA() or "Quorum/1.0.0"

    local oldRequest = request
    getgenv().request = function(options)
        if options and type(options) == "table" then
            options.Headers = options.Headers or {}
            options.Headers["User-Agent"] = uas
            local success, response = pcall(oldRequest, options)
            return success and response or nil
        end
    end

    Patched = true
end
