-- Get the required instances
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local questionTxt = player.PlayerGui.Main.Question.Bg.QuestionTxt

-- Define a dictionary with questions and answers
local questionAnswerDict = {
  ["Name a popular vegetable"] = "Sweet potato",
  ["Name something you eat with"] = "Chopsticks",
  ["Name a popular Superhero"] = "Captain america",
  ["Name any month that has 31 days"] = "December",
  ["Name one of the world's hottest countries"] = "Burkina Faso",
  ["Name a food that starts with the letter P"] = "Passionfruit",
  ["Name a day of the week"] = "Wednesday",
  ["Name something people wear"] = "Underwear",
  ["Name a planet that is part of our solar system"] = "Neptune",
  ["Name a type of weather"] = "Stormy",
  ["Name something you do in your sleep"] = "Nightmare",
  ["Name one of the four seasons"] = "Winter",
  ["Name something you do at school"] = "Physical education",
  ["Name any natural hair color"] = "Brunette",
  ["Name any capital city in Europe"] = "Vaticancity",
  ["Name a country that starts with the letter A"] = "Afghanistan",
  ["Name one of the world's coldest countries"] = "Switzerland",
  ["Name one of the seven colors of the rainbow"] = "Purple",
  ["Name a popular fruit"] = "Passionfruit",
  ["Name a famous Roblox Youtuber"] = "Inquisitormaster",
  ["Name one of the world's most popular car colors"] = "Silver",
  ["Name an animal that walks slowly"] = "Tortoise",
  ["Name any part of the head"] = "Forehead",
  ["Name a popular electronic device"] = "Electricguitar",
  ["Name something you find on pizza"] = "Pepperoni",
  ["Name one of Santa's nine reindeers that show up in Christmas"] = "Rudolph",
  ["Name a topping that is usually in a hamburger"] = "Mayonnaise",
  ["Name a musical instrument"] = "Electricguitar",
  ["Name any popular animal that starts with the letter C"] = "Chameleon",
  ["Name a popular game on Roblox"] = "Flee the facility",
  ["Name a social media app"] = "Instagram",
  ["Name a famous sport that is played in teams"] = "American football",
  ["Name one of the fastest animals"] = "Swordfish",
  ["Name an animal that can fly"] = "Hummingbird",
  ["What is something you eat with your hands"] = "Chicken nuggets",
  ["What is something you can sit on"] = "Gaming chair",
}


-- Define a function to handle property changes
local function onTextChanged()
    local question = questionTxt.Text

    local answer = questionAnswerDict[question]
    if answer then
        wait(8.5)
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
