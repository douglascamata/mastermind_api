class Telegram::LocalWebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Telegram::Bot::UpdatesController::Session

  def startgame(*)
    if session[:game_id]
      game = Game.where(id: session[:game_id]).first
      game.destroy if game
    end

    player = Player.new name: from['username']
    game = Game.create players: [player]
    session[:game_id] = game.id

    message =
"""
Mastermind session started! Have a good game, #{player.name}.
The game has 8 colors (RBGYOPCM) and 8 positions to guess.
To guess the code send /guess <combination of the colors>.
For example: /guess RBGYOPCM.

You can send /status anytime to see statistics about your game.
"""
    reply_with :message, text: message
  end
  context_handler :startgame

  def guess(guess, *)
    game = Game.find session[:game_id]
    if guess.is_a?(String) && guess.size == 8
      result = game.guess(game.players.first, guess.split(''))
      return reply_game_over if result == :ended
      if result && result[:matched]
        return reply_matched
      elsif result
        return reply_didnt_match
      else
        return reply_ended
      end
    else
      reply_invalid
    end
  end
  context_handler :guess

  def status(*)
    game = Game.find session[:game_id]
    message = <<END
Available colors: #{Game::COLORS}
---------
Total guesses this game: #{game.guesses.size}
Code solved? #{game.has_winner? ? 'Yes' : 'No'}
Game ended? #{game.ended? ? 'Yes' : 'No'}
Secret code: #{game.ended? ? game.code : 'Not yet!' }
---------
Send /startgame for a new game.
END
    reply_with :message, text: message
  end
  context_handler :status

  def reply_didnt_match
    message =
"""
Your guess didn't match! :/
You had #{result[:exact]} exacts and #{result[:near]} nears.
"""
    reply_with :message, text: message
  end

  def reply_ended
    message =
"""
Sorry, but you don't have any more guesses left.
Send /status to check your game statistics and the secret code.
Send /startgame for a new game.
"""
    reply_with :message, text: message
  end

  def reply_game_over
    message =
"""
Your game is over.
Send /status to check your game statistics.
Send /startgame for a new game.
"""
    reply_with :message, text: message
  end

  def reply_matched
    message =
"""
Your guess matched, congratulations!
Send /status to check your game statistics.
Send /startgame for a new game.
"""
    reply_with :message, text: message
  end

  def reply_invalid
    message =
"""
Your guess is invalid.
The game has 8 colors (RBGYOPCM) and 8 positions to guess.
To guess the code send /guess <combination of the colors>.
For example: /guess RBGYOPCM.

You can send /status anytime to see statistics about your game.
"""
    reply_with :message, text: message
  end

  def start(data = nil, *)
    message =
"""
Welcome! This is a Mastermind game bot.

Send /startgame to start a new game.
"""
    reply_with :message, text: response
  end
end
