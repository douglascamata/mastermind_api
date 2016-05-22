json.colors Game::COLORS
json.total_guesses @game.guesses.size

json.solved @game.has_winner?
if @game.has_winner?
  json.solver @game.players.where(id: @game.winner_id).first.name
end

json.guesses @game.guesses do |guess|
  json.guess guess.guess
  json.player guess.player.name
end
