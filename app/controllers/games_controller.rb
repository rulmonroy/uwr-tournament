class GamesController < ApplicationController
  # POST /games
  #
  # Based on the parameters received, creates a new game and redirects the user
  # to the screen that visualizes it.
  def create
    @game = Game.new(new_game_params)
    @game.date = Time.now
    if @game.save
      redirect_to game_path(@game)
    else
      @teams = Team.all
      render 'games/new'
    end
  end

  # GET /
  # On the root of the application, allows the creation of a new game
  def new
    @teams = Team.all
    @game = Game.new
  end

  private
    # This defines the attributes that are permitted when creating a new game
    def new_game_params
      params.require(:game).permit(:blue_team_id,
                                   :white_team_id,
                                   player_ids: [])
    end
end
