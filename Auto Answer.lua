local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Gui = LocalPlayer.PlayerGui.Main
local Question = Gui.Question.Bg.QuestionTxt
local Towers = Workspace["__MAP"].Rooms -- 8 towers

local MyBlocks = 0
local MaxLetters = 0
local MaxLettersString = ""
local MaxLettersIndex = 1
local EveryAnswer = {}
local Blocks = 0

-- Define a dictionary with questions and answers
local getAnswer = {
    ["Name a popular vegetable"] = "Sweet potato",
    ["Name something you eat with"] = "Serving spoon",
    ["Name a popular Superhero"] = "Captain america",
    ["Name any month that has 31 days"] = "December",
    ["Name one of the world's hottest countries"] = "United Arab Emirates",
    ["Name a food that starts with the letter P"] = "Passionfruit",
    ["Name a day of the week"] = "Wednesday",
    ["Name something people wear"] = "Contact lense",
    ["Name a planet that is part of our solar system"] = "Neptune",
    ["Name a type of weather"] = "Thunderstorm",
    ["Name something you do in your sleep"] = "Nightmare",
    ["Name one of the four seasons"] = "Winter",
    ["Name something you do at school"] = "Physical education",
    ["Name any natural hair color"] = "Brunette",
    ["Name any capital city in Europe"] = "Vaticancity",
    ["Name a country that starts with the letter A"] = "Antigua and barabuda",
    ["Name one of the world's coldest countries"] = "United States of America",
    ["Name one of the seven colors of the rainbow"] = "Purple",
    ["Name a popular fruit"] = "Passionfruit",
    ["Name a famous Roblox Youtuber"] = "Inquisitormaster",
    ["Name one of the world's most popular car colors"] = "Silver",
    ["Name an animal that walks slowly"] = "Caterpillar",
    ["Name any part of the head"] = "Forehead",
    ["Name a popular electronic device"] = "Electricguitar",
    ["Name something you find on pizza"] = "Mozzarella",
    ["Name one of Santa's nine reindeers that show up in Christmas"] = "Rudolph",
    ["Name a topping that is usually in a hamburger"] = "Mayonnaise",
    ["Name a musical instrument"] = "Electric guitar",
    ["Name any popular animal that starts with the letter C"] = "Caterpillar",
    ["Name a popular game on Roblox"] = "Natural Disaster Survival",
    ["Name a social media app"] = "Facebook messenger",
    ["Name a famous sport that is played in teams"] = "American football",
    ["Name one of the fastest animals"] = "Swordfish",
    ["Name an animal that can fly"] = "Hummingbird",
    ["What is something you eat with your hands"] = "Chicken nuggets",
    ["What is something you can sit on"] = "Rocking chair",
}

local function getOthersAnswers()
    local answers = {}
    -- Go through all 8 towers
    for i = 1, 8 do
        -- Clear text every loop
        local text = ""
        -- Collect text from each block
        for _, v in ipairs(Towers[tostring(i)].Letters:GetChildren()) do
            text = v.SurfaceGui.Main.LetterTxt.Text .. text
        end
        -- Assign text to index
        answers[i] = text
    end
    -- Return dictionary
    return answers
end

-- count amount of specific chars in a string
local function countDashes(String)
    local Count = 0
    for i = 1, #String do
        if String:sub(i,i) == "-" then
            Count = Count + 1
        end
    end
    return Count
end

local function onBlocksAdded(newBlock)
    -- Accept only gains
    if newBlock.Name == "BlockGainTemplate" then
        -- Get name and amount of gained blocks
        local announcementText = newBlock.BlockGainTxt
        local Player, NewBlocks = announcementText.Text:match("(.+) submitted their answer and gained (%d+) blocks.")
        Blocks = tonumber(NewBlocks) -- Make Blocks match its purpose

        -- Get rid of dislay names
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == Player then
                Player = p
                break
            end
        end

        -- If new answer is longer than the previous one and mine, then update the longest answer
        if Blocks > MaxLetters and Blocks > MyBlocks then
            MaxLetters = Blocks
            print("Most blocks:", MaxLetters, "Your blocks:", MyBlocks)
        end
    end
end

local function parseLongest()
    -- Get the letters
    EveryAnswer = getOthersAnswers()
    -- Loop and check for longest answer's index
    for i = 1, #EveryAnswer do
        -- When longest found
        if countDashes(EveryAnswer[i]) == MaxLetters then
            -- Set the answers
            MaxLettersString = EveryAnswer[i]
            MaxLettersIndex = i
            break
         end
    end
end

local function getTheAnswer()
    -- Print raw answer
    if MaxLettersString and MaxLetters then
        print("Question:", game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.QuestionTxt.Text)
        print("Got the answer:", string.sub(getOthersAnswers()[MaxLettersIndex], 1, MaxLetters))
    else
        print("omg no")
    end
end

local function onTimerUpdate()
    -- When answers sumbitted and all blocks appeared, find the longest answer
    if Gui.Question.Bg.TimerTxt.Text == "00:01" then
        parseLongest()
    end
end

local function onQuestionUpdate()
    
    if MyBlocks < MaxLetters then
        getTheAnswer()
    end
    wait(0.25)

    -- Reset data from previous question
    MyBlocks = string.len(getAnswer[game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.QuestionTxt.Text])
    TheirBlocks = 0
    MaxLetters = 0
    MaxLettersString = ""
    MaxLettersIndex = 0

    local Answer = getAnswer[game:GetService("Players").LocalPlayer.PlayerGui.Main.Question.Bg.QuestionTxt.Text]
    if Answer then
        wait( 6 + (string.len(answer) / 4) )
        game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer("S_System_SubmitAnswer", {Answer})
    end
end

Gui.Question.Bg.QuestionTxt:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
Gui.Question.Bg.TimerTxt:GetPropertyChangedSignal("Text"):Connect(onTimerUpdate)
Gui.BlockGain.ChildAdded:Connect(onBlocksAdded)
