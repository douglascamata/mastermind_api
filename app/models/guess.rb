class Guess
  include Mongoid::Document

  field :guess, type: Array
  field :exact, type: Integer
  field :near, type: Integer

  embeds_one :player

  embedded_in :game

  validates :player, presence: true

  validates :near, presence: true
  validates :exact, presence: true

  validates :guess, presence: true, length: {is: 8}, array: {
    inclusion: {
      in: Game::COLORS
    }
  }

  before_validation :evaluate, if: -> { exact.nil? && near.nil? }

  def evaluation
    {exact: self.exact, near: self.near}
  end

  def self.evaluate(hidden_code, guess)
    exact = []
    near = []
    guess.each_with_index do |color, index|
      if guess[index] == hidden_code[index]
        exact << color
        next
      elsif hidden_code.include? guess[index]
        near << color if near.count(color) + exact.count(color) + 1 == hidden_code.count(color)
      end
    end
    {exact: exact.count, near: near.count}
  end

  def evaluate
    result = Guess.evaluate(self.game.code, self.guess)
    self.exact = result[:exact]
    self.near = result[:near]
  end
end
