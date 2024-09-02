class Hangman
  def getRandomWord
    dictionary = File.read("dictionary.txt").split("\n")
    loop do
      word = dictionary.sample
      return word.split("") if word.length.between?(5,12) 
    end
  end

  def printWord(word, tries)
    word.each do |x|
      tries.include?(x) ? print("#{x} ") : print("_ ")
    end
    puts
  end

  def addLetter
    begin
      print "Try a new letter: "
      letter = gets.chomp.downcase
      raise "Error" unless letter.match /^[a-z]{1}$/ 
    rescue
      puts "Error: Invalid character"
      retry
    end
    return letter
  end
end