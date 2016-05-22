# This will guess the User class
FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player#{n}" }
    game
  end

  factory :guess do
    player
    game { |guess| create :game, players: [guess.player] }
    guess %w{R B G Y O P C C}
  end

  factory :game do
    code %w{R B G Y O P C M}
    players { |game| create_list(:player, 2, game: game) }
  end
end
