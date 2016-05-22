Rails.application.routes.draw do
  namespace :v1 do
    post 'game/start', controller: :game, action: :start, as: :game_start
    get 'game/:id', controller: :game, action: :status, as: :game_status
    post 'game/:id/join', controller: :game, action: :join, as: :game_player_join
    post 'game/:id/player/:player_id', controller: :game, action: :play, as: :game_player_play
  end

  root :to => "welcome#show"

  match '*unmatched_route', :to => 'application#not_found', via: :all
  telegram_webhooks Telegram::LocalWebhookController
end
