class MastermindAPI
  include HTTParty
  base_uri 'az-mastermind.herokuapp.com'

  headers 'Content-Type' => 'application/json'

  def new_game(user)
    self.class.post("/new_game", body: { user: user }.to_json)
  end

  def guess(code, game_key)
    p "Sending code #{code} to game #{game_key}"
    response = self.class.post("/guess", body: { code: code, game_key: game_key }.to_json)
    if not response['result']
      p response
      return nil
    else
      p "Evaluation: #{response['result'].to_s}"
    end
    p '-'*80
    response
  end
end
