class Monger_Circulos < RTanque::Bot::Brain
	attr_accessor  :enemy

	def initialize(enemy)
		@enemy = enemy
		@destino_x = 0
		@destino_y = 0
		@enemy_position_old = RTanque::Point.new(500,500)
		@enemy_position_new = RTanque::Point.new(500,500)
		
	end

	NAME = 'Monger_Circulos'
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

			@enemy_position_old = @enemy_position_new 
			@enemy_position_new = enemy_position

			delta_enemy_position_x = (@enemy_position_new.x - @enemy_position_old.x) 
			delta_enemy_position_y = (@enemy_position_new.y - @enemy_position_old.y) 
			enemy_vector = Math.sqrt(delta_enemy_position_x**2 + delta_enemy_position_y**2) 

			mod = fuego * enemy_vector
			
			command.radar_heading = enemy.heading
  	  @enemy_point_prediction = RTanque::Point.new(enemyX + (delta_enemy_position_x * mod) , enemyY + (delta_enemy_position_y * mod), RTanque::Arena)
  	  command.turret_heading = RTanque::Heading.new_between_points(mi_posicion, @enemy_point_prediction) 
			
			if (sensors.turret_heading.to_degrees - (RTanque::Heading.new_between_points(mi_posicion, @enemy_point_prediction)).to_degrees ).abs < 2
				disparo(fuego)
			end
			
		else
			disparo(1)
			radar_y_torreta 
		end
  end

	def disparo(fuego)
		command.fire(fuego) 
	end
	
	def fuego
		RTanque::Bot::MAX_FIRE_POWER
	end
	
	def mi_posicion
		RTanque::Point.new(sensors.position.x, sensors.position.y, RTanque::Arena)
	end
		
	def radar_y_torreta
		command.radar_heading = sensors.radar_heading + MAX_RADAR_ROTATION
    command.turret_heading = sensors.radar_heading + MAX_TURRET_ROTATION
	end
	
	def movimiento
		command.heading = sensors.heading + MAX_BOT_ROTATION 
	end
	

	def velocidad
		command.speed = RTanque::Bot::MAX_SPEED 
	end

end

