# frozen_string_literal: true

class Hangman
  attr_accessor :word, :tries, :lives

  def initialize
    @word = getRandomWord
    @tries = {good: [], bad: []}
    @lives = 10
    play ? puts("You win!") : puts("You lose!")
    puts "The word was \"#{word.join}\""
  end

  def play
    printWord
    loop do
      checkLetter(addLetter)
      puts "Incorrect guesses: #{tries[:bad].join(", ")}\n\n"
      return false if lives.zero?
      return true if checkWin

      printWord
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
      print "Try a new letter: "
      letter = gets.chomp.downcase
      raise ArgumentError unless letter.match(/^[a-z]{1}$/)
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
end


Hangman.new
