require 'colorize'

module Info 

  def self.rules
    puts <<~RULES
      ----------------- MASTERMIND GAME ------------------
      This game consists of a codemaker and a codebreaker. 
      First you choose the role you want to play. The code
      is a 4 colored-peg which can consist of the next 6 colors:
      'CYAN', 'MAGENTA', 'BLUE', 'GREEN', 'YELLOW', 'GREY'.
      There will be 12 turns and each turn there will be 
      information about the code. Red pegs show that there is
      a correct color peg and in the correct position while white
      pegs show that there is a correct color but in the wrong 
      position.
    RULES
  end

  def self.show_board(guesses_info, turn, role)
    if role == "codemaker"
      puts "Turn #{turn}/12"
    end
    guesses_info.each do |element|
      guess_pegs = element[:guess].map { |color| "\u25CF".colorize(color.to_sym)}
      exact_matches = Array.new(element[:exact_matches]) { "\u25CF".colorize(:light_red) }
      color_matches = Array.new(element[:color_matches]) { "\u25CF".colorize(:light_white) }
      puts (guess_pegs + [" | "] + exact_matches + color_matches).join(" ")
    end
  end

  def self.input_prompt
    puts "Enter your code as 4 separated by spaces:"
  end

  def self.win_message
    puts 'Congratulations, you are a winner baby!'
  end

  def self.lose_message
    puts "I'm sorry my dear.. Sashay AWAY."
  end

end