-- #Modify by Global 2.0;

-- #Executing this script without API may lead to error;

local VExAxvO = GG;

if VExAxvO["AcrylicTable"] == nil then
    VExAxvO["AcrylicTable"] = {}
end
if VExAxvO["ClearAcrylic"] == nil then
    VExAxvO["ClearAcrylic"] = false
end

local function ElBlurSourceV2()
    local GuiSystem = {}
    local RunService = game:GetService('RunService')
    local CurrentCamera = workspace.CurrentCamera
    local TweenService = game:GetService("TweenService")

    function GuiSystem:Hash()
        return string.reverse(string.gsub(game:GetService('HttpService'):GenerateGUID(false), '..', function(aa)
            return string.reverse(aa)
        end))
    end

    local function Hiter(planePos, planeNormal, rayOrigin, rayDirection)
        local n = planeNormal
        local d = rayDirection
        local v = rayOrigin - planePos

        local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z)
        local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z)
        local a = -num / den

        return rayOrigin + (a * rayDirection), a
    end

    function GuiSystem.new(frame)
        local Part = Instance.new('Part', workspace)
        local DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
        local SurfaceGui = Instance.new('SurfaceGui', Part)
        local BlockMesh = Instance.new("BlockMesh")

        BlockMesh.Parent = Part

        Part.Material = Enum.Material.Glass
        Part.Transparency = 0.99
        Part.Reflectance = 1
        Part.CastShadow = false
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CollisionGroup = GuiSystem:Hash()
        Part.Size = Vector3.new(1, 1, 1) * 0.01
        Part.Color = Color3.fromRGB(0, 0, 0)

        DepthOfField.Enabled = true
        DepthOfField.FarIntensity = 1
        DepthOfField.FocusDistance = 0
        DepthOfField.InFocusRadius = 500
        DepthOfField.NearIntensity = 1

        SurfaceGui.AlwaysOnTop = true
        SurfaceGui.Adornee = Part
        SurfaceGui.Active = true
        SurfaceGui.Face = Enum.NormalId.Front
        SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        DepthOfField.Name = GuiSystem:Hash()
        Part.Name = GuiSystem:Hash()
        SurfaceGui.Name = GuiSystem:Hash()

        local C4 = {
            Update = nil,
            Collection = SurfaceGui,
            Enabled = true,
            Instances = {
                BlockMesh = BlockMesh,
                Part = Part,
                DepthOfField = DepthOfField,
                SurfaceGui = SurfaceGui,
            },
            Signal = nil
        }
        table.insert(VExAxvO["AcrylicTable"], C4)
        local Update = function()
            if not C4.Enabled then
                Part.Transparency = 1
            else
                Part.Transparency = 0.99
            end

            local corner0 = frame.AbsolutePosition
            local corner1 = corner0 + frame.AbsoluteSize

            local ray0 = CurrentCamera:ScreenPointToRay(corner0.X, corner0.Y, 1)
            local ray1 = CurrentCamera:ScreenPointToRay(corner1.X, corner1.Y, 1)

            local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ)
            local planeNormal = CurrentCamera.CFrame.LookVector

            local pos0, _ = Hiter(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
            local pos1, _ = Hiter(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

            pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0)
            pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1)

            local size = pos1 - pos0
            local center = (pos0 + pos1) / 2

            BlockMesh.Offset = center
            BlockMesh.Scale = size / 0.0101
            Part.CFrame = CurrentCamera.CFrame

            DepthOfField.Enabled = true
        end

        C4.Update = Update
        C4.Signal = RunService.RenderStepped:Connect(Update)
        
        task.spawn(function()
            repeat task.wait() until VExAxvO["getAcrylics"]
            Part:Destroy(); DepthOfField:Destroy(); SurfaceGui:Destroy();
        end)

        return C4
    end

    function GuiSystem:UpdateEffect(frame)
        if self.Update then
            self.Update(frame)
        end
    end

    return GuiSystem
end

return ElBlurSourceV2()
