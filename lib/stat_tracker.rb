require_relative 'game'
require_relative 'team'
require_relative 'teams_game'

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

	###Game Statistics

	def highest_total_score
	  @games.map {|game| game.total_score}.max
	end

	def lowest_total_score
	  @games.map {|game| game.total_score}.min
	end

	def percentage_home_wins
	  wins = @games.count{|game| game.home_goals.to_i > game.away_goals.to_i}.to_f
		((wins / @games.length.to_f)).round(2)
	end

	def percentage_visitor_wins
	  wins = @games.count{|game| game.home_goals.to_i < game.away_goals.to_i}.to_f
		((wins / @games.length.to_f)).round(2)
	end

	def percentage_ties
	  ties = @games.count{|game| game.home_goals.to_i == game.away_goals.to_i}.to_f
		((ties / @games.length.to_f)).round(2)
	end

	def count_of_games_by_season
	  @games.map {|game| game.season}.inject(Hash.new(0)) {|hash, element| hash[element] += 1; hash}
	end
	
	def average_goals_per_game
	  average_goals = @games.inject(0.0) {|memo, game| memo + game.total_score} / @games.length.to_f
	  average_goals.round(2)
	end

	def average_goals_by_season
		scores = @games.inject(Hash.new(0)) {|memo, game| memo[game.season] += game.total_score; memo}
		games = count_of_games_by_season
		scores.each {|season, score| scores[season] = (score / games[season]).round(2)}
    scores
	end

	###League Statistics 

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

	
	def select_max_team(scores)
		@teams.select{|team| team.team_id == scores.max_by {|k,v| v}[0]}[0].team_name
	end
	
	def select_min_team(scores)
		@teams.select{|team| team.team_id == scores.min_by {|k,v| v}[0]}[0].team_name
	end
	
	def best_offense
		select_max_team(average_goals_by_team)
	end
	
	def worst_offense
	  select_min_team(average_goals_by_team)
	end
	
	def highest_scoring_visitor
		select_max_team(average_goals_by_away_team)
	end
	
	def highest_scoring_home_team
	  select_max_team(average_goals_by_home_team)
	end
	
	def lowest_scoring_visitor
		select_min_team(average_goals_by_away_team)
	end
	
  def lowest_scoring_home_team
		select_min_team(average_goals_by_home_team)
	end
	
  ###Season Statistics

	def select_max_coach(games)
		@teams_games.select{|game| game.head_coach == games.max_by {|k,v| v}[0]}[0].head_coach
	end
	
	def select_min_coach(games)
		@teams_games.select{|game| game.head_coach == games.min_by {|k,v| v}[0]}[0].head_coach
	end

	def games_in_season(season)
		@games.select {|game| game.season == season}.map{|game| game.game_id}
	end

	
	def coach_win_percentage(season)
		match_ids = games_in_season(season)
	  coach_stats = coach_wins(season)
		coach_stats.each do |coach, wins|
			coach_stats[coach] = (wins / @teams_games.count{|game| game.head_coach == coach && match_ids.include?(game.game_id)}).round(2)
		end
	end
	
	def coach_wins(season)
		match_ids = games_in_season(season)
		coaches = @teams_games.inject(Hash.new(0.0)) do |memo, match|
			if match.result == "WIN" && match_ids.include?(match.game_id)
				memo[match.head_coach] += 1.0
			elsif match_ids.include?(match.game_id)
				memo[match.head_coach] += 0.0 
			end
			memo
		end
	end

	def season_tackles(season)
		season_games = games_in_season(season)
		@teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.tackles.to_i if season_games.include?(game.game_id); memo}
	end

	def season_accuracy(season)
	  season_games = games_in_season(season)
		goals = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if season_games.include?(game.game_id); memo}
	  shots = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.shots.to_f if season_games.include?(game.game_id); memo}
		goals.each {|team, score| goals[team] = ((score / shots[team]) * 100).round(2)}
		return goals
	end

	def winningest_coach(season)
		select_max_coach(coach_win_percentage(season))
	end

	def worst_coach(season)
		select_min_coach(coach_win_percentage(season))
	end
	
	def most_tackles(season)
		select_max_team(season_tackles(season))
	end
	
	def fewest_tackles(season)
		select_min_team(season_tackles(season))
	end

	def most_accurate_team(season)
	  select_max_team(season_accuracy(season))
	end

	def least_accurate_team(season)
	  select_min_team(season_accuracy(season))
	end
end