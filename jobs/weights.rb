require 'date'
require 'yaml'

d = {
	"bicep_curls" => {
		"01/11/16" => {
			:sets => 4,
			:reps => 10, 
			:weight => 15
		},
		"06/11/16" => {
			:sets => 4,
			:reps => 10, 
			:weight => 20
		}
	}
}

File.open('jobs/data/data.yml', 'w') {|f| f.write d.to_yaml }

SCHEDULER.every '1m', :first_in => 0 do
	data = YAML::load_file('jobs/data/data.yml') 
	weights = data['weights']

	points = []
	x = Date.today.to_time.to_i 
	for day in (30).downto(0)

		offset = day * (60 * 60 * 24)
		unix = (x-offset)
		days_offset = DateTime.strptime(unix.to_s, '%s')
		date_index = days_offset.strftime("%d/%m/%y")
		date_key = DateTime.strptime(date_index.to_s, '%s')
		
		
		points << { :x => unix, :y => rand(50) }
		
	end

	puts points

  	send_event('bicep_curls', points: points)
end