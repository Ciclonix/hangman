def getRandomWord
  dictionary = File.read("dictionary.txt").split("\n")
  loop do
    word = dictionary.sample
    return word.split("") if word.length.between?(5,12) 
  end
end