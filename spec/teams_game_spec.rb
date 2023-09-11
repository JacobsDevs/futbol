RSpec.describe TeamsGame do
	describe '#initialize' do
	  it 'exists and has parameters' do
			teams_game_data = {
				:game_id => '2012030221',
				:team_id => '3',
				:hoa => 'away',
				:result => 'LOSS',
				:settled_in => 'OT',
				:head_coach => 'John Tortorella',
				:goals => '2',
				:shots => '8',
				:tackles => '44',
				:pim => '8',
				:powerplayopportunities => '3',
				:powerplaygoals => '0',
				:faceoffwinpercentage => '44.8',
				:giveaways => '17',
				:takeaways => '7'
			}

			teams_game = TeamsGame.new(teams_game_data)
			expect(teams_game).to be_an_instance_of TeamsGame
			expect(teams_game.game_id).to eq('2012030221')
			expect(teams_game.team_id).to eq('3')
			expect(teams_game.hoa).to eq('away')
			expect(teams_game.result).to eq('LOSS')
			expect(teams_game.settled_in).to eq('OT')
			expect(teams_game.head_coach).to eq('John Tortorella')
			expect(teams_game.goals).to eq('2')
			expect(teams_game.shots).to eq('8')
			expect(teams_game.tackles).to eq('44')
			expect(teams_game.pim).to eq('8')
			expect(teams_game.powerplayopportunities).to eq('3')
			expect(teams_game.powerplaygoals).to eq('0')
			expect(teams_game.faceoffwinpercentage).to eq('44.8')
			expect(teams_game.giveaways).to eq('17')
			expect(teams_game.takeaways).to eq('7')
		end
	end
	describe '#build_teams_games' do
	  it 'returns an array of TeamsGame objects' do
			expect(TeamsGame.build_teams_games('./data/game_teams.csv')[0]).to be_an_instance_of TeamsGame
		end
	end
end