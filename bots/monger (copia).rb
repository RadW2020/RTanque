class Monger < RTanque::Bot::Brain
	attr_accessor :ticks, :enemy, :bot, :a , :b, :point_destino , :point_yo , :enemy
	attr_reader :x 
  attr_reader :y 
  attr_reader :arena

	def initialize(enemy)
		@point_destino = point_destino
		@point_yo = point_yo
		@enemy = enemy
		@previousTargetX = 0
    @previousTargetY = 0
		@destino_x = 0
		@destino_y = 0
		@angle = 0
		@a = 1
	end

	NAME = 'Monger'
	include RTanque::Bot::BrainHelper
	
	def tick!

		velocidad
		movimiento
		radar_y_torreta
		detectar_y_apuntar
		
	end
	
	def detectar_y_apuntar
    sensors.radar.sort_by(&:distance)
		@enemy = sensors.radar.first
		if enemy
			
			enemyX = sensors.position.x + Math.sin(enemy.heading) * enemy.distance
      enemyY = sensors.position.y + Math.cos(enemy.heading) * enemy.distance

			enemy_position = RTanque::Point.new(enemyX, enemyY)
			
			command.radar_heading = enemy.heading 
  	  command.turret_heading = RTanque::Heading.new_between_points(sensors.position, enemy_position)
			
			disparo
		else
			radar_y_torreta
		end
  end

	def disparo
		#delta_turret_enemy = (self.sensors.turret_heading - @angle).abs
		#p delta_turret_enemy.to_degrees
		self.command.fire(fuego) #if not delta_turret_enemy.to_degrees.between?(10, 350) 
	end
	
	def fuego
		RTanque::Bot::MAX_FIRE_POWER
		#Por desgracia parece que la torreta no gira mientras dispara, bad idea
		#puts "#{(RTanque::Bot::MAX_FIRE_POWER * enemy.distance ) / 600}"
		#( RTanque::Bot::MAX_FIRE_POWER * enemy.distance ) / 600
	end
		
	def radar_y_torreta
		self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.radar_heading + MAX_TURRET_ROTATION
	end
	
	def movimiento
		#self.sensors.ticks.to_s.split('')[-2].to_i.between?(0,3)
					
		self.command.heading = RTanque::Heading.new_between_points(mi_posicion, destino) + ( ( RTanque::Heading::ONE_DEGREE * 45))
	end
	
	def generar_destino_matrix
		arena_matrix_x_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700,750, 800,850, 900,650, 1000,1050, 1100,1150, 1200]
		arena_matrix_y_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700]	
	
		@destino_x = arena_matrix_x_coord[rand(2..22).round]
		@destino_y = arena_matrix_y_coord[rand(2..12).round]
	end
	
	def destino
		delta_cambio_x = ( self.sensors.position.x - @destino_x ).abs
		delta_cambio_y = ( self.sensors.position.y - @destino_y ).abs
		delta_cambio = Math.sqrt((delta_cambio_x)**2 + (delta_cambio_y)**2)
	
		generar_destino_matrix if delta_cambio > 200 or delta_cambio < 110 
		generar_destino_matrix if delta_cambio_x == 0 or delta_cambio_y == 0
		
		RTanque::Point.new(@destino_x, @destino_y, RTanque::Arena)
	end

	def mi_posicion
		RTanque::Point.new(self.sensors.position.x, self.sensors.position.y, RTanque::Arena)
	end

	def velocidad
		self.command.speed = RTanque::Bot::MAX_SPEED 
	end

end

=begin	
	def direccion
		#ARRIBA
    if (sensors.position.y > 600)
       heading(RTanque::Point.new(1000, 100, @arena))  
		#ABAJO
    elsif (sensors.position.on_bottom_wall?) or (sensors.position.y < 200)
        return Math::PI / -1
     #IZQUIERDA
    elsif (sensors.position.on_left_wall?) or (sensors.position.x < 200)
        return Math::PI / 1.5
     #DERECHA
    else (sensors.position.on_right_wall?) or (sensors.position.x < 1000)
        return Math::PI / -2 
    end
	end	
	def heading_mod
		#ARRIBA
    if (sensors.position.on_top_wall?) or (sensors.position.y > 600)
        return Math::PI 
		#ABAJO
    elsif (sensors.position.on_bottom_wall?) or (sensors.position.y < 200)
        return Math::PI / -1
     #IZQUIERDA
    elsif (sensors.position.on_left_wall?) or (sensors.position.x < 200)
        return Math::PI / 1.5
     #DERECHA
    else (sensors.position.on_right_wall?) or (sensors.position.x < 1000)
        return Math::PI / -2 
    end
	end
			
end

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

if self.sensors.ticks.to_s.split('')[-2].to_i.odd?
				a = self.sensors.radar_heading  #self.sensors.radar_heading + 2
			
			elsif self.sensors.ticks.to_s.split('')[-2].to_i.even?
				a = (2 * self.sensors.radar_heading * ( 1 - self.sensors.radar_heading ))
			else
				a = self.sensors.radar_heading 
			end


number = self.sensors.ticks.to_s.split('')[-1].to_i
		a = number
		a = (2 * a * ( 1 - a )) 
		b = a
		b = (1.5 * b * ( 1 - b ))
		m = Math.cos(0.1 * number)
		puts a
		puts heading_mod
		command.heading = sensors.radar_heading + (RTanque::Heading::ONE_DEGREE * (heading_mod))
		puts command.heading

def disparo
		#self.command.turret_heading = self.sensors.radar_heading + enemy.heading
		if enemy #&& apuntado #&& self.sensors.turret_heading.delta(enemy.heading).abs < (RTanque::Heading::ONE_DEGREE * 0.5)
		self.command.fire(MAX_FIRE_POWER)
		end
	end



def detectar_y_disparar
    sensors.radar.sort_by(&:distance)
		@enemy = sensors.radar.first
		if enemy
			power = RTanque::Bot::MAX_FIRE_POWER
			targetX = sensors.position.x + Math.sin(enemy.heading) * enemy.distance
      targetY = sensors.position.y + Math.cos(enemy.heading) * enemy.distance

			predictedTargetX = targetX + (targetX - @previousTargetX) * enemy.distance / (5.0 * power)
      predictedTargetY = targetY + (targetY - @previousTargetY) * enemy.distance / (5.0 * power)

			deltaX = predictedTargetX - sensors.position.x
      deltaY = predictedTargetY - sensors.position.y

			tan = deltaX / deltaY
			if (deltaX > 0 && deltaY > 0)
          angle = Math.atan(tan)
        elsif (deltaX > 0 && deltaY < 0)
          angle = Math::PI - Math.atan(-tan)
        elsif (deltaX < 0 && deltaY > 0)
          angle = Math::PI * 2 - Math.atan(-tan)
        elsif (deltaX < 0 && deltaY < 0)
          angle = Math::PI + Math.atan(tan)
      end
		
			self.command.radar_heading = enemy.heading 
  	  self.command.turret_heading = angle
			p "Enemigo: #{enemy.name}; Distancia:#{@enemy.distance}"
			#esto es donde está el enemigo CHECKED
			p "Enemy heading:    #{enemy.heading.to_degrees}"
			#esto es a donde apunta"ba" el radar CHECKED
			p "my Radar heading: #{sensors.radar_heading.to_degrees}"
			p " "
			#EL VECTOR DE DIRECCION DEL ENEMIGO ES EL QUE SALE AL COMPARAR MY Radar HEADING CON EL ENEMY HEADING
			#self.command.turret_heading = sensors.radar_heading.to_degrees + Math.tan2(-enemy.heading.to_degrees + sensors.radar_heading.to_degrees)

			@previousTargetX = targetX
      @previousTargetY = targetY
			self.command.fire(MAX_FIRE_POWER)
			else
				radar_y_torreta
		end
end

def destino
		destino_alpha_x =  Math.sqrt((1 - (Math.cos(Math::PI + self.sensors.position.x)))) 
		destino_alpha_y =  Math.sqrt((1 - (Math.sin(Math::PI + self.sensors.position.y)))) 
		destino_x = (Math.cos(Math::PI + destino_alpha_x)) + 500
		destino_y = (Math.sin(Math::PI + destino_alpha_y)) + 300
		RTanque::Point.new(destino_x, destino_y, RTanque::Arena)
end

		at_tick_interval(100) do
			puts "Tick ##{sensors.ticks}!"
			puts " Gun Energy: #{sensors.gun_energy}"
			puts " Health: #{sensors.health}"
			puts " Position: (#{sensors.position.x}, #{sensors.position.y})"
			puts "command.heading: #{self.command.heading}"
			puts "@point_yo        #{mi_posicion}" 
			puts "@point_destino   #{destino}"
			puts sensors.position.on_wall? ? " On Wall" : " Not on wall"
			puts " Speed: #{sensors.speed}"
			#puts " Heading: #{sensors.heading.inspect}"
			#puts " Turret Heading: #{sensors.turret_heading.inspect}"
			#puts " Radar Heading:  #{sensors.radar_heading.inspect}"
			puts " Radar Reflections (#{sensors.radar.count}):"
			#puts " Radar INSPECT (#{sensors.radar.inspect}):"
			puts "------------------------------------------------------"
		end 


at_tick_interval(50) do
			p "CHAOS #{self.sensors.ticks}"
			@destino_x = 1 - self.sensors.position.y + self.sensors.position.x 
		end
		at_tick_interval(70) do
			p "CHAOS NEG #{self.sensors.ticks}"
			@destino_y = Math.sin(1- self.sensors.position.x) 
		end

def detectar_y_apuntar
    sensors.radar.sort_by(&:distance)
		@enemy = sensors.radar.first
		if enemy
			
			targetX = sensors.position.x + Math.sin(enemy.heading) * enemy.distance
      targetY = sensors.position.y + Math.cos(enemy.heading) * enemy.distance

			predictedTargetX = targetX + (targetX - @previousTargetX) * enemy.distance / (5.0 * fuego)
      predictedTargetY = targetY + (targetY - @previousTargetY) * enemy.distance / (5.0 * fuego)

			deltaX = predictedTargetX - sensors.position.x
      deltaY = predictedTargetY - sensors.position.y

			tan = deltaX / deltaY
			if (deltaX > 0 && deltaY > 0)
          @angle = Math.atan(tan)
        elsif (deltaX > 0 && deltaY < 0)
          @angle = Math::PI - Math.atan(-tan)
        elsif (deltaX < 0 && deltaY > 0)
          @angle = Math::PI * 2 - Math.atan(-tan)
        elsif (deltaX < 0 && deltaY < 0)
          @angle = Math::PI + Math.atan(tan)
      end
		
			self.command.radar_heading = enemy.heading 
  	  self.command.turret_heading = @angle
			#p "Enemigo: #{enemy.name}; Distancia:#{@enemy.distance}"
			#esto es donde está el enemigo CHECKED
			#p "Enemy heading:    #{enemy.heading.to_degrees}"
			#esto es a donde apunta"ba" el radar CHECKED
			#p "my Radar heading: #{sensors.radar_heading.to_degrees}"
			
			#EL VECTOR DE DIRECCION DEL ENEMIGO ES EL QUE SALE AL COMPARAR MY Radar HEADING CON EL ENEMY HEADING
			#self.command.turret_heading = sensors.radar_heading.to_degrees + Math.tan2(-enemy.heading.to_degrees + sensors.radar_heading.to_degrees)

			@previousTargetX = targetX
      @previousTargetY = targetY
			disparo
			else
				radar_y_torreta
		end
  end
=end



