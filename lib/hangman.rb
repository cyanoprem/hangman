# rubocop : disable all

class Game
  
  def initialize()
    @secret_word = generate_secret_word
    @dash_string = generate_dash_string
    @guesses_left = 6
    @incorrect_guesses = []
    puts @secret_word
    puts string_with_spaces(@dash_string) 
  end
  
  def generate_secret_word
    file = File.open("google-10000-english-no-swears.txt")
    words_array = file.readlines.map(&:chomp)
    filtered_words = words_array.select { |word| word.length >= 5 && word.length <= 12 }
    secret_word = filtered_words.sample
    secret_word
  end

  def generate_dash_string
    dash_string = String.new('_' * @secret_word.length)
    dash_string
  end

  def play
    loop do 
      if @dash_string == @secret_word
        puts "You won! The word is #{@secret_word}"
        return
      elsif @guesses_left <= 0 
        p @guesses_left
        puts "Oops! Number of guesses are over. The correct answer is #{@secret_word}"
        return
      else
        puts "You have #{@guesses_left} incorrect guesses left"
        puts "Incorrect guesses: #{@incorrect_guesses}" 
        print 'Guess the letter: '
        guessed_letter = gets.chomp
        change_dash_string(guessed_letter)
      end
    end
  end

  def string_with_spaces(string)
    string.gsub(//, ' ')
  end

  def change_dash_string(guessed_letter)
    if @secret_word.include?(guessed_letter)
      @secret_word.each_char.with_index do |char, index| 
        if char == guessed_letter
          @dash_string[index] = guessed_letter
        end
      end
      puts "\nWord: #{string_with_spaces(@dash_string)}"
    else
      puts "\nWord: #{string_with_spaces(@dash_string)}"
      @guesses_left -= 1
      @incorrect_guesses.push(guessed_letter)
    end
  end

end

Game.new().play
