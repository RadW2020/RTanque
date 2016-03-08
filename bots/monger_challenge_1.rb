class Monger < RTanque::Bot::Brain
	attr_accessor  :enemy

	def initialize(enemy)
		@enemy = enemy
		@destino_x = 0
		@destino_y = 0
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
			#mejorar teniendo en cuenta la velocidad del enemigo
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
		#implementar disparar solo si "apuntando correctamente"
		command.fire(fuego) 
	end
	
	def fuego
		RTanque::Bot::MAX_FIRE_POWER
	end
		
	def radar_y_torreta
		command.radar_heading = sensors.radar_heading + MAX_RADAR_ROTATION
    command.turret_heading = sensors.radar_heading + MAX_TURRET_ROTATION
	end
	
	def movimiento
		command.heading = RTanque::Heading.new_between_points(mi_posicion, destino) #+ (RTanque::Heading::ONE_DEGREE * 45)
	end
	
	def generar_destino_matrix
		arena_matrix_x_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700,750, 800,850, 900,650, 1000,1050, 1100,1150, 1200]
		arena_matrix_y_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700]	
		#implementar zig zag y evitar el centro
		@destino_x = arena_matrix_x_coord[rand(2..22).round]
		@destino_y = arena_matrix_y_coord[rand(2..12).round]
	end
	
	def destino
		delta_cambio_x = ( sensors.position.x - @destino_x ).abs
		delta_cambio_y = ( sensors.position.y - @destino_y ).abs
		delta_cambio = Math.sqrt((delta_cambio_x)**2 + (delta_cambio_y)**2)
		generar_destino_matrix if delta_cambio > 200 or delta_cambio < 110 
		generar_destino_matrix if delta_cambio_x == 0 or delta_cambio_y == 0
		
		RTanque::Point.new(@destino_x, @destino_y, RTanque::Arena)
	end

	def mi_posicion
		RTanque::Point.new(sensors.position.x, sensors.position.y, RTanque::Arena)
	end

	def velocidad
		#implementar un quiebro antiseguimiento
		command.speed = RTanque::Bot::MAX_SPEED 
	end

end

