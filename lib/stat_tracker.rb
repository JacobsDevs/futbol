require 'csv'

class StatTracker
	attr_reader :game_data,
							:team_data,
							:game_team_data
	
	def initialize(game_data={}, team_data={}, game_team_data={})
	  @game_data = game_data
		@team_data = team_data
		@game_team_data = game_team_data
	end

	def self.from_csv(locations)
	  game_data = CSV.foreach(locations[:games], headers: true, header_converters: :symbol).map(&:to_h)
		team_data = CSV.foreach(locations[:teams], headers: true, header_converters: :symbol).map(&:to_h)
		game_team_data = CSV.foreach(locations[:game_teams], headers: true, header_converters: :symbol).map(&:to_h)
	  StatTracker.new(game_data, team_data, game_team_data)
	end
end