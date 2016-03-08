class Monger < RTanque::Bot::Brain
	NAME = 'Monger'
	include RTanque::Bot::BrainHelper
	
	attr_accessor :enemy
	
	def tick!
		velocidad
		movimiento
		escoger_enemigo
		apuntar_y_disparar
		radar_y_torreta
	end
	
	def escoger_enemigo
    sensors.radar.sort_by(&:distance)
		@enemy = self.sensors.radar.first
	end
		
	def apuntar_y_disparar
		if @enemy
			self.command.radar_heading = @enemy.heading 
  	  self.command.turret_heading = @enemy.heading
			disparo
		end
  end
		
	def radar_y_torreta
		self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.radar_heading + MAX_TURRET_ROTATION
	end
	
	def disparo
		self.command.fire(MAX_FIRE_POWER)
	end
	
	def movimiento
				
		command.heading = sensors.radar_heading
	end

	def velocidad
		command.speed = RTanque::Bot::MAX_SPEED
	end
		
			
end
=begin
self.at_tick_interval(100) do
print "NEAREST TARGET: #{target_locked} "
print "My Tank Heading: #{sensors.heading.to_degrees.round} degrees  " 
print "Tick: #{sensors.ticks}\n"
print "My radar_heading: #{sensors.radar_heading.to_degrees.round} degrees \n"
print "My turret heading: #{sensors.turret_heading.to_degrees.round} degrees\n"
print "My Position-> X: #{sensors.position.x.round} Y: #{sensors.position.y.round}  "
print "My gun_energy: #{sensors.gun_energy} My_speed: #{sensors.speed}\n" 
print "\n"
print "radar enumerator: #{sensors.radar.to_a} \n"
#print "reflection_distance: #{reflection.distance.first}\n"
print "Heading.delta(command.heading): #{sensors.heading.delta(command.heading)}\n"
print "------------------\n"
end

def only_shoot_on_sight
angle_amplitude = (Math::PI / 300.0)
delta_amplitude = sensors.radar_heading.to_degrees - sensors.turret_heading.to_degrees
self.command.fire(MAX_FIRE_POWER) if delta_amplitude < 2 || delta_amplitude = 0
end

print "------------------\n"
print "DELTA_AMP: #{sensors.radar_heading.to_degrees - sensors.turret_heading.to_degrees} degrees \n"
print "Math::PI: #{Math::PI / 8} degrees \n"
print "- Math::PI : #{self.sensors.radar_heading.to_degrees - Math::PI } degrees\n"
#print "My Position: #{self.position.x} XY\n"	
	
def nearest_target
reflections = sensors.radar
reflections = reflections.reject{|r| 
r.name == NAME } unless @friendly_fire
reflections.sort_by{|r| r.distance }.first
end

		self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.radar_heading + MAX_TURRET_ROTATION
		#MOVIMIENTO
		#command.heading = sensors.heading + RTanque::Heading::ONE_DEGREE
		a = self.command.radar_heading.to_degrees
  	enemy = self.sensors.radar.first
		chaos_target = enemy.heading
		move
		if enemy
			self.command.radar_heading = enemy.heading 
  	  self.command.turret_heading = enemy.heading
			self.command.fire(MAX_FIRE_POWER)
		else
			self.command.radar_heading = 
				self.sensors.radar_heading + 
				MAX_RADAR_ROTATION
		end

    command.heading = chaos_target
    #chaos_target =  (2 * a * ( 1 - a )) + (rand(-3..-1) * (Math::PI / 4.0)) 
    #command.heading =  1 / (5 * chaos_target) + a
		#HACER UN IF TORRET HEADING NO ES IGUAL A RADAR HEADING , DONT SHOOT
	end
	
	def move
			if self.sensors.ticks.to_s.split('').last(2) == 99
	 			a = (2 * a * ( 1 - a ))
				chaos_target = a
				#elsif self.sensors.ticks.to_s.split('').last(2) == 00
				#chaos_target = enemy.heading
			else 
				chaos_target = self.command.radar_heading.to_degrees 		#enemy.heading
			end
	end
=end



