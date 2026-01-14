--[[
  UI Library สำหรับ Roblox Exploit
  โดย: ผู้ใช้
  ใช้สำหรับสร้าง Loader UI ที่สวยงามและใช้งานง่าย
--]]

local UILib = {}

-- สีธีม (สามารถปรับแต่งได้)
UILib.Theme = {
    Primary = Color3.fromRGB(0, 120, 215),
    Secondary = Color3.fromRGB(40, 40, 40),
    Background = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(0, 200, 255),
    Success = Color3.fromRGB(0, 200, 0),
    Warning = Color3.fromRGB(255, 150, 0),
    Danger = Color3.fromRGB(255, 50, 50)
}

-- สร้าง UI หลัก
function UILib.Create(title, sizeX, sizeY)
    local MainUI = {
        Title = title or "Exploit Loader",
        Size = {X = sizeX or 400, Y = sizeY or 500},
        Tabs = {},
        CurrentTab = nil,
        Elements = {}
    }
    
    -- สร้างหน้าต่างหลัก
    MainUI.ScreenGui = Instance.new("ScreenGui")
    MainUI.ScreenGui.Name = "ExploitLoaderUI"
    MainUI.ScreenGui.ResetOnSpawn = false
    MainUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- สร้างเฟรมหลัก
    MainUI.MainFrame = Instance.new("Frame")
    MainUI.MainFrame.Name = "MainFrame"
    MainUI.MainFrame.Size = UDim2.new(0, MainUI.Size.X, 0, MainUI.Size.Y)
    MainUI.MainFrame.Position = UDim2.new(0.5, -MainUI.Size.X/2, 0.5, -MainUI.Size.Y/2)
    MainUI.MainFrame.BackgroundColor3 = UILib.Theme.Background
    MainUI.MainFrame.BorderSizePixel = 0
    MainUI.MainFrame.ClipsDescendants = true
    
    -- เพิ่มเงาให้เฟรม
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 60)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainUI.MainFrame
    
    -- สร้างหัวเรื่อง
    MainUI.TitleBar = Instance.new("Frame")
    MainUI.TitleBar.Name = "TitleBar"
    MainUI.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    MainUI.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    MainUI.TitleBar.BackgroundColor3 = UILib.Theme.Secondary
    MainUI.TitleBar.BorderSizePixel = 0
    
    -- ข้อความหัวเรื่อง
    MainUI.TitleLabel = Instance.new("TextLabel")
    MainUI.TitleLabel.Name = "TitleLabel"
    MainUI.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    MainUI.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    MainUI.TitleLabel.BackgroundTransparency = 1
    MainUI.TitleLabel.Text = MainUI.Title
    MainUI.TitleLabel.TextColor3 = UILib.Theme.Text
    MainUI.TitleLabel.TextSize = 18
    MainUI.TitleLabel.Font = Enum.Font.GothamBold
    MainUI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    MainUI.TitleLabel.Parent = MainUI.TitleBar
    
    -- ปุ่มปิด
    MainUI.CloseButton = Instance.new("TextButton")
    MainUI.CloseButton.Name = "CloseButton"
    MainUI.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    MainUI.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    MainUI.CloseButton.BackgroundColor3 = UILib.Theme.Danger
    MainUI.CloseButton.TextColor3 = UILib.Theme.Text
    MainUI.CloseButton.Text = "X"
    MainUI.CloseButton.TextSize = 16
    MainUI.CloseButton.Font = Enum.Font.GothamBold
    MainUI.CloseButton.Parent = MainUI.TitleBar
    
    -- ทำให้สามารถลาก UI ได้
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        MainUI.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    MainUI.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = MainUI.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    MainUI.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
    
    -- ฟังก์ชันสำหรับปิด UI
    MainUI.CloseButton.MouseButton1Click:Connect(function()
        MainUI:Destroy()
    end)
    
    -- Container สำหรับเนื้อหา
    MainUI.ContentContainer = Instance.new("Frame")
    MainUI.ContentContainer.Name = "ContentContainer"
    MainUI.ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    MainUI.ContentContainer.Position = UDim2.new(0, 0, 0, 40)
    MainUI.ContentContainer.BackgroundTransparency = 1
    MainUI.ContentContainer.Parent = MainUI.MainFrame
    
    -- ฟังก์ชันสำหรับสร้าง Tab
    function MainUI:CreateTab(name)
        local Tab = {
            Name = name,
            Buttons = {},
            Elements = {}
        }
        
        -- เพิ่ม Tab ลงในรายการ
        table.insert(self.Tabs, Tab)
        
        -- ถ้าเป็น Tab แรก ให้ตั้งเป็นปัจจุบัน
        if #self.Tabs == 1 then
            self.CurrentTab = Tab
        end
        
        return Tab
    end
    
    -- ฟังก์ชันสำหรับสร้างปุ่มใน Tab ปัจจุบัน
    function MainUI:CreateButton(text, callback)
        if not self.CurrentTab then
            warn("ไม่มี Tab ปัจจุบัน กรุณาสร้าง Tab ก่อน")
            return nil
        end
        
        local Button = {
            Text = text,
            Callback = callback,
            Enabled = true
        }
        
        -- สร้าง UI สำหรับปุ่ม
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = "Button_" .. text
        buttonFrame.Size = UDim2.new(1, -20, 0, 40)
        buttonFrame.BackgroundColor3 = UILib.Theme.Secondary
        buttonFrame.BorderSizePixel = 0
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = buttonFrame
        
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = UILib.Theme.Primary
        uiStroke.Thickness = 2
        uiStroke.Parent = buttonFrame
        
        local buttonText = Instance.new("TextLabel")
        buttonText.Name = "ButtonText"
        buttonText.Size = UDim2.new(1, 0, 1, 0)
        buttonText.Position = UDim2.new(0, 0, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = text
        buttonText.TextColor3 = UILib.Theme.Text
        buttonText.TextSize = 16
        buttonText.Font = Enum.Font.Gotham
        buttonText.Parent = buttonFrame
        
        local buttonBtn = Instance.new("TextButton")
        buttonBtn.Name = "ButtonBtn"
        buttonBtn.Size = UDim2.new(1, 0, 1, 0)
        buttonBtn.Position = UDim2.new(0, 0, 0, 0)
        buttonBtn.BackgroundTransparency = 1
        buttonBtn.Text = ""
        buttonBtn.Parent = buttonFrame
        
        -- เพิ่มเอฟเฟกต์เมื่อโฮเวอร์
        buttonBtn.MouseEnter:Connect(function()
            if Button.Enabled then
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = UILib.Theme.Primary}):Play()
            end
        end)
        
        buttonBtn.MouseLeave:Connect(function()
            if Button.Enabled then
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = UILib.Theme.Secondary}):Play()
            end
        end)
        
        -- การคลิกปุ่ม
        buttonBtn.MouseButton1Click:Connect(function()
            if Button.Enabled and Button.Callback then
                -- เอฟเฟกต์การคลิก
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = UILib.Theme.Accent}):Play()
                wait(0.1)
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.1), {BackgroundColor3 = UILib.Theme.Secondary}):Play()
                
                -- เรียก callback
                Button.Callback()
            end
        end)
        
        -- เพิ่มลงใน Container
        local layoutOrder = #self.CurrentTab.Buttons + 1
        buttonFrame.LayoutOrder = layoutOrder
        buttonFrame.Parent = self.ContentContainer
        
        -- เพิ่ม UIListLayout ถ้ายังไม่มี
        if not self.ContentContainer:FindFirstChild("UIListLayout") then
            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.Name = "UIListLayout"
            uiListLayout.Padding = UDim.new(0, 10)
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Parent = self.ContentContainer
            
            local uiPadding = Instance.new("UIPadding")
            uiPadding.Name = "UIPadding"
            uiPadding.PaddingLeft = UDim.new(0, 10)
            uiPadding.PaddingRight = UDim.new(0, 10)
            uiPadding.PaddingTop = UDim.new(0, 10)
            uiPadding.PaddingBottom = UDim.new(0, 10)
            uiPadding.Parent = self.ContentContainer
        end
        
        -- เพิ่มลงในรายการ
        table.insert(self.CurrentTab.Buttons, Button)
        table.insert(self.Elements, buttonFrame)
        
        Button.Gui = buttonFrame
        
        -- ฟังก์ชันสำหรับปิด/เปิดปุ่ม
        function Button:SetEnabled(state)
            self.Enabled = state
            if state then
                buttonFrame.BackgroundColor3 = UILib.Theme.Secondary
                buttonText.TextColor3 = UILib.Theme.Text
            else
                buttonFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                buttonText.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
        
        -- ฟังก์ชันสำหรับเปลี่ยนข้อความ
        function Button:SetText(newText)
            self.Text = newText
            buttonText.Text = newText
        end
        
        return Button
    end
    
    -- ฟังก์ชันสำหรับแสดง UI
    function MainUI:Show()
        self.MainFrame.Parent = self.ScreenGui
        self.ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
        return self
    end
    
    -- ฟังก์ชันสำหรับซ่อน UI
    function MainUI:Hide()
        self.ScreenGui.Parent = nil
        return self
    end
    
    -- ฟังก์ชันสำหรับลบ UI
    function MainUI:Destroy()
        self.ScreenGui:Destroy()
        return nil
    end
    
    -- ฟังก์ชันสำหรับเปลี่ยนหัวเรื่อง
    function MainUI:SetTitle(newTitle)
        self.Title = newTitle
        self.TitleLabel.Text = newTitle
        return self
    end
    
    -- เตรียม UI สำหรับแสดง
    MainUI.TitleBar.Parent = MainUI.MainFrame
    MainUI.MainFrame.Parent = MainUI.ScreenGui
    
    return MainUI
end

-- ฟังก์ชันสำหรับสร้าง Loader UI พร้อมตัวอย่าง
--[[function UILib.CreateExampleLoader()
    local loaderUI = UILib.Create("Exploit Loader v1.0", 350, 450)
    
    -- สร้าง Tab หลัก
    loaderUI:CreateTab("Main")
    
    -- สร้างปุ่มตัวอย่าง
    loaderUI:CreateButton("Load Script 1", function()
        print("กำลังโหลด Script 1...")
        -- เพิ่มโค้ดสำหรับโหลดสคริปต์ที่นี่
    end)
    
    loaderUI:CreateButton("Load Script 2", function()
        print("กำลังโหลด Script 2...")
        -- เพิ่มโค้ดสำหรับโหลดสคริปต์ที่นี่
    end)
    
    loaderUI:CreateButton("Execute All", function()
        print("กำลังรันสคริปต์ทั้งหมด...")
        -- เพิ่มโค้ดสำหรับรันสคริปต์ทั้งหมดที่นี่
    end)
    
    loaderUI:CreateButton("Clear Console", function()
        print("ล้าง Console เรียบร้อยแล้ว")
        -- เพิ่มโค้ดสำหรับล้าง Console ที่นี่
    end)
    
    -- ปุ่มสำหรับปิด Loader
    local closeBtn = loaderUI:CreateButton("Close Loader", function()
        loaderUI:Destroy()
    end)
    closeBtn:SetEnabled(true)
    
    -- แสดง UI
    loaderUI:Show()
    
    return loaderUI
end]]
return UILib