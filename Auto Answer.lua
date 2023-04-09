local LetOthersWin = _G.LetOthersWin or false
local Webhook_URL = _G.Webhook_URL or false

print("Auto answer is ready.")
if LetOthersWin then
    print("Letting others win.")
end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Gui = LocalPlayer.PlayerGui.Main
local Question = Gui.Question.Bg.QuestionTxt
local Towers = Workspace["__MAP"].Rooms -- 8 towers


-- Define a dictionary with questions and answers ()
local getAnswer = {
    ["Name a popular vegetable"] = "sweetpotato",                                   -- Best answer
    ["Name something you eat with"] = "icecreamspoon",                              -- Best answer
    ["Name any month that has 31 days"] = "december",                               -- Best answer
    ["Name a food that starts with the letter P"] = "passionfruit",                 -- Best answer
    ["Name a day of the week"] = "wednesday",                                       -- Best answer
    ["Name something people wear"] = "contactlense",                                -- Best answer
    ["Name a planet that is part of our solar system"] = "neptune",                 -- Best answer
    ["Name a type of weather"] = "thunderstorm",                                    -- Best answer
    ["Name one of the four seasons"] = "winter",                                    -- Best answer
    ["Name something you do at school"] = "physicaleducation",                      -- Best answer
    ["Name any natural hair color"] = "brunette",                                   -- Best answer
    ["Name any capital city in Europe"] = "andorralavella",                         -- Best answer
    ["Name one of the world's coldest countries"] = "unitedstatesofamerica",        -- Best answer
    ["Name a popular fruit"] = "passionfruit",                                      -- Best answer
    ["Name an animal that walks slowly"] = "caterpillar",                           -- Best answer
    ["Name any part of the head"] = "forehead",                                     -- Best answer
    ["Name something you find on pizza"] = "mozzarellacheese",                      -- Best answer
    ["Name one of Santa's nine reindeers that show up in Christmas"] = "rudolph",   -- Best answer
    ["Name a topping that is usually in a hamburger"] = "americancheese",           -- Best answer
    ["Name any popular animal that starts with the letter C"] = "caterpillar",      -- Best answer
    ["Name a popular game on Roblox"] = "naturaldisastersurvival",                  -- Best answer
    ["Name a social media app"] = "facebookmessenger",                              -- Best answer
    ["Name a famous sport that is played in teams"] = "americanfootball",           -- Best answer
    ["Name one of the fastest animals"] = "swordfish",                              -- Best answer
    ["What is something you eat with your hands"] = "chickennuggets",               -- Best answer
    ["What is something you can sit on"] = "rockingchair",                          -- Best answer
    ["Name a country that starts with the letter A"] = "antiguaandbarabuda",        -- Best answer
    ["Name something you do in your sleep"] = "nightmare",                          -- Best answer
    ["Name an animal that can fly"] = "westernhoneybee",                            -- Best answer
    ["Name a popular electronic device"] = "playstationcontroller",                 -- Best answer
    ["Name a musical instrument"] = "orchestralbells",                              -- Best answer
    ["Name one of the world's hottest countries"] = "democraticrepublicofthecongo", -- Best answer
    ["Name a famous Roblox Youtuber"] = "inquisitormaster",                         -- 
    ["Name one of the world's most popular car colors"] = "silver",                 -- 
    ["Name a popular Superhero"] = "captainamerica",                                --
    ["Name one of the seven colors of the rainbow"] = "purple",                     -- 
    ["undefined"] = "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll",
}



local MyAnswerLength = 2
local MaxAnswerLength = 1
local MaxAnswerLengthIndex = 1
local EveryAnswer = {}
local LastQuestion = "undefined"
local CurrentQuestion = "undefined"

local function resetData()
    CurrentQuestion = Gui.Question.Bg.QuestionTxt.Text
    MyAnswerLength = string.len(getAnswer[CurrentQuestion])
    MaxAnswerLength = 1
    MaxAnswerLengthIndex = 1
    EveryAnswer = {}
end


local function getOthersAnswers()
    local answers = {}
    -- Go through all 8 towers
    for i = 1, 8 do
        -- Clear every loop
        local letters = ""
        -- Collect text from each block
        for _, v in ipairs(Towers[tostring(i)].Letters:GetChildren()) do
            letters = v.SurfaceGui.Main.LetterTxt.Text .. letters
        end
        -- Assign letters to a tower
        answers[i] = letters
    end
    -- Return dictionary
    return answers
end


local function countDashes(String)
    local _, Count = String:gsub("-", "")
    return Count
end


local function updateMaxLetters(newBlock)
    -- Accept only gains
    if newBlock.Name == "BlockGainTemplate" then
        -- Get name and amount of gained blocks
        local announcementText = newBlock.BlockGainTxt
        local _, LastAnswerBlocks = announcementText.Text:match("(.+) submitted their answer and gained (%d+) blocks.")
        
        -- Dont raise an error if 2x blocks encountered
        pcall(function() 
            LastAnswerBlocks = tonumber(LastAnswerBlocks)
            -- If new answer is longer than the previous one and mine, then update the longest answer
            if LastAnswerBlocks > MaxAnswerLength and LastAnswerBlocks > MyAnswerLength then
                MaxAnswerLength = LastAnswerBlocks
                print("Most blocks:", MaxAnswerLength, "Your blocks:", MyAnswerLength, '(' .. getAnswer[CurrentQuestion] .. ')')
            end
        end)
    end
end


-- Get the index of a string with the longest answer
local function parseLongest()
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


local function getABetterAnswer()
    local LongestAnswer = string.sub(getOthersAnswers()[MaxAnswerLengthIndex], 1, MaxAnswerLength)
    wait(string.len(LongestAnswer) / 2)
    -- Print raw answer
    print("     Question:", LastQuestion)
    print("     Got the answer:", LongestAnswer)
    
    print("")

    -- Send it to discord if it is possible
    if syn and Webhook_URL then
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
                                ["name"] = "Question: " .. LastQuestion,
                                ["value"] = "Old answer: " .. getAnswer[LastQuestion] .. "\nNew: " .. LongestAnswer,
                                ["inline"] = true,
                            }
                        }
                    }
                }
            })
        })        
    end
    
    -- Auto update dictionary (only in current session)
    getAnswer[LastQuestion] = LongestAnswer
end


-- When answers sumbitted and all blocks appeared, find the longest answer
local function onTimerUpdate()
    if Gui.Question.Bg.TimerTxt.Text == "00:01" then
        parseLongest()
        LastQuestion = CurrentQuestion
    end
end


-- If somebody beat me in the previous round, get the answer he entered
-- Reset variables from the prev. round and submit my answer
local function onQuestionUpdate()
    if MyAnswerLength < MaxAnswerLength then
        getABetterAnswer()
    end
    wait(0.25)

    -- Reset data from previous question
    pcall(resetData)
    
    -- Special case to prevent winning
    if LetOthersWin then
        getAnswer["Name something you eat with"] = "servingspoon"
    end
    
    local Answer = getAnswer[CurrentQuestion]
    if Answer then
        wait( 6 + (string.len(Answer) / 4) )
        game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer("S_System_SubmitAnswer", {Answer})
    elseif CurrentQuestion == "" then
        print("Couldn't get question...")
    else
        print("Cant find the answer to this question:", '"' .. CurrentQuestion .. '"')
    end
end

onQuestionUpdate()

Gui.Question.Bg.QuestionTxt:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
Gui.Question.Bg.TimerTxt:GetPropertyChangedSignal("Text"):Connect(onTimerUpdate)
Gui.BlockGain.ChildAdded:Connect(updateMaxLetters)
