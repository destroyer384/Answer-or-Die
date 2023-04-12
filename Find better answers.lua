local Webhook_URL = _G.Webhook_URL or false

local Workspace = game:GetService("Workspace")
local BgQuestion = game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.QuestionTxt
local BgTimer = game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.TimerTxt
local BlockGain = game:GetService("Players").LocalPlayer.PlayerGui.Main.BlockGain
local Towers = Workspace["__MAP"].Rooms -- 8 towers


-- 33/36 are the best answers
local getAnswer = {
    ["Name a popular vegetable"] = 11,                                      -- Best answer
    ["Name something you eat with"] = 13,                                   -- Best answer
    ["Name any month that has 31 days"] = 8,                                -- Best answer
    ["Name a food that starts with the letter P"] = 12,                     -- Best answer
    ["Name a day of the week"] = 9,                                         -- Best answer
    ["Name something people wear"] = 12,                                    -- Best answer
    ["Name a planet that is part of our solar system"] = 7,                 -- Best answer
    ["Name a type of weather"] = 12,                                        -- Best answer
    ["Name one of the four seasons"] = 6,                                   -- Best answer
    ["Name something you do at school"] = 17,                               -- Best answer
    ["Name any natural hair color"] = 8,                                    -- Best answer
    ["Name any capital city in Europe"] = 14,                               -- Best answer
    ["Name one of the world's coldest countries"] = 21,                     -- Best answer
    ["Name a popular fruit"] = 12,                                          -- Best answer
    ["Name an animal that walks slowly"] = 11,                              -- Best answer
    ["Name any part of the head"] = 8,                                      -- Best answer
    ["Name something you find on pizza"] = 16,                              -- Best answer
    ["Name one of Santa's nine reindeers that show up in Christmas"] = 7,   -- Best answer
    ["Name a topping that is usually in a hamburger"] = 14,                 -- Best answer
    ["Name any popular animal that starts with the letter C"] = 11,         -- Best answer
    ["Name a popular game on Roblox"] = 23,                                 -- Best answer
    ["Name a social media app"] = 17,                                       -- Best answer
    ["Name a famous sport that is played in teams"] = 16,                   -- Best answer
    ["Name one of the fastest animals"] = 9,                                -- Best answer
    ["What is something you eat with your hands"] = 14,                     -- Best answer
    ["What is something you can sit on"] = 12,                              -- Best answer
    ["Name a country that starts with the letter A"] = 18,                  -- Best answer
    ["Name something you do in your sleep"] = 9,                            -- Best answer
    ["Name an animal that can fly"] = 15,                                   -- Best answer
    ["Name a popular electronic device"] = 21,                              -- Best answer
    ["Name a musical instrument"] = 15,                                     -- Best answer
    ["Name one of the world's hottest countries"] = 28,                     -- Best answer
    ["Name one of the seven colors of the rainbow"] = 6,                    -- Best answer
    ["Name a famous Roblox Youtuber"] = 16,                                 -- 
    ["Name one of the world's most popular car colors"] = 6,                -- 
    ["Name a popular Superhero"] = 14,                                      --
    ["undefined"] = 100,
}


local MyAnswerLength = 0
local MaxAnswerLength = 0
local MaxAnswerLengthIndex = 1
local EveryAnswer = {}
local LastQuestion = "undefined"
local CurrentQuestion = "undefined"

local function resetData()
    CurrentQuestion = CurrentQuestion.Text
    MyAnswerLength = getAnswer[CurrentQuestion]
    MaxAnswerLength = 0
    MaxAnswerLengthIndex = 1
    EveryAnswer = {}
end


local function getOthersAnswers()
    local answers = {}
    for i = 1, 8 do
        local letters = ""
        -- Collect letters from each block
        for _, v in ipairs(Towers[tostring(i)].Letters:GetChildren()) do
            letters = v.SurfaceGui.Main.LetterTxt.Text .. letters
        end
        -- Save text to the table
        answers[i] = letters
    end

    return answers
end


local function countDashes(String)
    local _, Count = String:gsub("-", "")
    return Count
end


local function updateMaxLetters(newBlock)
    if newBlock.Name == "BlockGainTemplate" then
        -- Get name and amount of gained blocks
        local announcementText = newBlock.BlockGainTxt
        local _, LastAnswerBlocks = announcementText.Text:match("(.+) submitted their answer and gained (%d+) blocks.")
        
        -- Dont raise an error if 2x blocks encountered
        pcall(function() 
            LastAnswerBlocks = tonumber(LastAnswerBlocks)

            if LastAnswerBlocks > MaxAnswerLength and LastAnswerBlocks > MyAnswerLength then
                MaxAnswerLength = LastAnswerBlocks
            end
        end)
    end
end


local function getLongestsAnswerString()
    EveryAnswer = getOthersAnswers()
    -- Loop and check for longest answer's index
    for i = 1, #EveryAnswer do
        if countDashes(EveryAnswer[i]) == MaxAnswerLength then
            -- Get the index
            MaxAnswerLengthIndex = i
            break
         end
    end
end


local function sendWebhook(LQ, LA)
    local HttpService = game:GetService("HttpService")

        local responce = syn.request({
            Url = Webhook_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["title"] = "A better answer has been found.",
                        ["description"] = "",
                        ["type"] = "rich",
                        ["color"] = tonumber(0x03fc45),
                        ["fields"] = {
                            {
                                ["name"] = "Question: " .. LQ ,
                                ["value"] = "Old answer length: " .. getAnswer[LQ] .. "(" .. string.len(getAnswer[LQ]) .. ")" .. "\nNew: " .. LA .. "(" .. string.len(LA) .. ")",
                                ["inline"] = true,
                            }
                        },
                        ["footer"] = {
                            ["text"] = "Answer or die"
                        },
                    }
                }
            })
        }) 
end

local function getABetterAnswer()
    local LongestAnswer = string.sub(getOthersAnswers()[MaxAnswerLengthIndex], 1, MaxAnswerLength)
    if LongestAnswer == "" then
        LongestAnswer = "Game reset before :("
    end

    if syn and Webhook_URL then
        sendWebhook(LastQuestion, LongestAnswer)
    end
    
    -- Print raw answer
    print("     Question:", LastQuestion)
    print("     Got the answer:", LongestAnswer)
    
    print("")
end


-- When answers sumbitted and all blocks appeared, find the longest answer
local function onTimerUpdate()
    if BgTimer.Text == "00:00" then
        wait(2)
        getLongestsAnswerString()
        LastQuestion = BgQuestion.Text
    end
end


local function onQuestionUpdate()
    -- Decide should or not give others answers
    if MyAnswerLength < MaxAnswerLength then
        getABetterAnswer()
    end

    wait(2)

    resetData()

    CurrentQuestion = BgQuestion.Text
end

resetData()

BgQuestion:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
BgTimer:GetPropertyChangedSignal("Text"):Connect(onTimerUpdate)
BlockGain.ChildAdded:Connect(updateMaxLetters)
