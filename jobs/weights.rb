require 'date'
require 'yaml'

SCHEDULER.every '1m', :first_in => 0 do
	data = YAML::load_file('jobs/data/data.yml') 
	bicep_curls = data['bicep_curls']
	points = []
	x = Date.today
	for day in (30).downto(0)
		day_index = x - day
		if bicep_curls.key?(day_index)
			details = bicep_curls[day_index]
			value = details[:sets].to_i * details[:reps].to_i * details[:weight].to_i
			points << { :x => day_index.to_time.to_i, :y => value }
		else
			points << { :x => day_index.to_time.to_i, :y => 0 }
		end
		
	end

  	send_event('bicep_curls', points: points)
end

SCHEDULER.every '1m', :first_in => 0 do
	data = YAML::load_file('jobs/data/data.yml') 
	tabs = data['tabs']
	points = []
	x = Date.today
	while x.wday != 4
		x -= 1
	end
	for week in (10).downto(0)
		day_index = x - (7 * week)
		if tabs.key?(day_index)
			details = tabs[day_index]
			value = details[:weight].to_i
			points << { :x => day_index.to_time.to_i, :y => value }
		else
			points << { :x => day_index.to_time.to_i, :y => 0 }
		end
	end

  	send_event('tabs', points: points)
end