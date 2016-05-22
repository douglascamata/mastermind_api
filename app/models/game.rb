class Game
  include Mongoid::Document

  COLORS = %w{R B G Y O P C M}

  field :code, type: Array
  field :ended, type: Boolean, default: false
  field :winner_id, type: String

  embeds_many :players
  embeds_many :guesses

  validates :players, length: {minimum: 1, maximum: 2}

  validates :code, presence: true, length: {is: COLORS.size}, array: {
    inclusion: {
      in: COLORS
    }
  }

  before_validation :generate_code, if: -> (game) { game.code.nil? }

  def ended?
    self.ended
  end

  def has_winner?
    self.winner_id.present?
  end

  def generate_code
    self.code = []
    COLORS.size.times do
      self.code << COLORS.sample
    end
  end

  def guess(player, guess)
    return :ended if self.ended

    if guess == code
      self.winner_id = player.id
      matched = true
    else
      matched = false
    end
    guess = update_guesses(player, guess)
    update_ended
    self.save!

    return { matched: matched }.merge(guess.evaluation)
  end

  def update_guesses(player, guess)
    self.guesses.build(
      guess: guess,
      player: player
    )
  end

  def update_ended
    self.ended = true if self.winner_id
  end
end
