require_relative 'file_io'

class Team
	extend FileIo

	attr_reader :team_id,
							:franchise_id,
							:team_name,
							:abbreviation,
							:stadium,
							:link

	def initialize(data)
		@team_id = data[:team_id]
		@franchise_id = data[:franchiseid]
		@team_name = data[:teamname]
		@abbreviation = data[:abbreviation]
		@stadium = data[:stadium]
		@link = data[:link]
	end

	def self.build_teams(csvdata)
		teams = []
		from_csv(csvdata).each do |teamdata|
			teams << Team.new(teamdata)
		end
		#require 'pry';binding.pry
		return teams
	end
end