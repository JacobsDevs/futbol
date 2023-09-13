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
	  before(:each) do
		  game_path = './data/games.csv'
			team_path = './data/teams.csv'
			game_teams_path = './data/game_teams.csv'

			locations = {
				games: game_path,
				teams: team_path,
				game_teams: game_teams_path
			}

			@stat_tracker = StatTracker.from_csv(locations)
		end
		describe 'Game Methods' do
		  it 'can return an Int #highest_total_score' do
			  expect(@stat_tracker.highest_total_score).to eq(11)
			end
			it 'can return an Int #lowest_total_score' do
				expect(@stat_tracker.lowest_total_score).to eq(0)
			end
			it 'can return a Float #percentage_home_wins' do
				expect(@stat_tracker.percentage_home_wins).to eq(43.5)
			end
			it 'can return a Float #percentage_visitor_wins' do
				expect(@stat_tracker.percentage_visitor_wins).to eq(36.11)
			end
			it 'can return a Float #percentage_ties' do
			  expect(@stat_tracker.percentage_ties).to eq(20.39)
			end
			it 'can return a Hash #count_of_games_by_season' do
				expect(@stat_tracker.count_of_games_by_season).to be_an_instance_of Hash
				expect(@stat_tracker.count_of_games_by_season['20122013']).to eq(806)
			end
			it 'can return a Float #average_goals_per_game' do
				expect(@stat_tracker.average_goals_per_game).to eq(4.22)
			end
			it 'can return a Hash #average_goals_by_season' do
				expect(@stat_tracker.average_goals_by_season).to be_an_instance_of Hash
				expect(@stat_tracker.average_goals_by_season['20122013']).to eq(4.12)
			end
		end
		describe 'League Methods' do
			it 'can return an Integer of #count_of_teams' do
				expect(@stat_tracker.count_of_teams).to eq(32)
			end
			it 'can return a String of #best_offense (highest average goals across all seasons)' do
			 expect(@stat_tracker.best_offense).to be_an_instance_of String
			 expect(@stat_tracker.best_offense).to eq('Reign FC')
			end
			it 'can return a String of #worst_offense' do
				expect(@stat_tracker.worst_offense).to be_an_instance_of String
			  expect(@stat_tracker.worst_offense).to eq('Utah Royals FC')
			end
			it 'can return a String of #highest_scoring_visitor (highest average goals across all seasons away)' do
			  expect(@stat_tracker.highest_scoring_visitor).to be_an_instance_of String
				expect(@stat_tracker.highest_scoring_visitor).to eq('FC Dallas')
			end	
			it 'can return a String of #highest_scoring_home_team' do
			  expect(@stat_tracker.highest_scoring_home_team).to be_an_instance_of String
				expect(@stat_tracker.highest_scoring_home_team).to eq('Reign FC')
			end
			it 'can return a String of #lowest_scoring_visitor' do
				expect(@stat_tracker.lowest_scoring_visitor).to be_an_instance_of String
				expect(@stat_tracker.lowest_scoring_visitor).to eq('San Jose Earthquakes')
			end
			it 'can return a String of #lowest_scoring_home_team' do
				expect(@stat_tracker.lowest_scoring_home_team).to be_an_instance_of String
				expect(@stat_tracker.lowest_scoring_home_team).to eq('Utah Royals FC')
			end
		end
		describe 'Season Methods' do
			#These all take a season as an argument.  The season we will use to test is '20122013'
			it 'can return a String of the #winningest_coach (best win % of season)' do
			  expect(@stat_tracker.winningest_coach('20122013')).to eq('Dan Lacroix')
			end
			it 'can return a String of the #worst_coach' do
			  expect(@stat_tracker.worst_coach('20122013')).to eq('Jon Cooper')
			end
			it 'can return a String of the #most_accurate_team' do
				expect(@stat_tracker.most_accurate_team('20122013')).to eq('DC United')
			end
			it 'can return a String of the #least_accurate_team' do
				expect(@stat_tracker.least_accurate_team('20122013')).to eq('New York City FC')
			end
			it 'can return a String of the #most_tackles' do
			  expect(@stat_tracker.most_tackles('20122013')).to be_an_instance_of String
			  expect(@stat_tracker.most_tackles('20122013')).to eq('FC Cincinnati')
			end
			it 'can return a String of the #fewest_tackles' do
			  expect(@stat_tracker.fewest_tackles('20122013')).to be_an_instance_of String
			  expect(@stat_tracker.fewest_tackles('20122013')).to eq('Atlanta United')
			end
		end
	end
end
