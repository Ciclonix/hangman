class Hangman
  attr_accessor :word, :tries, :lives

  def initialize
    @word = getRandomWord
    @tries = {good: [], bad: []}
    @lives = 10
    play ? puts("You win!") : puts("You lose!")
  end

  def play
    printWord
    loop do
      new_letter = addLetter
      checkLetter
      return false if lives == 0
      printWord
      return true if checkWin
    end
  end

  def getRandomWord
    dictionary = File.read("dictionary.txt").split("\n")
    loop do
      word = dictionary.sample
      return word.split("") if word.length.between?(5,12) 
    end
  end

  def printWord
    print "Word: "
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

  def checkWin
    return word.all? { |x| tries[:good].include? x }
  end

  def checkLetter
    if word.include?(new_letter)
      tries[:good] << new_letter
      puts "The letter #{new_letter} is in the word"
    else
      tries[:bad] << new_letter
      lives -= 1
      return if lives == 0

      puts "The letter #{new_letter} is not in the word"
      puts "You have #{lives} lives left"
    end
    puts "Incorrect guesses: #{tries[:bad].inspect}"
  end
end


Hangman.new