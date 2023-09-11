require 'game'
require 'team'
require 'teams_game'

class StatTracker
	attr_reader :games,
							:teams,
							:teams_games
	
	def initialize(games=[], teams=[], teams_games=[])
	  @games = games
		@teams = teams
		@teams_games = teams_games
	end

	def self.from_csv(locations)
	  games = Game.build_games(locations[:games])
		teams = Team.build_teams(locations[:teams])
		teams_games = TeamsGame.build_teams_games(locations[:game_teams])
	  StatTracker.new(games, teams, teams_games)
	end
end