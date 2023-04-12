local Custom_Dictionary = _G.Custom_Dictionary or {} -- Make sure to enter data correctly f.e. - {["Name something you eat with"] = "Serving spoon",}

local Workspace = game:GetService("Workspace")
local CurrentQuestion = game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.QuestionTxt
local Answer_Delay = 3
local LPS = 8  -- Letters per second
local AutoAnswering = false


-- 33/36 are the best answers
local Answers = {
    ["Name a popular vegetable"] = "Sweet potato",                                      -- Best answer
    ["Name something you eat with"] = "Ice Cream Spoon",                                -- Best answer
    ["Name any month that has 31 days"] = "December",                                   -- Best answer
    ["Name a food that starts with the letter P"] = "Passionfruit",                     -- Best answer
    ["Name a day of the week"] = "Wednesday",                                           -- Best answer
    ["Name something people wear"] = "Contact lense",                                   -- Best answer
    ["Name a planet that is part of our solar system"] = "Neptune",                     -- Best answer
    ["Name a type of weather"] = "Thunderstorm",                                        -- Best answer
    ["Name one of the four seasons"] = "Winter",                                        -- Best answer
    ["Name something you do at school"] = "Physical education",                         -- Best answer
    ["Name any natural hair color"] = "Brunette",                                       -- Best answer
    ["Name any capital city in Europe"] = "Andorra Lavella",                            -- Best answer
    ["Name one of the world's coldest countries"] = "United States of America",         -- Best answer
    ["Name a popular fruit"] = "Passion Fruit",                                         -- Best answer
    ["Name an animal that walks slowly"] = "Caterpillar",                               -- Best answer
    ["Name any part of the head"] = "Forehead",                                         -- Best answer
    ["Name something you find on pizza"] = "Mozzarella Cheese",                         -- Best answer
    ["Name one of Santa's nine reindeers that show up in Christmas"] = "Rudolph",       -- Best answer
    ["Name a topping that is usually in a hamburger"] = "American Cheese",              -- Best answer
    ["Name any popular animal that starts with the letter C"] = "Caterpillar",          -- Best answer
    ["Name a popular game on Roblox"] = "Natural Disaster Survival",                    -- Best answer
    ["Name a social media app"] = "Facebook Messenger",                                 -- Best answer
    ["Name a famous sport that is played in teams"] = "American Football",              -- Best answer
    ["Name one of the fastest animals"] = "Sword fish",                                 -- Best answer
    ["What is something you eat with your hands"] = "Chicken nuggets",                  -- Best answer
    ["What is something you can sit on"] = "Rocking Chair",                             -- Best answer
    ["Name a country that starts with the letter A"] = "Antigua and Barbuda",           -- Best answer
    ["Name something you do in your sleep"] = "Nightmare",                              -- Best answer
    ["Name an animal that can fly"] = "Western Honey Bee",                              -- Best answer
    ["Name a popular electronic device"] = "Play Station Controller",                   -- Best answer
    ["Name a musical instrument"] = "Orchestral Bells",                                 -- Best answer
    ["Name one of the world's hottest countries"] = "Democratic Republic of the Congo", -- Best answer
    ["Name one of the seven colors of the rainbow"] = "Purple",                         -- Best answer
    ["Name one of the world's most popular car colors"] = "Silver",                     -- 
    ["Name a popular Superhero"] = "Captain America",                                   --
    ["Name a famous Roblox Youtuber"] = "Inquisitormaster",                             --
}

if next(Custom_Dictionary) ~= nil then
    print("Using custom dictionary.")

    for k, v in pairs(Custom_Dictionary) do
        Answers[k] = v
    end
else
    print("Using full power")
end


local function AnswerTheQuestion(Question)
    game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer("S_System_SubmitAnswer", {Answers[Question]})
end


-- Using library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Answer or Die",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "Answer or Die",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "AnswerOrDie"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Sirius Hub",
      Subtitle = "Key System",
      Note = "Join the discord (discord.gg/sirius)",
      FileName = "SiriusKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = "Hello"
   }
})

local Tab = Window:CreateTab("Auto Answer", 4483362458)

local Label = Tab:CreateLabel("Answer for current question: " .. Answers[CurrentQuestion.Text])

local Button = Tab:CreateButton({
    Name = "Answer the question",
    Callback = function()
        AnswerTheQuestion(CurrentQuestion.Text)
    end,
})

local Toggle = Tab:CreateToggle({
    Name = "Auto answer",
    CurrentValue = false,
    Flag = "Auto answer",
    Callback = function(Value)
        AutoAnswering = Value
        AnswerTheQuestion(CurrentQuestion.Text)
    end,
})

local LettersPerSecond = Tab:CreateSlider({
    Name = "Letters per second",
    Range = {1, 10},
    Increment = 1,
    Suffix = "Letters",
    CurrentValue = 5,
    Flag = "LPS",
    Callback = function(Value)
        LPS = Value
    end,
})


local DelayAnswer = Tab:CreateSlider({
    Name = "Delay before answering",
    Range = {0, 12},
    Increment = 1,
    Suffix = "Seconds",
    CurrentValue = 3,
    Flag = "DelayAnswer",
    Callback = function(Value)
        Answer_Delay = Value
    end,
})


local CreditsTab = Window:CreateTab("Credits", 4483362458)
local DiscordName = CreditsTab:CreateLabel("Discord: super_destroyer384#2610")


local function onQuestionUpdate()
    if AutoAnswering then
        TheQuestion = CurrentQuestion.Text

        local Answer = Answers[TheQuestion]
        if Answer then
            Label:Set("Answer for current question: " .. Answers[CurrentQuestion.Text])

            -- After 6 seconds, qeustion appears on the screen
            wait(6 + Answer_Delay + (string.len(Answer) / LPS))
            AnswerTheQuestion(TheQuestion)
        else
            print("Cant find the answer to this question:", '"' .. TheQuestion .. '"')
        end
    end
end


CurrentQuestion:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
