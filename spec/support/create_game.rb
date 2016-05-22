def create_game(player_name)
  post '/v1/game/start', player: player_name
  JSON.parse(response.body)
end
