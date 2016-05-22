require 'rails_helper'

RSpec.describe 'Game Request', type: :request do

  it 'can create a new game' do
    post '/v1/game/start', player: { name: 'Jon' }

    game = Game.first
    player = game.players.first

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['status_url']).to eql("/v1/game/#{game.id}")
    expect(json['play_url']).to eql("/v1/game/#{game.id}/player/#{player.id}")
  end

  describe 'gameplay' do
    it 'can play the game alone' do
      player = build :player
      game = create :game, players: [player], code: %w{R B G Y O P C M}

      post "/v1/game/#{game.id}/player/#{player.id}", guess: {
        guess: %w{R R B P P C B C}
      }

      expect(response).to be_success
      json = JSON.parse(response.body)

      expect(json['colors']).to eql(Game::COLORS)
      expect(json['total_guesses']).to eql(1)
      expect(json['guess']).to eql(%w{R R B P P C B C})
      expect(json['exact']).to eql(1)
      expect(json['near']).to eql(3)
      expect(json['solved']).to be_falsy
      expect(json['history']).to have(1).guess
      expect(json['history'][0]['guess']).to eql(%w{R R B P P C B C})
      expect(json['history'][0]['player']).to eql(player.name)
      expect(json['history'][0]['exact']).to eql(1)
      expect(json['history'][0]['near']).to eql(3)
    end

    it 'can allow the second player to play on his turn' do
      game = create :game, code: %w{R R B P P C B B}
      player1 = game.players.first
      player2 = game.players.second

      post "/v1/game/#{game.id}/player/#{player1.id}", guess: {
        guess: %w{R R B P P C B C}
      }
      expect(response).to be_success

      post "/v1/game/#{game.id}/player/#{player2.id}", guess: {
        guess: %w{R R B P P C B C}
      }
      expect(response).to be_success
    end
  end

  describe 'join game ' do
    it 'can allow a second player to join' do
      player = build :player
      game = create :game, players: [player], code: %w{R B G Y O P C M}

      post "/v1/game/#{game.id}/join", player: { name: 'Ned' }

      expect(response).to be_success
      json = JSON.parse(response.body)

      game.reload
      player2 = game.players.second
      expect(json['status_url']).to eql("/v1/game/#{game.id}")
      expect(json['play_url']).to eql("/v1/game/#{game.id}/player/#{player2.id}")
    end

    it 'should not allow a third player to join' do
      game = create :game

      post "/v1/game/#{game.id}/join", player: { name: 'Foobar' }

      expect(response).not_to be_success
      json = JSON.parse(response.body)
      expect(json['error']).to eql('the game is already full')
    end

    it 'should render 404 when game does not exist' do
      post "/v1/game/not_found/join", player: { name: 'Foobar' }

      expect(response).not_to be_success
      expect(response.status).to eql(404)
    end
  end

  describe 'game finished' do
    it 'should tell when game is finished because a player guessed' do
      game = create :game, code: %w{R R B P P C B B}
      player1 = game.players.first

      post "/v1/game/#{game.id}/player/#{player1.id}", guess: {
        guess: %w{R R B P P C B B}
      }
      expect(response).to be_success

      json = JSON.parse(response.body)
      expect(json['solved']).to be_truthy
    end
  end

  describe 'game status' do
    it 'should be able to render game status' do
      game = create :game, code: %w{R R B P P C B B}
      player1 = game.players.first
      guess = create :guess, player: player1, game: game, guess: %w{R R B P P C B C}

      get "/v1/game/#{game.id}"

      json = JSON.parse(response.body)
      expect(json['colors']).to eql(Game::COLORS)
      expect(json['total_guesses']).to eql(1)
      expect(json['solved']).to be_falsy
      expect(json['ended']).to be_falsy
      expect(json['guesses']).to have(1).guess
      expect(json['guesses'][0]['guess']).to eql(guess.guess)
      expect(json['guesses'][0]['player']).to eql(guess.player.name)
    end

    it 'should reply with 404 if game does not exist' do
      get "/v1/game/not_found"

      expect(response).not_to be_success
      expect(response.status).to eql(404)
    end

    it 'should tell the winning user if game is finished' do
      game = create :game, code: %w{R R B P P C B B}
      player1 = game.players.first
      game.guess(player1, %w{R R B P P C B B})
      guess = game.guesses.first

      get "/v1/game/#{game.id}"

      json = JSON.parse(response.body)
      expect(json['solved']).to be_truthy
      expect(json['guesses']).to have(1).guess
      expect(json['guesses'][0]['guess']).to eql(guess.guess)
      expect(json['guesses'][0]['player']).to eql(guess.player.name)
      expect(json['solver']).to eql(guess.player.name)
    end
  end
end
