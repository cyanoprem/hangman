# rubocop : disable all

require 'yaml'

class Game
  attr_accessor :game_name, :secret_word, :dash_string, :guesses_left, :incorrect_guesses
  
  def initialize(game_name)
    @game_name = game_name
    filename = "saved_games/#{game_name}.yaml"
    if File.exists?(filename) == false
      @secret_word = generate_secret_word
      @dash_string = generate_dash_string
      @guesses_left = 6
      @incorrect_guesses = []
    else
      @secret_word = saved_secret_word(filename)
      @dash_string = saved_dash_string(filename)
      @guesses_left = saved_guesses_left(filename)
      @incorrect_guesses = saved_incorrect_guesses(filename)
    end    
    # p @game_name
    # p @secret_word
    puts string_with_spaces(@dash_string) 
  end

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')

    filename = "saved_games/#{@game_name}.yaml"

    File.open(filename, 'w') do |file|
      file.puts YAML.dump ({
        :game_name => @game_name,
        :secret_word => @secret_word,
        :dash_string => @dash_string,
        :guesses_left => @guesses_left,
        :incorrect_guesses => @incorrect_guesses
    })
    end
  end

  def self.get_saved_game(file)
    data = YAML.load_file(file)
    self.new(data[:game_name])
  end

  def saved_secret_word(file)
    data = YAML.load_file(file)
    data[:secret_word]
  end

  def saved_dash_string(file)
    data = YAML.load_file(file)
    data[:dash_string]
  end

  def saved_guesses_left(file)
    data = YAML.load_file(file)
    data[:guesses_left]
  end

  def saved_incorrect_guesses(file)
    data = YAML.load_file(file)
    data[:incorrect_guesses]
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
        save_or_play
        if $save_or_play == 2
          return
        end
      end
    end
  end

  def save_or_play
    puts "You have #{@guesses_left} incorrect guesses left"
    puts "Incorrect guesses: #{@incorrect_guesses}" 
    print 'Enter 1 to Guess the letter or Enter 2 to Save the Game: '
    $save_or_play = gets.chomp.to_i
    if $save_or_play == 2
      save_game
    elsif $save_or_play == 1
      print 'Guess the letter: '
      guessed_letter = gets.chomp.downcase
      change_dash_string(guessed_letter)
    else
      puts 'Invalid Input!!!'
      save_or_play
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

print "Give a name to your Game or enter the name of your Saved Game: "
game_name = gets.chomp

if File.exists?("saved_games/#{game_name}.yaml")
  game = Game.get_saved_game("saved_games/#{game_name}.yaml")
else
  game = Game.new(game_name)
end

game.play()


