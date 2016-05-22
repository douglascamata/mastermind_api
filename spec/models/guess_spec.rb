require 'rails_helper'

RSpec.describe Guess, type: :model do
  subject { create :guess }

  it { should validate_presence_of :guess }
  it { should validate_presence_of :player }
  it { should validate_presence_of :exact }
  it { should validate_presence_of :near }
  it { should validate_length_of :guess }

  it { is_expected.to be_embedded_in(:game) }

  it 'should evaluate on save' do
    player = build :player
    game = create :game, players: [player], code: %w{R B G Y O P C M}

    guess = build :guess, game: game, player: player, guess: %w{R R B P P C B C}
    guess.save!

    expect(guess.exact).to eql(1)
    expect(guess.near).to eql(3)
  end
end
