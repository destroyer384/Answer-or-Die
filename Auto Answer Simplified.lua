local Custom_Dictionary = _G.Custom_Dictionary or {} -- Make sure to enter data correctly
local Custom_Answer_Delay = _G.Custom_Answer_Delay or 3
local LPS = _G.LPS or 5  -- Letters per second
local Webhook_URL = _G.Webhook_URL or false

print("Auto answer is ready.")


local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Gui = Players.LocalPlayer.PlayerGui.Main


-- 32/36 are the best answers
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
    ["Name a country that starts with the letter A"] = "Antigua and Barabuda",          -- Best answer
    ["Name something you do in your sleep"] = "Nightmare",                              -- Best answer
    ["Name an animal that can fly"] = "Western Honey Bee",                              -- Best answer
    ["Name a popular electronic device"] = "Play Station Controller",                   -- Best answer
    ["Name a musical instrument"] = "Orchestral Bells",                                 -- Best answer
    ["Name one of the world's hottest countries"] = "Democratic Republic of the Congo", -- Best answer
    ["Name a famous Roblox Youtuber"] = "Inquisitormaster",                             -- 
    ["Name one of the world's most popular car colors"] = "Silver",                     -- 
    ["Name a popular Superhero"] = "Captain America",                                   --
    ["Name one of the seven colors of the rainbow"] = "Purple",                         -- 
}

if next(Custom_Dictionary) ~= nil then
    print("Using custom dictionary.")

    for k, v in pairs(Custom_Dictionary) do
        Answers[k] = v
    end
else
    print("Using full power")
end


local function AnswerTheQuestion(Answer)
    game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer("S_System_SubmitAnswer", {Answer})
end


local function onQuestionUpdate()
    TheQuestion = Gui.Question.Bg.QuestionTxt.Text

    local Answer = Answers[TheQuestion]
    if Answer then
        -- After 6 seconds, qeustion appears on the screen
        wait(6 + CustomAnswerDelay + (string.len(Answer) / LPS))

        AnswerTheQuestion(Answer)
    elseif TheQuestion == "" then
        print("Couldn't get question...")
    else
        print("Cant find the answer to this question:", '"' .. TheQuestion .. '"')
    end
end

AnswerTheQuestion(Gui.Question.Bg.QuestionTxt.Text)

Gui.Question.Bg.QuestionTxt:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
