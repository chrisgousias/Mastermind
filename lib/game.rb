require_relative 'info'

class Game 
  COLORS = ["red", "purple", "blue", "green", "yellow", "orange"]

  attr_accessor :guesses_info, :turn

  def initialize
    @turn = 1
    @secret_code = generate_code
    @guesses_info = []
  end

  def generate_code
    secret_code = Array.new(4) { |color| color = COLORS.sample }
  end

  def evaluate_guess(secret, guess)
    exact_matches = 0
    secret_remaining = []
    guess_remaining = []

    secret.each_with_index do |code, position|
      if guess[position] == code
        exact_matches += 1
      else
        secret_remaining << code
        guess_remaining << guess[position]
      end
    end

    # Creating a hash of the remaining colors of 
    # secret and guess code that shows color=>count
    secret_remaining_tally = secret_remaining.tally
    guess_remaining_tally = guess_remaining.tally

    # Checking if there is a color match 
    # between the guess code and the secret code
    color_matches = 0
    secret_remaining_tally.each do |color, count|
      guess_remaining_count = guess_remaining_tally.fetch(color, 0)
      color_matches += [count, guess_remaining_count].min
    end

    # returning info about exact matches and color matches
    { exact_matches: exact_matches, color_matches: color_matches }
  end

  def guess_code
    loop do
      Info.input_prompt
      input = gets.chomp
      choice = input.downcase.split

      if choice.length != 4 || !choice.all? { |color| COLORS.include?(color) }
        puts "Invalid guess, try again."
        next
      else
        break choice
      end

    end
  end

  def play
    Info.rules
    
    while turn <= 12 do
      user_code = guess_code
      evaluate = evaluate_guess(@secret_code, user_code)

      choice_code = {turn: turn, guess: user_code}
      @guesses_info << choice_code.merge!(evaluate)

      Info.show_board(guesses_info)

      if evaluate[:exact_matches] == 4
        Info.win_message
        break
      end

      self.turn +=1
    end

    if turn == 13
      Info.lose_message
    end
  end
end