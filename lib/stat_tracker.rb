require './lib/game'
require './lib/team'
require './lib/teams_game'

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

	def highest_total_score
	  @games.map {|game| game.total_score}.max
	end

	def lowest_total_score
	  @games.map {|game| game.total_score}.min
	end

	def percentage_home_wins
	  wins = @games.count{|game| game.home_goals.to_i > game.away_goals.to_i}.to_f
		((wins / @games.length.to_f) * 100.0).round(2)
	end

	def percentage_visitor_wins
	  wins = @games.count{|game| game.home_goals.to_i < game.away_goals.to_i}.to_f
		((wins / @games.length.to_f) * 100.0).round(2)
	end

	def percentage_ties
	  ties = @games.count{|game| game.home_goals.to_i == game.away_goals.to_i}.to_f
		((ties / @games.length.to_f) * 100.0).round(2)
	end

	def count_of_games_by_season
	  @games.map {|game| game.season}.inject(Hash.new(0)) {|hash, element| hash[element] += 1; hash}
	end
	
	def average_goals_by_game
	  average_goals = @games.inject(0.0) {|memo, game| memo + game.total_score} / @games.length.to_f
	  average_goals.round(2)
	end

	def average_goals_by_season
		scores = @games.inject(Hash.new(0)) {|memo, game| memo[game.season] += game.total_score; memo}
		games = count_of_games_by_season
		scores.each {|season, score| scores[season] = (score / games[season]).round(2)}
    scores
	end

	def count_of_teams
	  @teams.length
	end

	def average_goals_by_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
		scores
	end

	def average_goals_by_away_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if game.hoa == 'away'; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
		scores
	end

	def average_goals_by_home_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if game.hoa == 'home'; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
		scores
	end

	def select_max(scores)
		teams.select{|team| team.team_id == scores.max_by {|k,v| v}[0]}[0].team_name
	end

	def select_min(scores)
		teams.select{|team| team.team_id == scores.min_by {|k,v| v}[0]}[0].team_name
	end

	def best_offense
		select_max(average_goals_by_team)
	end

	def worst_offense
	  select_min(average_goals_by_team)
	end

	def highest_scoring_visitor
		select_max(average_goals_by_away_team)
	end

	def highest_scoring_home_team
	  select_max(average_goals_by_home_team)
	end

	def lowest_scoring_visitor
		select_min(average_goals_by_away_team)
	end

  def lowest_scoring_home_team
		select_min(average_goals_by_home_team)
	end

end