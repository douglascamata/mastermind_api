class Player
  include Mongoid::Document

  field :name, type: String

  validates :name, presence: true

  embedded_in :game
  embedded_in :guess
end
