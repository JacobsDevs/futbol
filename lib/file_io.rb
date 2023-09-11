require 'csv'

module FileIo
  def from_csv(data)
	  if data.is_a? String
			return CSV.foreach(data, headers: true, header_converters: :symbol).map(&:to_h)
		elsif data.is_a? Hash
			hash = Hash.new {|h, k| h[k] = []}
			data.each do |type, location|
				hash[type] = CSV.foreach(location, headers: true, header_converters: :symbol).map(&:to_h)
				#require 'pry'; binding.pry
			end
			return hash
		end
	end
end