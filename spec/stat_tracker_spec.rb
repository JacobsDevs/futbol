RSpec.describe StatTracker do
  describe '#initialize' do
		xit 'exists and has empty arrays by default' do
			stat = StatTracker.new
			expect(stat).to be_an_instance_of StatTracker
			expect(stat.games).to eq([])
			expect(stat.teams).to eq([])
			expect(stat.teams_games).to eq([])
		end
	end

	describe '#self.from_csv' do
		xit 'returns a StatTracker object with CSV data converted into Game, Team & TeamsGame objects' do
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
	  before(:all) do
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
		  xit 'can return an Int #highest_total_score' do
			  expect(@stat_tracker.highest_total_score).to eq(11)
			end
			xit 'can return an Int #lowest_total_score' do
				expect(@stat_tracker.lowest_total_score).to eq(0)
			end
			xit 'can return a Float #percentage_home_wins' do
				expect(@stat_tracker.percentage_home_wins).to eq(0.44)
			end
			xit 'can return a Float #percentage_visitor_wins' do
				expect(@stat_tracker.percentage_visitor_wins).to eq(0.36)
			end
			xit 'can return a Float #percentage_ties' do
			  expect(@stat_tracker.percentage_ties).to eq(0.2)
			end
			xit 'can return a Hash #count_of_games_by_season' do
				expect(@stat_tracker.count_of_games_by_season).to be_an_instance_of Hash
				expect(@stat_tracker.count_of_games_by_season['20122013']).to eq(806)
			end
			xit 'can return a Float #average_goals_per_game' do
				expect(@stat_tracker.average_goals_per_game).to eq(4.22)
			end
			xit 'can return a Hash #average_goals_by_season' do
				expect(@stat_tracker.average_goals_by_season).to be_an_instance_of Hash
				expect(@stat_tracker.average_goals_by_season['20122013']).to eq(4.12)
			end
		end
		describe 'League Methods' do
			xit 'can return an Integer of #count_of_teams' do
				expect(@stat_tracker.count_of_teams).to eq(32)
			end
			xit 'can return a String of #best_offense (highest average goals across all seasons)' do
			 expect(@stat_tracker.best_offense).to be_an_instance_of String
			 expect(@stat_tracker.best_offense).to eq('Reign FC')
			end
			xit 'can return a String of #worst_offense' do
				expect(@stat_tracker.worst_offense).to be_an_instance_of String
			  expect(@stat_tracker.worst_offense).to eq('Utah Royals FC')
			end
			xit 'can return a String of #highest_scoring_visitor (highest average goals across all seasons away)' do
			  expect(@stat_tracker.highest_scoring_visitor).to be_an_instance_of String
				expect(@stat_tracker.highest_scoring_visitor).to eq('FC Dallas')
			end	
			xit 'can return a String of #highest_scoring_home_team' do
			  expect(@stat_tracker.highest_scoring_home_team).to be_an_instance_of String
				expect(@stat_tracker.highest_scoring_home_team).to eq('Reign FC')
			end
			xit 'can return a String of #lowest_scoring_visitor' do
				expect(@stat_tracker.lowest_scoring_visitor).to be_an_instance_of String
				expect(@stat_tracker.lowest_scoring_visitor).to eq('San Jose Earthquakes')
			end
			xit 'can return a String of #lowest_scoring_home_team' do
				expect(@stat_tracker.lowest_scoring_home_team).to be_an_instance_of String
				expect(@stat_tracker.lowest_scoring_home_team).to eq('Utah Royals FC')
			end
		end
		describe 'Season Methods' do
			#These all take a season as an argument.  The season we will use to test is '20122013'
			xit 'can return a String of the #winningest_coach (best win % of season)' do
			  expect(@stat_tracker.winningest_coach('20122013')).to eq('Dan Lacroix')
			end
			xit 'can return a String of the #worst_coach' do
			  expect(@stat_tracker.worst_coach('20122013')).to eq('Martin Raymond')
			end
			xit 'can return a String of the #most_accurate_team' do
				expect(@stat_tracker.most_accurate_team('20122013')).to eq('DC United')
			end
			xit 'can return a String of the #least_accurate_team' do
				expect(@stat_tracker.least_accurate_team('20122013')).to eq('New York City FC')
			end
			xit 'can return a String of the #most_tackles' do
			  expect(@stat_tracker.most_tackles('20122013')).to be_an_instance_of String
			  expect(@stat_tracker.most_tackles('20122013')).to eq('FC Cincinnati')
			end
			xit 'can return a String of the #fewest_tackles' do
			  expect(@stat_tracker.fewest_tackles('20122013')).to be_an_instance_of String
			  expect(@stat_tracker.fewest_tackles('20122013')).to eq('Atlanta United')
			end
		end
		describe 'Team Methods' do
			#These all take a team id as an argument.  The team we will use to test is '1'
			#1,23,Atlanta United,ATL,Mercedes-Benz Stadium,/api/v1/teams/1
			xit 'can return a Hash of #team_info (team_id, franchise_id, team_name, abbrev, link)' do
			  expect(@stat_tracker.team_info(1)).to eq({:team_id => '1', :franchise_id => '23', :team_name => 'Atlanta United', :abbreviation => 'ATL', :link => '/api/v1/teams/1'})
			end
			xit 'can return a String #best_season (win percentage)' do
			  expect(@stat_tracker.best_season(1)).to eq('20152016')
			end
			xit 'can return a String #worst_season' do
			  expect(@stat_tracker.worst_season(1)).to eq('20162017')
			end
			xit 'can return a Float #average_win_percentage' do
			  expect(@stat_tracker.average_win_percentage(1)).to eq(0.36)
			end
			xit 'can return an Integer #most_goals_scored' do
			  expect(@stat_tracker.most_goals_scored(1)).to eq(6)
			end
			xit 'can return an Integer #fewest_goals_scored' do
			  expect(@stat_tracker.fewest_goals_scored(1)).to eq(0)
			end
			it 'can return a String #favorite_opponent (opponent has lowest win % against)' do
			  expect(@stat_tracker.favorite_opponent(1)).to eq('Chicago Red Stars')
			end
			it 'can return a String #rival' do
			  expect(@stat_tracker.rival(1)).to eq('San Jose Earthquakes')
			end
			xit 'can return an Integer #biggest_team_blowout (biggest point diff for win)' do
			  expect(@stat_tracker).to eq()
			end
			xit 'can return an Integer #worst_loss (biggest point diff loss)' do
			  expect(@stat_tracker).to eq()
			end
			xit 'can return a Hash #head_to_head (Key is opponent name, Value is win percentage)' do
			  expect(@stat_tracker).to eq()
			end
			xit 'can return a Hash #seasonal_summary (key is :regular_season or :postseason)' do
			  expect(@stat_tracker).to eq()
			end
			#Each of the keys point to another hash containing :win_percentage, :total_goals_scored,
			#:total_goals_against, :average_goals_scored, :average_goals_against
		end
	end
end
