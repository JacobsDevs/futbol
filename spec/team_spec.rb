RSpec.describe Team do
  describe '#initialize' do
	  it 'exists and has parameters' do
		  team_data = {
				:team_id => "1",
				:franchiseid => "23",
				:teamname => "Atlanta United",
				:abbreviation => "ATL",
				:stadium => "Mercedes-Benz Stadium",
				:link => "/api/v1/teams/1"
			}
			team = Team.new(team_data)
			expect(team).to be_an_instance_of Team
			expect(team.team_id).to eq("1")
			expect(team.franchise_id).to eq("23")
			expect(team.team_name).to eq("Atlanta United")
			expect(team.abbreviation).to eq("ATL")
			expect(team.stadium).to eq("Mercedes-Benz Stadium")
			expect(team.link).to eq("/api/v1/teams/1")
		end
	end

	describe '#build_teams' do
	  it 'returns an array of Team objects' do
			expect(Team.build_teams('./data/teams.csv')[0]).to be_an_instance_of Team
		end
	end
end