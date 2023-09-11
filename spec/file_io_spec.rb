RSpec.describe FileIo do
	before(:each) do
	  class Dummy
		  include FileIo
		end
		@dummy = Dummy.new
	end
	describe '#from_csv' do
	  it 'returns CSV in Array of Hashs form' do
			location = './data/games.csv'
			expect(@dummy.from_csv(location)).to be_an_instance_of Array
			expect(@dummy.from_csv(location)[0]).to be_an_instance_of Hash
		  location = {
				games: './data/games.csv', 
				teams: './data/teams.csv'
			}
			expect(@dummy.from_csv(location)[:games]).to be_an_instance_of Array
			expect(@dummy.from_csv(location)[:games][0]).to be_an_instance_of Hash
		end
	end
end
