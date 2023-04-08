print("Loaded")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Gui = LocalPlayer.PlayerGui.Main
local Question = Gui.Question.Bg.QuestionTxt
local Towers = Workspace["__MAP"].Rooms -- 8 towers

-- Define a dictionary with questions and answers
local getAnswer = {
    ["Name a popular vegetable"] = "Sweetpotato",
    ["Name something you eat with"] = "Icecreamspoon",
    ["Name a popular Superhero"] = "Captainamerica",
    ["Name any month that has 31 days"] = "December",
    ["Name one of the world's hottest countries"] = "UnitedArabEmirates",
    ["Name a food that starts with the letter P"] = "Passionfruit",
    ["Name a day of the week"] = "Wednesday",
    ["Name something people wear"] = "Contactlense",
    ["Name a planet that is part of our solar system"] = "Neptune",
    ["Name a type of weather"] = "Thunderstorm",
    ["Name something you do in your sleep"] = "Nightmare",
    ["Name one of the four seasons"] = "Winter",
    ["Name something you do at school"] = "Physicaleducation",
    ["Name any natural hair color"] = "Brunette",
    ["Name any capital city in Europe"] = "Andorralavella",
    ["Name a country that starts with the letter A"] = "Antiguaandbarabuda",
    ["Name one of the world's coldest countries"] = "United StatesofAmerica",
    ["Name one of the seven colors of the rainbow"] = "Purple",
    ["Name a popular fruit"] = "Passionfruit",
    ["Name a famous Roblox Youtuber"] = "Inquisitormaster",
    ["Name one of the world's most popular car colors"] = "Silver",
    ["Name an animal that walks slowly"] = "Caterpillar",
    ["Name any part of your head"] = "Forehead",
    ["Name a popular electronic device"] = "Electricguitar",
    ["Name something you find on pizza"] = "Americancheese",
    ["Name one of Santa's nine reindeers that show up in Christmas"] = "Rudolph",
    ["Name a topping that is usually in a hamburger"] = "Americancheese",
    ["Name a musical instrument"] = "Electricguitar",
    ["Name any popular animal that starts with the letter C"] = "Caterpillar",
    ["Name a popular game on Roblox"] = "NaturalDisasterSurvival",
    ["Name a social media app"] = "Facebookmessenger",
    ["Name a famous sport that is played in teams"] = "Americanfootball",
    ["Name one of the fastest animals"] = "Swordfish",
    ["Name an animal that can fly"] = "Westernhoneybee",
    ["What is something you eat with your hands"] = "Chickennuggets",
    ["What is something you can sit on"] = "Rockingchair",
    ["undefined"] = "lol"
}

local MyBlocks = string.len(getAnswer[Gui.Question.Bg.QuestionTxt.Text])
local MaxLetters = 0
local MaxLettersString = ""
local MaxLettersIndex = 1
local EveryAnswer = {}
local Blocks = 0
local LastQuestion = "undefined"

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
        local _, NewBlocks = announcementText.Text:match("(.+) submitted their answer and gained (%d+) blocks.")
        Blocks = tonumber(NewBlocks) -- Make Blocks match its purpose

        -- If new answer is longer than the previous one and mine, then update the longest answer
        if Blocks > MaxLetters and Blocks > MyBlocks then
            MaxLetters = Blocks
            print("Most blocks:", MaxLetters, "Your blocks:", MyBlocks, '(' .. getAnswer[Gui.Question.Bg.QuestionTxt.Text] .. ')')
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
        print("Question:", LastQuestion)
        print("Got the answer:", string.sub(getOthersAnswers()[MaxLettersIndex], 1, MaxLetters))
    else
        print("omg no")
    end
end

local function onTimerUpdate()
    -- When answers sumbitted and all blocks appeared, find the longest answer
    if Gui.Question.Bg.TimerTxt.Text == "00:01" then
        parseLongest()
        LastQuestion = Gui.Question.Bg.QuestionTxt.Text
    end
end

local function onQuestionUpdate()
    if MyBlocks < MaxLetters then
        getTheAnswer()
    end
    wait(0.25)

    -- Reset data from previous question
    MyBlocks = string.len(getAnswer[Gui.Question.Bg.QuestionTxt.Text])
    Blocks = 0
    MaxLetters = 0
    MaxLettersString = ""
    MaxLettersIndex = 0

    local Answer = getAnswer[Gui.Question.Bg.QuestionTxt.Text]
    if Answer then
        wait( 6 + (string.len(Answer) / 4) )
        game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer("S_System_SubmitAnswer", {Answer})
    end
end

Gui.Question.Bg.QuestionTxt:GetPropertyChangedSignal("Text"):Connect(onQuestionUpdate)
Gui.Question.Bg.TimerTxt:GetPropertyChangedSignal("Text"):Connect(onTimerUpdate)
Gui.BlockGain.ChildAdded:Connect(onBlocksAdded)
