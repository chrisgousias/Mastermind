require_relative 'info'

class Game 
  COLORS = ["cyan", "magenta", "blue", "green", "yellow", "grey"]

  attr_accessor :guesses_info, :turn

  def initialize
    @turn = 1
    @secret_code 
    @guesses_info = []
  end

  def generate_code(role)
  	if role == "codebreaker"
    	@secret_code = Array.new(4) { |color| color = COLORS.sample }
    else
    	user_code
    end
  end

  def evaluate_code(secret, guess)
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

  def user_code
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

  # each turn the user take a guess code, evaluates this code with 
  # the secret code and then the board is shown with the info resources
  def user_play(role)

  	while turn <= 12 do
      guess_code = user_code
      evaluate = evaluate_code(@secret_code, guess_code)

      choice_code = {guess: guess_code}
      @guesses_info << choice_code.merge!(evaluate)

      Info.show_board(guesses_info, turn, role)

      if evaluate[:exact_matches] == 4
        Info.win_message
        break
      end

      self.turn +=1
    end	

  end

  def computer_color_arrangement(role)
    index = 0
    secret_colors = []

    until secret_colors.length == 4 do

      computer_code = Array.new(4, COLORS[index])

      evaluate = evaluate_code(@secret_code, computer_code) #a hash of exact_matches and color_matches
      guesses_info << {guess: computer_code}.merge!(evaluate)

      Info.show_board(guesses_info, turn, role)

      if (evaluate[:exact_matches]) > 0
        secret_colors << Array.new(evaluate[:exact_matches], COLORS[index])
        secret_colors.flatten!
      end

      index += 1

      if turn == 5 && secret_colors.length < 4
        secret_colors << Array.new(4-secret_colors.length, COLORS[index])
        break secret_colors.flatten!
      end

      self.turn += 1
    end

    secret_colors

  end

  def computer_color_position(role)
    known_colors = computer_color_arrangement(role)
    arrangements = known_colors.permutation.to_a.uniq

    arrangements.each do |arrangement|
      evaluate = evaluate_code(@secret_code, arrangement)
      guesses_info << {guess: arrangement}.merge!(evaluate)

      break "You win!! Computer loses!" if turn == 13
      break 'Computer wins. You lose.' if evaluate[:exact_matches] == 4
      
      self.turn += 1
      Info.show_board(guesses_info, turn, role)
    end

  end

  def play
    Info.rules
    
    role = ""
    until role == "codemaker" || role == "codebreaker" do
    	puts "Enter what role you want to play (type codemaker or codebreaker):"
    	role = gets.chomp.downcase
    end
    @secret_code = generate_code(role)

    if role == "codebreaker"
    	user_play(role)
    else
      p computer_color_position(role)
    end

  end
end