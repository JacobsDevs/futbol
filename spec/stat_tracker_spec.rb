RSpec.describe StatTracker do
  describe '#initialize' do
		it 'exists and has empty arrays by default' do
			stat = StatTracker.new
			expect(stat).to be_an_instance_of StatTracker
			expect(stat.games).to eq([])
			expect(stat.teams).to eq([])
			expect(stat.teams_games).to eq([])
		end
	end

	describe '#self.from_csv' do
		it 'returns a StatTracker object with CSV data converted into Game, Team & TeamsGame objects' do
			game_path = './data/games.csv'
			team_path = './data/teams.csv'
			game_teams_path = './data/game_teams.csv'

			locations = {
				games: game_path,
				teams: team_path,
				game_teams: game_teams_path
			}

			stat_tracker = StatTracker.from_csv(locations)
			expect(stat_tracker.games[0]).to be_an_instance_of Game
			expect(stat_tracker.teams[0]).to be_an_instance_of Team
			expect(stat_tracker.teams_games[0]).to be_an_instance_of TeamsGame
		end
	end

	describe 'Methods' do
	  describe 'Game Methods' do
		  it 'can return an Int #highest_total_score'
			it 'can return an Int #lowest_total_score'
			it 'can return a Float #percentage_home_wins'
			it 'can return a Float #percentage_visitor_wins'
			it 'can return a Float #percentage_ties'
			it 'can return a Hash #count_of_games_by_season'
			it 'can return a Float #average_goals_per_game'
			it 'can return a Hash #average_goals_by_season'
		end
	end
end
