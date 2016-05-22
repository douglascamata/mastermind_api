class Guess

  def initialize(code)
    @code = code
    raise 'code cannot be string' if @code.is_a? String
    @evaluation = nil
  end

  def evaluate(hidden_code)
    exact = []
    near = []
    @code.each_with_index do |color, index|
      if @code[index] == hidden_code[index]
        exact << color
        next
      elsif hidden_code.include? @code[index]
        near << color if near.count(color) + exact.count(color) + 1 == hidden_code.count(color)
      end
    end
    @evaluation = {exact: exact.count, near: near.count}
    @evaluation
  end
end

class MastermindSolver

  attr_reader :combinations

  def initialize(colors='RBGYOPCM', size=8, combinations=nil, history=[])
    @colors = colors.split('')
    @size = size
    @combinations = []
    # size of combinations: 16.777.216
    @generator = @colors.shuffle.repeated_permutation(@size)
    @history = []
    @generation_steps = 20
    @generation_finished = false
  end

  def add_to_history(guess, score=nil)
    @history << guess
    generate_combinations(guess, score) if @history.size == 1
  end

  def best_guess
    return first_guess if @history.empty?
    random = random_guess_from_pool
    return random.join('') if random
    @colors.shuffle
  end

  def first_guess
    guess = []
    @colors.size.times do
      guess << @colors.sample
    end
    guess.join('')
  end

  def filter_guesses_for!(guess, score)
    @combinations.reject! do |p|
      p_score = Guess.new(p).evaluate(guess)
      p_score[:exact] == score[:exact] && p_score[:near] == score[:near]
    end
    generate_combinations(guess, score)
  end

  def generate_combinations(base_guess, score)
    max_first_result = @generator.size / @generation_steps
    puts "Checking #{max_first_result} items."
    (max_first_result).times do
      @generator.next
      item = @generator.peek
      g_score = Guess.new(item).evaluate(base_guess.split(''))
      # p "#{item} score against #{base_guess}: #{g_score}"
      # print '.'
      if g_score[:exact] == score[:exact] && g_score[:near] == score[:near]
        # print 'O'
        @combinations << item
      end
    end
  end

  def random_guess_from_pool
    @combinations.sample
  end
end
