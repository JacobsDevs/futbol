RSpec.describe StatTracker do
  describe '#initialize' do
		it 'exists and has empty data by default' do
			stat = StatTracker.new
			expect(stat).to be_an_instance_of StatTracker
			expect(stat.game_data).to eq({})
			expect(stat.team_data).to eq({})
			expect(stat.game_team_data).to eq({})
		end
	end

	describe '#self.from_csv' do
		it 'returns a StatTracker object with CSV data converted into hashes' do
		  game_path = './data/games.csv'
			team_path = './data/teams.csv'
			game_teams_path = './data/game_teams.csv'

			locations = {
				games: game_path,
				teams: team_path,
				game_teams: game_teams_path
			}
			stats = StatTracker.from_csv(locations)
			expect(stats.game_data[0]).to be_an_instance_of Hash
			expect(stats.game_data.empty?).to eq(false)
			expect(stats.team_data[0]).to be_an_instance_of Hash
			expect(stats.team_data.empty?).to eq(false) 
			expect(stats.game_team_data[0]).to be_an_instance_of Hash
			expect(stats.game_team_data.empty?).to eq(false) 
		end
	end
end
