-- Get the required instances
local Workspace = game:GetService("Workspace")
local Towers = Workspace["__MAP"].Rooms
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local questionTxt = player.PlayerGui.Main.Question.Bg.QuestionTxt


local myGainedBlocks = 0
local otherPlayerBlocks = 0
local prevAnswer = ""

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
  ["Name one of the world's coldest countries"] = "Switzerland",
  ["Name one of the seven colors of the rainbow"] = "Purple",
  ["Name a popular fruit"] = "Passionfruit",
  ["Name a famous Roblox Youtuber"] = "Inquisitormaster",
  ["Name one of the world's most popular car colors"] = "Silver",
  ["Name an animal that walks slowly"] = "Caterpillar",
  ["Name any part of the head"] = "Forehead",
  ["Name a popular electronic device"] = "Electricguitar",
  ["Name something you find on pizza"] = "Pepperoni",
  ["Name one of Santa's nine reindeers that show up in Christmas"] = "Rudolph",
  ["Name a topping that is usually in a hamburger"] = "Mayonnaise",
  ["Name a musical instrument"] = "Electric guitar",
  ["Name any popular animal that starts with the letter C"] = "Caterpillar",
  ["Name a popular game on Roblox"] = "Bee Swarm Simulator",
  ["Name a social media app"] = "Facebook messenger",
  ["Name a famous sport that is played in teams"] = "American football",
  ["Name one of the fastest animals"] = "Swordfish",
  ["Name an animal that can fly"] = "Hummingbird",
  ["What is something you eat with your hands"] = "Chicken nuggets",
  ["What is something you can sit on"] = "Rocking chair",
}


-- Define a function to handle property changes
local function onTextChanged()
    myGainedBlocks = 0
    otherPlayerBlocks = 0
    
    local question = questionTxt.Text
    local answer = getAnswer[question]
    if answer then
        wait( 5 + (string.len(answer) / 5) )
        local args = {
            [1] = "S_System_SubmitAnswer",
            [2] = {
                [1] = answer
            }
        }
        game:GetService("ReplicatedStorage").Common.Library.Network.RemoteFunction:InvokeServer(unpack(args))
    end
end

-- Show all letters in everyone's tower 
local function getLetters()
    local function collectTextFromParts(folder)
        local concatenatedText = ""
        for _, part in ipairs(folder:GetChildren()) do
            if part.Name:match("^%d+$") and part:FindFirstChild("SurfaceGui") and part.SurfaceGui:FindFirstChild("Main") and part.SurfaceGui.Main:FindFirstChild("LetterTxt") then
                concatenatedText = concatenatedText .. part.SurfaceGui.Main.LetterTxt.Text
            end
        end
        return concatenatedText
    end

    local function reverseString(letters)
        local reversed = ""
        for i = letters:len(), 1, -1 do
            reversed = reversed .. letters:sub(i, i)
        end
        return reversed
    end

    for i = 1, 8 do
        local folder = Towers[tostring(i)].Letters
        if collectTextFromParts(folder).len ~= 0 then
            print(reverseString(collectTextFromParts(folder)))
        end
    end
end

-- Define a function to notify when someone has a better answer
local function onBlockGainTemplateAdded(newBlockGainTemplate)
    if newBlockGainTemplate.Name == "BlockGainTemplate" then
        local blockGainTxt = newBlockGainTemplate.BlockGainTxt
        local playerName, gainedBlocks = blockGainTxt.Text:match("(.+) submitted their answer and gained (%d+) blocks.")

        if playerName and gainedBlocks then
            local otherPlayer = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p.DisplayName == playerName then
                    otherPlayer = p
                    break
                end
            end

            if otherPlayer == player then
                myGainedBlocks = tonumber(gainedBlocks)
            elseif otherPlayer ~= nil then
                otherPlayerBlocks = tonumber(gainedBlocks)

                if myGainedBlocks > otherPlayerBlocks and myGainedBlocks ~= 0 then
                    prevAnswer == getAnswer[question]

                    print("Enemy player name:", otherPlayer)
                    print("Blocks gained:", getAnswer[questionTxt.Text], myGainedBlocks, "-", otherPlayerBlocks)
                    print("Question:", questionTxt.Text)
                    print("Possible answers:")
                    getLetters()
                end
            else
                print("Player not found:", playerName)
            end
        end
    end
end

questionTxt:GetPropertyChangedSignal("Text"):Connect(onTextChanged)
game:GetService("Players").LocalPlayer.PlayerGui.Main.BlockGain.ChildAdded:Connect(onBlockGainTemplateAdded)
