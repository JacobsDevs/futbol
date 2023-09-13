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
    (@games.inject(0.0) {|memo, game| memo + game.total_score} / @games.length.to_f).round(2)
	end

	def average_goals_by_season
		scores = @games.inject(Hash.new(0)) {|memo, game| memo[game.season] += game.total_score; memo}
		games = count_of_games_by_season
		scores.each {|season, score| scores[season] = (score / games[season]).round(2)}
	end

	###League Statistics 

	def count_of_teams
	  @teams.length
	end

	def average_goals_by_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
	end

	def average_goals_by_away_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if game.hoa == 'away'; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
	end

	def average_goals_by_home_team
	  scores = @teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if game.hoa == 'home'; memo}
	  scores.each {|id, score| scores[id] = (score / @teams_games.count {|game| game.team_id == id}.to_f).round(2)}
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
	
	def coach_win_percentage(season)
		match_ids = games_in_season(season)
	  coach_stats = coach_wins(season)
		coach_stats.each do |coach, wins|
			coach_stats[coach] = (wins / @teams_games.count{|game| game.head_coach == coach && match_ids.include?(game.game_id)}).round(2)
		end
	end
	

	def season_tackles(season)
		season_games = games_in_season(season)
		@teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.tackles.to_i if season_games.include?(game.game_id); memo}
	end

	def season_goals(season)
	  season_games = games_in_season(season)
		@teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.goals.to_f if season_games.include?(game.game_id); memo}
	end

  def season_shots(season)
		season_games = games_in_season(season)
		@teams_games.inject(Hash.new(0)) {|memo, game| memo[game.team_id] += game.shots.to_f if season_games.include?(game.game_id); memo}
	end
	def season_accuracy(season)
	  season_games = games_in_season(season)
	  goals = season_goals(season)
		shots = season_shots(season)
		goals.each {|team, score| goals[team] = ((score / shots[team]) * 100).round(2)}
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

	###Team Statistics
	def team_info(id)
		team = @teams.find {|team| team.team_id == id.to_s}
	  {
			"team_id" => team.team_id, 
			"franchise_id" => team.franchise_id,
			"team_name" => team.team_name, 
			"abbreviation" => team.abbreviation, 
			"link" => team.link
		}
	end

	#Find teams Games
	def teams_history(id)
	  @games.select {|game| game.away_team_id == id.to_s || game.home_team_id == id.to_s}
	end
	#Find Seasons Competed in
  def teams_played_seasons(id)
	  teams_history(id).map {|game| game.season}.uniq
	end		
	#Find percentages for each season
  def games_to_season(seasons, history)
	  seasons.inject(Hash.new {|h, k| h[k]=[]}) {|a, season| a[season] += history.select{|game| game.season == season}; a}
	end

	def season_wins(matches, id)
	  wins = matches.inject(0) do |z, match| 
	    this_game = @teams_games.select {|game| game.game_id == match.game_id && game.team_id == id.to_s}
			z += 1 if this_game.first.result == 'WIN'
			z
		end
		wins.to_f
	end
	
	def teams_season_wins(id)
		games = games_to_season(teams_played_seasons(id), teams_history(id))
		games.inject(Hash.new(0)) do |hash, (season, matches)|
			games_played = matches.count
			hash[season] = season_wins(matches, id) / games_played.to_f
			hash
		end
	end
	
	def select_max_season(scores)
		scores.max_by {|k,v| v}.first
	end

	def select_min_season(scores)
		scores.min_by {|k,v| v}.first
	end

	def best_season(id)
	  select_max_season(teams_season_wins(id))
	end

	def worst_season(id)
		select_min_season(teams_season_wins(id))
	end

	def average_win_percentage(id)
	  games = teams_season_wins(id)
		(games.values.sum / games.values.size).round(2)
		#require 'pry'; binding.pry
	end

	def goals_scored(id)
	  history = teams_history(id).map {|game| game.game_id}
		scores = @teams_games.select {|game| history.include?(game.game_id)}.map {|game| game.goals.to_i}
	end

	def most_goals_scored(id)
		goals_scored(id).max
	end

	def fewest_goals_scored(id)
		goals_scored(id).min
	end

	def split_into_opponent_history(games, id)
    games.inject(Hash.new {|h, k| h[k] = []}) do |hash, game|
		  opponent = game.home_team_id == id.to_s ? game.away_team_id : game.home_team_id
			hash[opponent] << game
			hash
		end
	end
	
  def wins_against_opponents(id)
	  opponents = split_into_opponent_history(teams_history(id), id)
	  opponents.each do |opponent, matches|
			wins = matches.inject(0) do |z, match|
				z += 1 if @teams_games.select {|game| game.team_id == id.to_s && game.game_id == match.game_id}.first.result == "WIN"
				z
			end
			opponents[opponent] = wins
		end
		opponents
	end

	def get_percentage(wins, id)
		opponents = split_into_opponent_history(teams_history(id), id)
		opponents.inject(Hash.new(0)) do |h, (opponent, games)|
			h[opponent] = wins[opponent].to_f / opponents[opponent].size.to_f
			h
		end
	end

	def get_opponent_name(id)
		@teams.find{|team| team.team_id == id}.team_name
	end

	def favorite_opponent(id)
	  percentages = get_percentage(wins_against_opponents(id), id)
		get_opponent_name(percentages.max_by{|k, v| v}[0])
	end
	
	def rival(id)
		percentages = get_percentage(wins_against_opponents(id), id)
		get_opponent_name(percentages.min_by{|k, v| v}[0])
	end

end