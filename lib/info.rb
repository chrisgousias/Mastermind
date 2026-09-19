module Info 
  def self.show_board(guesses_info)
    guesses_info.each do |element|
      puts "Turn: #{element[:turn]}/12: Your guess #{element[:guess]} - Exact matches: #{element[:exact_matches]}, Color matches: #{element[:color_matches]}"
      puts "Available colors: 'RED', 'PURPLE', 'BLUE', 'GREEN', 'YELLOW', 'ORANGE'"
    end
  end

  def self.rules
    puts "---------- MASTERMIND GAME ----------"
    puts "This game consists of a codemaker and a codebreaker.
The codemaker is the computer and that means that
you must find the secret code that will be randomly
generated from the available 6 colors. The colors are:
'RED', 'PURPLE', 'BLUE', 'GREEN', 'YELLOW' and 'ORANGE'
The game consists of 12 turns and after each turn there will
be information about the code you selected in the form of:
'Turn ?/12: Your guess [your code] - Exact matches: ?, Color matches: ?'
The exact matches means that you found both the correct color
and in the correct position, while the color matches means that
you found the correct color but in the wrong position. "
  end

  def self.input_prompt
    puts "Enter you guess as 4 separated by spaces:"
  end

  def self.win_message
    puts 'Congratulations, you are a winner baby!'
  end

  def self.lose_message
    puts "I'm sorry my dear.. Sashay AWAY."
  end

end