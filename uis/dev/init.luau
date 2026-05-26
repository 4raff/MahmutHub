repeat wait() until game:IsLoaded()

local Config = {
    -- [1] PlatoBoost Settings
    ServiceId = 25185, -- Your PlatoBoost Service ID
    PlatoSecret = "72146dbc-3d04-4ba2-a1b8-9edfb0cd511e", -- Your PlatoBoost Secret Key

    -- [2] Anti-Bypass / Global Secret Variable
    Secret = "ZLK23", -- This makes the script ONLY run from the key script. Even if they copy the original obfuscated script to bypass the key, they won't be able to!

    -- [3] Scripts & Links
    MainScriptURL = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/main.lua", -- The raw URL of your main script

    -- [4] Social Media Settings (Set to true to show, false to hide)
    ShowDiscord = true,
    DiscordURL = "https://discord.gg/xHgUpRkh24",

    ShowInstagram = false,
    InstagramURL = "https://www.instagram.com/oyb0i/",

    ShowYoutube = false,
    YoutubeURL = "https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ",

    -- [5] File System Path
    KeyFileName = "Mahmut-Hub/Mykey.txt", -- The name of the file where the valid key will be saved for auto-login

    -- [6] GUI Management
    OldGuiName = "anything", -- Name of the old GUI to destroy if it's already open
    MainGuiName = "anything", -- Name of the main script's GUI to check if it's already executing

    -- [7] Hub Information & UI Text
    HubName = "Mahmut Hub", -- The main title shown at the top of the GUI
    HubDescription = "Join the discord for the suggestion" -- The text shown below the title
}

-------------------------------------------------------------------------------
-- ! LIBRARIES (JSON & CRYPTOGRAPHY) - DO NOT MODIFY
-------------------------------------------------------------------------------
local a = 2 ^ 32;
local b = a - 1;
local function c(d, e)
    local f, g = 0, 1;
    while d ~= 0 or e ~= 0 do
        local h, i = d % 2, e % 2;
        local j = (h + i) % 2;
        f = f + j * g;
        d = math.floor(d / 2)
        e = math.floor(e / 2)
        g = g * 2
    end
    return f % a
end
local function k(d, e, l, ...)
    local m;
    if e then
        d = d % a;
        e = e % a;
        m = c(d, e)
        if l then
            m = k(m, l, ...)
        end
        return m
    elseif d then
        return d % a
    else
        return 0
    end
end
local function n(d, e, l, ...)
    local m;
    if e then
        d = d % a;
        e = e % a;
        m = (d + e - c(d, e)) / 2;
        if l then
            m = n(m, l, ...)
        end
        return m
    elseif d then
        return d % a
    else
        return b
    end
end
local function o(p)
    return b - p
end
local function q(d, r)
    if r < 0 then
        return lshift(d, -r)
    end
    return math.floor(d % 2 ^ 32 / 2 ^ r)
end
local function s(p, r)
    if r > 31 or r < -31 then
        return 0
    end
    return q(p % a, r)
end
local function lshift(d, r)
    if r < 0 then
        return s(d, -r)
    end
    return d * 2 ^ r % 2 ^ 32
end
local function t(p, r)
    p = p % a;
    r = r % 32;
    local u = n(p, 2 ^ r - 1)
    return s(p, r) + lshift(u, 32 - r)
end
local v = {0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98,
           0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
           0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8,
           0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
           0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819,
           0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
           0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
           0xc67178f2}
local function w(x)
    return string.gsub(x, ".", function(l)
        return string.format("%02x", string.byte(l))
    end)
end
local function y(z, A)
    local x = ""
    for B = 1, A do
        local C = z % 256;
        x = string.char(C) .. x;
        z = (z - C) / 256
    end
    return x
end
local function D(x, B)
    local A = 0;
    for B = B, B + 3 do
        A = A * 256 + string.byte(x, B)
    end
    return A
end
local function E(F, G)
    local H = 64 - (G + 9) % 64;
    G = y(8 * G, 8)
    F = F .. "\128" .. string.rep("\0", H) .. G;
    assert(#F % 64 == 0)
    return F
end
local function I(J)
    J[1] = 0x6a09e667;
    J[2] = 0xbb67ae85;
    J[3] = 0x3c6ef372;
    J[4] = 0xa54ff53a;
    J[5] = 0x510e527f;
    J[6] = 0x9b05688c;
    J[7] = 0x1f83d9ab;
    J[8] = 0x5be0cd19;
    return J
end
local function K(F, B, J)
    local L = {}
    for M = 1, 16 do
        L[M] = D(F, B + (M - 1) * 4)
    end
    for M = 17, 64 do
        local N = L[M - 15]
        local O = k(t(N, 7), t(N, 18), s(N, 3))
        N = L[M - 2]
        L[M] = (L[M - 16] + O + L[M - 7] + k(t(N, 17), t(N, 19), s(N, 10))) % a
    end
    local d, e, l, P, Q, R, S, T = J[1], J[2], J[3], J[4], J[5], J[6], J[7], J[8]
    for B = 1, 64 do
        local O = k(t(d, 2), t(d, 13), t(d, 22))
        local U = k(n(d, e), n(d, l), n(e, l))
        local V = (O + U) % a;
        local W = k(t(Q, 6), t(Q, 11), t(Q, 25))
        local X = k(n(Q, R), n(o(Q), S))
        local Y = (T + W + X + v[B] + L[B]) % a;
        T = S;
        S = R;
        R = Q;
        Q = (P + Y) % a;
        P = l;
        l = e;
        e = d;
        d = (Y + V) % a
    end
    J[1] = (J[1] + d) % a;
    J[2] = (J[2] + e) % a;
    J[3] = (J[3] + l) % a;
    J[4] = (J[4] + P) % a;
    J[5] = (J[5] + Q) % a;
    J[6] = (J[6] + R) % a;
    J[7] = (J[7] + S) % a;
    J[8] = (J[8] + T) % a
end
local function Z(F)
    F = E(F, #F)
    local J = I({})
    for B = 1, #F, 64 do
        K(F, B, J)
    end
    return w(y(J[1], 4) .. y(J[2], 4) .. y(J[3], 4) .. y(J[4], 4) .. y(J[5], 4) .. y(J[6], 4) .. y(J[7], 4) ..
                 y(J[8], 4))
end
local e;
local l = {
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\b"] = "b",
    ["\f"] = "f",
    ["\n"] = "n",
    ["\r"] = "r",
    ["\t"] = "t"
}
local P = {
    ["/"] = "/"
}
for Q, R in pairs(l) do
    P[R] = Q
end
local S = function(T)
    return "\\" .. (l[T] or string.format("u%04x", T:byte()))
end;
local B = function(M)
    return "null"
end;
local v = function(M, z)
    local _ = {}
    z = z or {}
    if z[M] then
        error("circular reference")
    end
    z[M] = true;
    if rawget(M, 1) ~= nil or next(M) == nil then
        local A = 0;
        for Q in pairs(M) do
            if type(Q) ~= "number" then
                error("invalid table: mixed or invalid key types")
            end
            A = A + 1
        end
        if A ~= #M then
            error("invalid table: sparse array")
        end
        for a0, R in ipairs(M) do
            table.insert(_, e(R, z))
        end
        z[M] = nil;
        return "[" .. table.concat(_, ",") .. "]"
    else
        for Q, R in pairs(M) do
            if type(Q) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            table.insert(_, e(Q, z) .. ":" .. e(R, z))
        end
        z[M] = nil;
        return "{" .. table.concat(_, ",") .. "}"
    end
end;
local g = function(M)
    return '"' .. M:gsub('[%z\1-\31\\\"]', S) .. '"'
end;
local a1 = function(M)
    if M ~= M or M <= -math.huge or M >= math.huge then
        error("unexpected number value '" .. tostring(M) .. "'")
    end
    return string.format("%.14g", M)
end;
local j = {
    ["nil"] = B,
    ["table"] = v,
    ["string"] = g,
    ["number"] = a1,
    ["boolean"] = tostring
}
e = function(M, z)
    local x = type(M)
    local a2 = j[x]
    if a2 then
        return a2(M, z)
    end
    error("unexpected type '" .. x .. "'")
end;
local a3 = function(M)
    return e(M)
end;
local a4;
local N = function(...)
    local _ = {}
    for a0 = 1, select("#", ...) do
        _[select(a0, ...)] = true
    end
    return _
end;
local L = N(" ", "\t", "\r", "\n")
local p = N(" ", "\t", "\r", "\n", "]", "}", ",")
local a5 = N("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local m = N("true", "false", "null")
local a6 = {
    ["true"] = true,
    ["false"] = false,
    ["null"] = nil
}
local a7 = function(a8, a9, aa, ab)
    for a0 = a9, #a8 do
        if aa[a8:sub(a0, a0)] ~= ab then
            return a0
        end
    end
    return #a8 + 1
end;
local ac = function(a8, a9, J)
    local ad = 1;
    local ae = 1;
    for a0 = 1, a9 - 1 do
        ae = ae + 1;
        if a8:sub(a0, a0) == "\n" then
            ad = ad + 1;
            ae = 1
        end
    end
    error(string.format("%s at line %d col %d", J, ad, ae))
end;
local af = function(A)
    local a2 = math.floor;
    if A <= 0x7f then
        return string.char(A)
    elseif A <= 0x7ff then
        return string.char(a2(A / 64) + 192, A % 64 + 128)
    elseif A <= 0xffff then
        return string.char(a2(A / 4096) + 224, a2(A % 4096 / 64) + 128, A % 64 + 128)
    elseif A <= 0x10ffff then
        return string.char(a2(A / 262144) + 240, a2(A % 262144 / 4096) + 128, a2(A % 4096 / 64) + 128, A % 64 + 128)
    end
    error(string.format("invalid unicode codepoint '%x'", A))
end;
local ag = function(ah)
    local ai = tonumber(ah:sub(1, 4), 16)
    local aj = tonumber(ah:sub(7, 10), 16)
    if aj then
        return af((ai - 0xd800) * 0x400 + aj - 0xdc00 + 0x10000)
    else
        return af(ai)
    end
end;
local ak = function(a8, a0)
    local _ = ""
    local al = a0 + 1;
    local Q = al;
    while al <= #a8 do
        local am = a8:byte(al)
        if am < 32 then
            ac(a8, al, "control character in string")
        elseif am == 92 then
            _ = _ .. a8:sub(Q, al - 1)
            al = al + 1;
            local T = a8:sub(al, al)
            if T == "u" then
                local an = a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", al + 1) or a8:match("^%x%x%x%x", al + 1) or
                               ac(a8, al - 1, "invalid unicode escape in string")
                _ = _ .. ag(an)
                al = al + #an
            else
                if not a5[T] then
                    ac(a8, al - 1, "invalid escape char '" .. T .. "' in string")
                end
                _ = _ .. P[T]
            end
            Q = al + 1
        elseif am == 34 then
            _ = _ .. a8:sub(Q, al - 1)
            return _, al + 1
        end
        al = al + 1
    end
    ac(a8, a0, "expected closing quote for string")
end;
local ao = function(a8, a0)
    local am = a7(a8, a0, p)
    local ah = a8:sub(a0, am - 1)
    local A = tonumber(ah)
    if not A then
        ac(a8, a0, "invalid number '" .. ah .. "'")
    end
    return A, am
end;
local ap = function(a8, a0)
    local am = a7(a8, a0, p)
    local aq = a8:sub(a0, am - 1)
    if not m[aq] then
        ac(a8, a0, "invalid literal '" .. aq .. "'")
    end
    return a6[aq], am
end;
local ar = function(a8, a0)
    local _ = {}
    local A = 1;
    a0 = a0 + 1;
    while 1 do
        local am;
        a0 = a7(a8, a0, L, true)
        if a8:sub(a0, a0) == "]" then
            a0 = a0 + 1;
            break
        end
        am, a0 = a4(a8, a0)
        _[A] = am;
        A = A + 1;
        a0 = a7(a8, a0, L, true)
        local as = a8:sub(a0, a0)
        a0 = a0 + 1;
        if as == "]" then
            break
        end
        if as ~= "," then
            ac(a8, a0, "expected ']' or ','")
        end
    end
    return _, a0
end;
local at = function(a8, a0)
    local _ = {}
    a0 = a0 + 1;
    while 1 do
        local au, M;
        a0 = a7(a8, a0, L, true)
        if a8:sub(a0, a0) == "}" then
            a0 = a0 + 1;
            break
        end
        if a8:sub(a0, a0) ~= '"' then
            ac(a8, a0, "expected string for key")
        end
        au, a0 = a4(a8, a0)
        a0 = a7(a8, a0, L, true)
        if a8:sub(a0, a0) ~= ":" then
            ac(a8, a0, "expected ':' after key")
        end
        a0 = a7(a8, a0 + 1, L, true)
        M, a0 = a4(a8, a0)
        _[au] = M;
        a0 = a7(a8, a0, L, true)
        local as = a8:sub(a0, a0)
        a0 = a0 + 1;
        if as == "}" then
            break
        end
        if as ~= "," then
            ac(a8, a0, "expected '}' or ','")
        end
    end
    return _, a0
end;
local av = {
    ['"'] = ak,
    ["0"] = ao,
    ["1"] = ao,
    ["2"] = ao,
    ["3"] = ao,
    ["4"] = ao,
    ["5"] = ao,
    ["6"] = ao,
    ["7"] = ao,
    ["8"] = ao,
    ["9"] = ao,
    ["-"] = ao,
    ["t"] = ap,
    ["f"] = ap,
    ["n"] = ap,
    ["["] = ar,
    ["{"] = at
}
a4 = function(a8, a9)
    local as = a8:sub(a9, a9)
    local a2 = av[as]
    if a2 then
        return a2(a8, a9)
    end
    ac(a8, a9, "unexpected character '" .. as .. "'")
end;
local aw = function(a8)
    if type(a8) ~= "string" then
        error("expected argument of type string, got " .. type(a8))
    end
    local _, a9 = a4(a8, a7(a8, 1, L, true))
    a9 = a7(a8, a9, L, true)
    if a9 <= #a8 then
        ac(a8, a9, "trailing garbage")
    end
    return _
end;
local lEncode, lDecode, lDigest = a3, aw, Z;

-------------------------------------------------------------------------------
-- ! CORE FUNCTIONS (REQUESTS & VERIFICATION)
-------------------------------------------------------------------------------

local useNonce = true -- Hidden from Config to avoid user confusion, but active for security

-- Safe request function for universal executor support
local function safeRequest(options)
    local req = request or http_request or syn_request or (http and http.request)
    if not req then
        return nil, "HTTP requests not supported"
    end
    local success, response = pcall(function()
        return req(options)
    end)
    if success and response then
        return response
    else
        return nil, "Connection Error"
    end
end

local fSetClipboard = setclipboard or toclipboard or function()
end
local fStringChar, fToString, fOsTime, fMathRandom, fMathFloor = string.char, tostring, os.time, math.random, math.floor
local fGetHwid = gethwid or function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local cachedLink, cachedTime = "", 0
local host = "https://api.platoboost.com"

-- Check server connectivity
local function checkConnectivity()
    local response = safeRequest({
        Url = host .. "/public/connectivity",
        Method = "GET"
    })
    if not response or (response.StatusCode ~= 200 and response.StatusCode ~= 429) then
        host = "https://api.platoboost.net"
    end
end
checkConnectivity()

local function generateNonce()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

-- Get player's key link
local function cacheLink()
    if cachedTime + (10 * 60) < fOsTime() then
        local response, err = safeRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = Config.ServiceId,
                identifier = lDigest(fGetHwid())
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
        if response and response.StatusCode == 200 then
            local decoded = lDecode(response.Body)
            if decoded.success then
                cachedLink = decoded.data.url
                cachedTime = fOsTime()
                return true, cachedLink
            end
        end
        return false, err or "Server Unreachable"
    end
    return true, cachedLink
end

-- Verify key on input
local function redeemKey(key)
    local nonce = generateNonce()
    local body = {
        identifier = lDigest(fGetHwid()),
        key = key
    }
    if useNonce then
        body.nonce = nonce
    end

    local response, err = safeRequest({
        Url = host .. "/public/redeem/" .. fToString(Config.ServiceId),
        Method = "POST",
        Body = lEncode(body),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.data.valid then
            if useNonce then
                if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. Config.PlatoSecret) then
                    if writefile then
                        writefile(Config.KeyFileName, key)
                    end
                    return true, "Success"
                end
                return false, "Integrity Check Failed"
            end
            if writefile then
                writefile(Config.KeyFileName, key)
            end
            return true, "Success"
        end
        return false, decoded.message or "Invalid Key"
    end
    return false, err or "Server Error"
end


-------------------------------------------------------------------------------
--! GUI & MAIN SCRIPT EXECUTION
-------------------------------------------------------------------------------

local function StartMainScript()
    local player = game:GetService("Players").LocalPlayer
    local pGui = player:WaitForChild("PlayerGui")
    
    -- Destroy old GUI if it exists
    if pGui:FindFirstChild(Config.OldGuiName) then 
        pGui[Config.OldGuiName]:Destroy() 
        task.wait(0.1)
    end
    
    -- Set secret global variable to bypass main script protection
    _G[Config.Secret] = true 
    
    -- Execute main script
    loadstring(game:HttpGet(Config.MainScriptURL))()
end

local function CreateGUI()
    local player = game:GetService("Players").LocalPlayer
    local coreGui = game:GetService("CoreGui")
    local targetParent = pcall(function() return coreGui end) and coreGui or player:WaitForChild("PlayerGui")

    if targetParent:FindFirstChild("MahmutHub_KeySystem") then
        targetParent.MahmutHub_KeySystem:Destroy()
    end

    -- Colors
    local C = {
        BG          = Color3.fromRGB(6, 8, 16),
        Panel       = Color3.fromRGB(10, 12, 20),
        Cyan        = Color3.fromRGB(0, 245, 255),
        CyanDim     = Color3.fromRGB(0, 160, 175),
        Purple      = Color3.fromRGB(140, 90, 255),
        Discord     = Color3.fromRGB(88, 101, 242),
        Instagram   = Color3.fromRGB(225, 48, 108),
        YouTube     = Color3.fromRGB(255, 40, 40),
        Red         = Color3.fromRGB(255, 60, 80),
        Green       = Color3.fromRGB(0, 255, 136),
        White       = Color3.fromRGB(255, 255, 255),
        Dark1       = Color3.fromRGB(15, 17, 28),
        Dark2       = Color3.fromRGB(22, 25, 38),
        TextDim     = Color3.fromRGB(100, 120, 140),
    }

    -- Helper: RGB animated UIStroke
    local function AddRGBStroke(parent, thickness)
        local stroke = Instance.new("UIStroke", parent)
        stroke.Thickness = thickness or 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        task.spawn(function()
            while stroke.Parent do
                stroke.Color = Color3.fromHSV(tick() % 4 / 4, 1, 1)
                task.wait()
            end
        end)
        return stroke
    end

    -- Helper: Tween shortcut
    local TweenService = game:GetService("TweenService")
    local function Tween(obj, props, t)
        TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
    end

    -- Helper: Hover glow effect on button
    local function AddHoverGlow(btn, normalColor, hoverColor, stroke)
        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundColor3 = hoverColor })
            if stroke then Tween(stroke, { Transparency = 0 }) end
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundColor3 = normalColor })
            if stroke then Tween(stroke, { Transparency = 0.4 }) end
        end)
    end

    -------------------------------------------------------
    -- ROOT
    -------------------------------------------------------
    local ScreenGui = Instance.new("ScreenGui", targetParent)
    ScreenGui.Name = "MahmutHub_KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 0
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -------------------------------------------------------
    -- BACKGROUND OVERLAY
    -------------------------------------------------------
    local BG = Instance.new("Frame", ScreenGui)
    BG.Size = UDim2.fromScale(1, 1)
    BG.BackgroundColor3 = Color3.fromRGB(4, 5, 10)
    BG.BackgroundTransparency = 0.35
    BG.BorderSizePixel = 0

    -- Scanline texture overlay
    local Scan = Instance.new("Frame", BG)
    Scan.Size = UDim2.fromScale(1, 1)
    Scan.BackgroundTransparency = 1
    Scan.BorderSizePixel = 0

    -------------------------------------------------------
    -- MAIN PANEL
    -------------------------------------------------------
    local Panel = Instance.new("Frame", ScreenGui)
    Panel.Size = UDim2.new(0, 360, 0, 0) -- height set at end
    Panel.Position = UDim2.new(0.5, -180, 0.5, 0)
    Panel.AnchorPoint = Vector2.new(0, 0.5)
    Panel.BackgroundColor3 = C.Panel
    Panel.BackgroundTransparency = 0.12
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.Draggable = true

    local panelCorners = Instance.new("UICorner", Panel)
    panelCorners.CornerRadius = UDim.new(0, 20)


    -- Panel outer glow stroke (cyan)
    local panelStroke = Instance.new("UIStroke", Panel)
    panelStroke.Thickness = 1.5
    panelStroke.Color = C.Cyan
    panelStroke.LineJoinMode = Enum.LineJoinMode.Bevel
    panelStroke.Transparency = 0.55

    -------------------------------------------------------
    -- HEADER
    -------------------------------------------------------
    local Header = Instance.new("Frame", Panel)
    Header.Size = UDim2.new(1, 0, 0, 72)
    Header.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
    Header.BackgroundTransparency = 0.3
    Header.BorderSizePixel = 0
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

    -- Header bottom border line
    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1, 0, 0, 1)
    HeaderLine.Position = UDim2.new(0, 0, 1, -1)
    HeaderLine.BackgroundColor3 = C.Cyan
    HeaderLine.BackgroundTransparency = 0.6
    HeaderLine.BorderSizePixel = 0

    -- Title
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -40, 0, 36)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "MAHMUT HUB"
    Title.TextColor3 = C.Cyan
    Title.Font = Enum.Font.Bangers
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Center
    task.spawn(function()
        while Title.Parent do
            Tween(Title, { TextTransparency = 0.05 }, 1.2)
            task.wait(1.2)
            Tween(Title, { TextTransparency = 0.25 }, 1.2)
            task.wait(1.2)
        end
    end)

    local Subtitle = Instance.new("TextLabel", Header)
    Subtitle.Size = UDim2.new(1, 0, 0, 18)
    Subtitle.Position = UDim2.new(0, 0, 0, 46)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "SECURE AUTHENTICATION GATEWAY"
    Subtitle.TextColor3 = C.CyanDim
    Subtitle.TextTransparency = 0.35
    Subtitle.Font = Enum.Font.Bangers
    Subtitle.TextSize = 10
    Subtitle.TextXAlignment = Enum.TextXAlignment.Center

    -- Close button
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0, 12)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 90)
    CloseBtn.TextTransparency = 0.2
    CloseBtn.Font = Enum.Font.Bangers
    CloseBtn.TextSize = 13
    CloseBtn.BorderSizePixel = 0
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke", CloseBtn)
    closeStroke.Thickness = 1
    closeStroke.Color = C.Red
    closeStroke.Transparency = 0.5
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(80, 20, 28), TextTransparency = 0 })
        Tween(closeStroke, { Transparency = 0 })
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(40, 15, 20), TextTransparency = 0.2 })
        Tween(closeStroke, { Transparency = 0.5 })
    end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -------------------------------------------------------
    -- BODY CONTENT
    -------------------------------------------------------
    local Body = Instance.new("Frame", Panel)
    Body.Size = UDim2.new(1, -32, 0, 0) -- height managed below
    Body.Position = UDim2.new(0, 16, 0, 80)
    Body.BackgroundTransparency = 1
    Body.BorderSizePixel = 0

    local bodyLayout = Instance.new("UIListLayout", Body)
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 8)

    local function GetBodyHeight()
        return bodyLayout.AbsoluteContentSize.Y
    end

    -- RGB accent bar
    local RGBBar = Instance.new("Frame", Body)
    RGBBar.Size = UDim2.new(1, 0, 0, 2)
    RGBBar.BorderSizePixel = 0
    RGBBar.LayoutOrder = 0
    task.spawn(function()
        while RGBBar.Parent do
            local hue = tick() % 3 / 3
            RGBBar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait()
        end
    end)

    -- Social button factory
    local function MakeSocialBtn(order, text, normalColor, hoverColor, icon)
        local Btn = Instance.new("TextButton", Body)
        Btn.Size = UDim2.new(1, 0, 0, 38)
        Btn.BackgroundColor3 = normalColor
        Btn.BackgroundTransparency = 0.78
        Btn.Text = (icon and (icon .. "  ") or "") .. text
        Btn.TextColor3 = C.White
        Btn.TextTransparency = 0.1
        Btn.Font = Enum.Font.Bangers
        Btn.TextSize = 13
        Btn.BorderSizePixel = 0
        Btn.LayoutOrder = order
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
        local s = Instance.new("UIStroke", Btn)
        s.Thickness = 1
        s.Color = normalColor
        s.Transparency = 0.4
        AddHoverGlow(Btn, Color3.fromRGB(
            math.floor(normalColor.R * 255 * 0.22),
            math.floor(normalColor.G * 255 * 0.22),
            math.floor(normalColor.B * 255 * 0.22)
        ), Color3.fromRGB(
            math.floor(normalColor.R * 255 * 0.35),
            math.floor(normalColor.G * 255 * 0.35),
            math.floor(normalColor.B * 255 * 0.35)
        ), s)
        return Btn
    end

    local currentOrder = 1

    if Config.ShowDiscord then
        local DiscordBtn = MakeSocialBtn(currentOrder, "JOIN DISCORD", C.Discord, C.Discord, "")
        DiscordBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.DiscordURL)
            StatusUpdate("DISCORD LINK COPIED", C.Discord)
        end)
        currentOrder = currentOrder + 1
    end

    if Config.ShowInstagram then
        local InstaBtn = MakeSocialBtn(currentOrder, "FOLLOW INSTAGRAM", C.Instagram, C.Instagram, "")
        InstaBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.InstagramURL)
            StatusUpdate("INSTAGRAM LINK COPIED", C.Instagram)
        end)
        currentOrder = currentOrder + 1
    end

    if Config.ShowYoutube then
        local YTBtn = MakeSocialBtn(currentOrder, "SUBSCRIBE YOUTUBE", C.YouTube, C.YouTube, "▶")
        YTBtn.MouseButton1Click:Connect(function()
            fSetClipboard(Config.YoutubeURL)
            StatusUpdate("YOUTUBE LINK COPIED", C.YouTube)
        end)
        currentOrder = currentOrder + 1
    end

    -- Divider
    local Divider = Instance.new("Frame", Body)
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.BackgroundColor3 = C.Cyan
    Divider.BackgroundTransparency = 0.72
    Divider.BorderSizePixel = 0
    Divider.LayoutOrder = currentOrder
    currentOrder = currentOrder + 1

    -- Key input
    local KeyInput = Instance.new("TextBox", Body)
    KeyInput.Size = UDim2.new(1, 0, 0, 42)
    KeyInput.BackgroundColor3 = Color3.fromRGB(5, 8, 14)
    KeyInput.BackgroundTransparency = 0.1
    KeyInput.PlaceholderText = "◈  ENTER ACCESS KEY...  ◈"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(0, 130, 145)
    KeyInput.Text = ""
    KeyInput.TextColor3 = C.Cyan
    KeyInput.Font = Enum.Font.Code
    KeyInput.TextSize = 13
    KeyInput.BorderSizePixel = 0
    KeyInput.LayoutOrder = currentOrder
    KeyInput.ClearTextOnFocus = false
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 11)
    local inputStroke = Instance.new("UIStroke", KeyInput)
    inputStroke.Thickness = 1
    inputStroke.Color = C.Cyan
    inputStroke.Transparency = 0.6
    KeyInput.Focused:Connect(function()
        Tween(inputStroke, { Transparency = 0, Color = C.Cyan }, 0.2)
    end)
    KeyInput.FocusLost:Connect(function()
        Tween(inputStroke, { Transparency = 0.6 }, 0.2)
    end)
    currentOrder = currentOrder + 1

    -- Button row frame
    local BtnRow = Instance.new("Frame", Body)
    BtnRow.Size = UDim2.new(1, 0, 0, 42)
    BtnRow.BackgroundTransparency = 1
    BtnRow.BorderSizePixel = 0
    BtnRow.LayoutOrder = currentOrder
    currentOrder = currentOrder + 1
    local rowLayout = Instance.new("UIListLayout", BtnRow)
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Padding = UDim.new(0, 10)

    -- INITIALIZE (Verify) button
    local VerifyBtn = Instance.new("TextButton", BtnRow)
    VerifyBtn.Size = UDim2.new(0.5, -5, 1, 0)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 60)
    VerifyBtn.BackgroundTransparency = 0.3
    VerifyBtn.Text = "VERIFY KEY"
    VerifyBtn.TextColor3 = C.Cyan
    VerifyBtn.Font = Enum.Font.Bangers
    VerifyBtn.TextSize = 13
    VerifyBtn.BorderSizePixel = 0
    VerifyBtn.LayoutOrder = 1
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 11)
    local verifyStroke = Instance.new("UIStroke", VerifyBtn)
    verifyStroke.Thickness = 1.5
    verifyStroke.Color = C.Cyan
    verifyStroke.Transparency = 0.3
    -- Pulse animation
    task.spawn(function()
        while VerifyBtn.Parent do
            Tween(verifyStroke, { Transparency = 0.1 }, 1)
            task.wait(1)
            Tween(verifyStroke, { Transparency = 0.55 }, 1)
            task.wait(1)
        end
    end)
    VerifyBtn.MouseEnter:Connect(function()
        Tween(VerifyBtn, { BackgroundColor3 = Color3.fromRGB(0, 80, 95) })
    end)
    VerifyBtn.MouseLeave:Connect(function()
        Tween(VerifyBtn, { BackgroundColor3 = Color3.fromRGB(0, 50, 60) })
    end)

    -- REQUEST ACCESS (Get Key) button
    local GetKeyBtn = Instance.new("TextButton", BtnRow)
    GetKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 55)
    GetKeyBtn.BackgroundTransparency = 0.3
    GetKeyBtn.Text = "GET KEY"
    GetKeyBtn.TextColor3 = Color3.fromRGB(180, 140, 255)
    GetKeyBtn.Font = Enum.Font.Bangers
    GetKeyBtn.TextSize = 12
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.LayoutOrder = 2
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 11)
    local getKeyStroke = Instance.new("UIStroke", GetKeyBtn)
    getKeyStroke.Thickness = 1
    getKeyStroke.Color = C.Purple
    getKeyStroke.Transparency = 0.45
    GetKeyBtn.MouseEnter:Connect(function()
        Tween(GetKeyBtn, { BackgroundColor3 = Color3.fromRGB(50, 28, 90) })
        Tween(getKeyStroke, { Transparency = 0 })
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        Tween(GetKeyBtn, { BackgroundColor3 = Color3.fromRGB(30, 18, 55) })
        Tween(getKeyStroke, { Transparency = 0.45 })
    end)

    -- Status label
    local Status = Instance.new("TextLabel", Body)
    Status.Name = "StatusLabel"
    Status.Size = UDim2.new(1, 0, 0, 22)
    Status.BackgroundTransparency = 1
    Status.Text = "AWAITING INPUT"
    Status.TextColor3 = C.CyanDim
    Status.TextTransparency = 0.35
    Status.Font = Enum.Font.Bangers
    Status.TextSize = 11
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.LayoutOrder = currentOrder
    currentOrder = currentOrder + 1

    -- Status helper
    function StatusUpdate(msg, color)
        Status.Text = "".. msg ..""
        Status.TextColor3 = color or C.CyanDim
        Status.TextTransparency = 0
    end

    -------------------------------------------------------
    -- BUTTON LOGIC
    -------------------------------------------------------
    VerifyBtn.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        if key == "" then StatusUpdate("ENTER A KEY FIRST", C.Red); return end
        VerifyBtn.Text = "..."
        StatusUpdate("VERIFYING", C.Cyan)
        local success, msg = redeemKey(key)
        VerifyBtn.Text = "INITIALIZE"
        if success then
            StatusUpdate("ACCESS GRANTED — LOADING", C.Green)
            task.wait(0.5)
            ScreenGui:Destroy()
            StartMainScript()
        else
            StatusUpdate(msg or "INVALID KEY", C.Red)
        end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        StatusUpdate("REQUESTING LINK...", C.Cyan)
        local success, link = cacheLink()
        if success then
            fSetClipboard(link)
            StatusUpdate("LINK COPIED TO CLIPBOARD", C.Cyan)
        else
            StatusUpdate("ERROR: " .. tostring(link), C.Red)
        end
    end)

    -------------------------------------------------------
    -- AUTO SAVED KEY CHECK
    -------------------------------------------------------
    if isfile and isfile(Config.KeyFileName) then
        local savedKey = readfile(Config.KeyFileName)
        if savedKey ~= "" then
            StatusUpdate("SAVED KEY FOUND, VERIFYING...", C.Cyan)
            task.spawn(function()
                local success, msg = redeemKey(savedKey)
                if success then
                    StatusUpdate("AUTO-LOGIN SUCCESS", C.Green)
                    task.wait(0.5)
                    ScreenGui:Destroy()
                    StartMainScript()
                else
                    StatusUpdate("SAVED KEY EXPIRED", Color3.fromRGB(255, 165, 0))
                end
            end)
        end
    end

    -------------------------------------------------------
    -- FINALIZE PANEL HEIGHT
    -------------------------------------------------------
    task.defer(function()
        local contentH = bodyLayout.AbsoluteContentSize.Y
        Panel.Size = UDim2.new(0, 360, 0, 80 + contentH + 20)
    end)
end


-- Check if main script GUI is already open
local player = game:GetService("Players").LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

if pGui:FindFirstChild(Config.MainGuiName) then
    StartMainScript() -- Run if main script is already active
    return
end

-- Initialize Key System GUI
CreateGUI()
