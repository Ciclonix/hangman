# frozen_string_literal: true

require "yaml"

class Hangman
  attr_accessor :word, :tries, :lives

  def initialize
    @word = getRandomWord
    @tries = {good: [], bad: []}
    @lives = 10
    if File.exist? "save_data.yml"
      print "Do you want to load a save? (y/n) "
      loadData if gets.chomp == "y"
    end
    result = play
    if result == :save
      puts "Saving..."
      saveData
    else
      result ? puts("You win!") : puts("You lose!")
      puts "The word was \"#{word.join}\""
    end
  end

  def play
    loop do
      printWord
      puts "Incorrect guesses: #{tries[:bad].join(", ")}\n\n"
      letter = addLetter
      return :save if letter == "save"

      checkLetter(letter)
      return false if lives.zero?
      return true if checkWin
    end
  end

  def getRandomWord
    dictionary = File.read("dictionary.txt").split("\n")
    loop do
      word = dictionary.sample
      return word.split("") if word.length.between?(5, 12)
    end
  end

  def printWord
    print "Word: "
    word.each do |x|
      tries[:good].include?(x) ? print("#{x} ") : print("_ ")
    end
    puts
  end

  def addLetter
    begin
      print "Try a new letter or save (write \"save\"): "
      letter = gets.chomp.downcase
      raise ArgumentError unless letter.match(/^[a-z]{1}$/) || letter == "save"
    rescue ArgumentError
      puts "Error: Invalid character"
      retry
    end
    return letter
  end

  def checkWin
    return word.all? { |x| tries[:good].include? x }
  end

  def checkLetter(letter)
    if word.include?(letter)
      tries[:good] << letter
      puts "The letter \"#{letter}\" is in the word"
    else
      tries[:bad] << letter
      self.lives -= 1
      puts "The letter \"#{letter}\" is not in the word \nYou have #{lives} lives left"
      return if self.lives.zero?
    end
  end

  def saveData
    save_data = YAML.dump({
                            word: @word,
                            tries: @tries,
                            lives: @lives
                          })
    File.open("save_data.yml", "w") { |file| file.write(save_data) }
  end

  def loadData
    save_data = YAML.load(File.read("save_data.yml"))
    self.word = save_data[:word]
    self.tries = save_data[:tries]
    self.lives = save_data[:lives]
  end
end


Hangman.new
