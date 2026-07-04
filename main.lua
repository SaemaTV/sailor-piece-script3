-- 1. MEMANGGIL LIBRARY TAMPILAN MENU (GUI)
local Kavo = loadstring(game:HttpGet("https://githubusercontent.com"))()
-- Membuat Jendela Menu Utama
local Window = Kavo.CreateLib("Sailor Piece Member Hub", "DarkTheme")

-- 2. MEMBUAT HALAMAN (TAB) & KATEGORI (SECTION)
local TabUtama = Window:NewTab("Main Farm")
local KategoriFarm = TabUtama:NewSection("Universal Auto Farm")

-- 3. LOGIKA UTAMA SCRIPT (DIAMBIL DARI LANGKAH SEBELUMNYA)
local Pemain = game:GetService("Players").LocalPlayer
local GameWorkspace = game:GetService("Workspace")

_G.UniversalFarm = false -- Default mati saat pertama diaktifkan

function dapatkanMusuhTerdekat()
    local jarakTerdekat = math.huge
    local targetMusuh = nil
    
    for _, objek in pairs(GameWorkspace:GetChildren()) do
        if objek:IsA("Model") and objek:FindFirstChild("Humanoid") and objek:FindFirstChild("HumanoidRootPart") then
            if objek.Humanoid.Health > 0 and not game:GetService("Players"):GetPlayerFromCharacter(objek) then
                local jarak = (Pemain.Character.HumanoidRootPart.Position - objek.HumanoidRootPart.Position).Magnitude
                if jarak < jarakTerdekat then
                    jarakTerdekat = jarak
                    targetMusuh = objek
                end
            end
        end
    end
    return targetMusuh
end

-- Fungsi Loop Auto-Farm yang berjalan di latar belakang
spawn(function()
    while true do
        task.wait(0.1)
        if _G.UniversalFarm then
            pcall(function()
                local musuh = dapatkanMusuhTerdekat()
                if musuh and Pemain.Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport ke atas musuh agar aman dari air/laut
                    Pemain.Character.HumanoidRootPart.CFrame = musuh.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    
                    -- Otomatis memakai senjata
                    local Senjata = Pemain.Character:FindFirstChildOfClass("Tool") or Pemain.Backpack:FindFirstChildOfClass("Tool")
                    if Senjata then
                        Pemain.Character.Humanoid:EquipTool(Senjata)
                        Senjata:Activate()
                    end
                end
            end)
        end
    end
end)

-- 4. MEMBUAT TOMBOL ON/OFF (TOGGLE) DI MENU
KategoriFarm:NewToggle("Auto Farm All Map", "Otomatis teleport & serang NPC terdekat", function(state)
    _G.UniversalFarm = state -- Mengubah status aktif/mati sesuai tombol GUI
end)

-- Tambahkan info kredit komunitas Anda di bagian bawah menu
local KategoriInfo = TabUtama:NewSection("Created by Group Member")
