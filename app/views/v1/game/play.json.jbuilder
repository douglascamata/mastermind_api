json.colors Game::COLORS
json.guess @guess
json.total_guesses @game.guesses.size
json.history @game.guesses do |guess|
  json.guess guess.guess
  json.exact guess.exact
  json.near guess.near
  json.player guess.player.name
end
json.exact @result[:exact]
json.near @result[:near]
json.solved @result[:matched]
