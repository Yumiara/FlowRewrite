-- https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua

local Icons = {
    ["lucide"] = loadScriptFromCache("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua", "IconaLucide"),
    ["craft"] = loadScriptFromCache("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/craft/dist/Icons.lua", "IconaCraft");,
    
    
    -- More soon 
    -- 
}


local IconModule = {
    IconsType = "lucide" --
}

function IconModule.SetIconsType(iconType)
    IconModule.IconsType = iconType
end

function IconModule.Icon(Icon, Type) -- Type: optional
    local iconType = Icons[Type or IconModule.IconsType]
    
    if iconType.Icons[Icon] then
        return { iconType.Spritesheets[tos(iconType.Icons[Icon].Image)], iconType.Icons[Icon] }
    end
    return nil
end

return IconModule
