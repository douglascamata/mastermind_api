require 'rails_helper'

RSpec.describe Game, type: :model do

  it { should validate_length_of(:code) }
  it { should validate_length_of(:guesses) }
  it { is_expected.to embed_many :guesses }

  it 'should generate random code on create' do
    game = build :game, code: nil
    game.save!
    expect(game.code).not_to be_nil
  end

  it 'should update guesses when player guesses' do
    game = create :game
    player1 = game.players.first
    player2 = game.players.second

    game.guess(player1, %w{R B G Y O P C R})

    expect(game).to have(1).guesses
    expect(game.guesses.first.guess).to eql(%w{R B G Y O P C R})
    expect(game.guesses.first.player).to eql(player1)

    game.guess(player2, %w{R B G Y O P C C})
    expect(game).to have(2).guesses
    expect(game.guesses.second.guess).to eql(%w{R B G Y O P C C})
    expect(game.guesses.second.player).to eql(player2)
  end

  it 'should not allow users to play when game has ended' do
    game = create :game, code: %w{R B G Y O P C M}
    player1 = game.players.first
    player2 = game.players.second

    game.guess(player1, %w{R B G Y O P C M})
    expect(game).to be_ended
    expect(game).to have_winner

    result = game.guess(player2, %w{R B G Y O P C M})
    expect(result).to eql(:ended)
  end
end
