module V1
  class GameController < ApplicationController
    def start
      @player = Player.new start_params
      @game = Game.create! players: [@player]
    end

    def status
      @game = Game.find(params[:id])
    end

    def play
      @guess = play_params['guess']
      @game = Game.find(params[:id])
      @player = @game.players.where(id: params[:player_id]).first
      @result = @game.guess(@player, @guess)
      if @result == :ended
        render json: { "error" =>  'the game is over' }, status: 401
        return
      end
      render json: { "error" => "not your turn." }, status: 401 if @result.nil?
    end

    def join
      @game = Game.find(params[:id])
      @game.players.build start_params
      begin
        @game.save!
      rescue Mongoid::Errors::Validations
        if @game.errors.include? :players
          render json: { "error" => 'the game is already full'}, status: 401
          return
        end
      end
      @player = @game.players.last
      render :start
    end

    private
    def start_params
      params.require(:player).permit(:name)
    end

    def play_params
      params.require(:guess).permit(guess: [])
    end
  end
end
