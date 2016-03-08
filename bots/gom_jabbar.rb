class GomJabbar < RTanque::Bot::Brain
  NAME = 'GomJabbar'
  include RTanque::Bot::BrainHelper

	@verbose = verbose

  def tick!
    verbose
  end


	def verbose
		
		print "life: #{sensors.health} @ ticks: #{sensors.ticks}\n" if h
		print "life: #{sensors.health.round} @ ticks: #{sensors.ticks}\n" if h
		print "heading: #{sensors.heading} @ ticks: #{sensors.ticks}\n" if h
		print "Position: #{sensors.position} @ ticks: #{sensors.ticks}\n" if h
		print "radar: #{sensors.heading} @ ticks: #{sensors.ticks}\n" if h
	end



end
