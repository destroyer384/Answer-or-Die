-- Get the required instances
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local questionTxt = player.PlayerGui.Main.Question.Bg.QuestionTxt


-- Define a function to handle property changes
local function onTextChanged()
    local question = questionTxt.Text
  
    loadstring(game:HttpGet("https://raw.githubusercontent.com/destroyer384/Answer-or-Die/main/Dictionary.lua", true))

    local answer = getAnswer[question]
    if answer then
        wait(9)
        local args = {
            [1] = "S_System_SubmitAnswer",
            [2] = {
                [1] = answer
            }
        }
        game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer(unpack(args))
    else
        print(question)
    end
end

-- Connect the function to the Text property change signal
questionTxt:GetPropertyChangedSignal("Text"):Connect(onTextChanged)
