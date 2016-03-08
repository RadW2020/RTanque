class Monger < RTanque::Bot::Brain
	attr_accessor  :enemy , :enemies

	def initialize(enemy)
		@enemy = enemy
		#@enemies = enemies
		@enemies = []
		@a = []
		@destino_x = 0
		@destino_y = 0
		@enemy_position_old = RTanque::Point.new(500,500)
		@enemy_position_new = RTanque::Point.new(500,500)
	end

	NAME = 'Monger'
	include RTanque::Bot::BrainHelper
	
	def tick!
		
		otear
		velocidad
		movimiento
		radar_y_torreta
		apuntar_y_disparar if @enemy
		
	end
	
  def	otear
  	
  	sensors.radar.each{|reflect| @enemies << reflect.name if not @enemies.include?(reflect.name)}
  	
  	#p "#{@enemies}"
  	
		sensors.radar.sort_by(&:distance)
		@enemy = sensors.radar.first
		
	end
		
	
	def apuntar_y_disparar
    
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
  	  angulo_objetivo = RTanque::Heading.new_between_points(mi_posicion, @enemy_point_prediction)
  	  command.turret_heading = angulo_objetivo 
			
			if (sensors.turret_heading.to_degrees - (angulo_objetivo).to_degrees).abs < 3 
			#puts "#{ (sensors.turret_heading.to_degrees - (angulo_objetivo).to_degrees).abs }"
			disparo(fuego)
			#p "shoot"
			end
  end

	def disparo(fuego)
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
		command.heading = RTanque::Heading.new_between_points(mi_posicion, destino) 
	end
	
	def generar_destino_matrix
		arena_matrix_x_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700,750, 800,850, 900,650, 1000,1050, 1100,1150, 1200]
		arena_matrix_y_coord = [0,50, 100,150, 200,250, 300,350, 400,450, 500,550, 600,650, 700]	
		
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
		command.speed = RTanque::Bot::MAX_SPEED 
	end

end

=begin
class Monger < RTanque::Bot::Brain
	attr_accessor  :enemy

	def initialize(enemy)
		@enemy = enemy
		@destino_x = 0
		@destino_y = 0
		@enemy_position_old = RTanque::Point.new(500,500)
		@enemy_position_new = RTanque::Point.new(500,500)
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

			@enemy_position_old = @enemy_position_new 
			@enemy_position_new = enemy_position
			#15 es asumiendo que los enemigos van siempre a la velocidad máxima 
			delta_enemy_position_x = (@enemy_position_new.x - @enemy_position_old.x)
			delta_enemy_position_y = (@enemy_position_new.y - @enemy_position_old.y)
			enemy_vector = Math.sqrt(delta_enemy_position_x**2 + delta_enemy_position_y**2)
			mod_vector = enemy_vector * fuego * 2
			mod_x = delta_enemy_position_x * mod_vector
			mod_y = delta_enemy_position_y * mod_vector
			
=begin	
			puts "@enemy_position_new.x #{@enemy_position_new.x}"
			puts "@enemy_position_old.x #{@enemy_position_old.x}"
			puts "@enemy_position_new.y #{@enemy_position_new.y}"
			puts "@enemy_position_old.y #{@enemy_position_old.y}"
			puts " "
			puts "Delta_enemy_position_x #{delta_enemy_position_x}"
			puts "Delta_enemy_position_y #{delta_enemy_position_y}"
			puts "enemy vector #{enemy_vector}"
			puts ".................................................."
		
			#delta_position = Math.sqrt((delta_enemy_position_x)**2 + (delta_enemy_position_y)**2)
			#puts "DELTA POSITION #{delta_position}"
			
			#correction_angle = (	Math.atan2(- sensors.position.x - delta_enemy_position_x , - sensors.position.y - delta_enemy_position_y ) * (180 / (Math::PI * 2)) )
			#correction_angle = (Math.atan2(delta_position, enemy.distance, ) * 180) / Math::PI * 2
			#puts "correction angle #{correction_angle}"
			
			command.radar_heading = enemy.heading
  	  @enemy_point_prediction = RTanque::Point.new(enemyX + mod_x, enemyY + mod_y, RTanque::Arena)
  	  #p @enemy_point_prediction
  	  desired_heading = RTanque::Heading.new_between_points(mi_posicion, @enemy_point_prediction) #+ correction_angle
  	  command.turret_heading =  desired_heading
			disparo(fuego)
			
			
		else
			radar_y_torreta 
		end
  end
  

	def disparo(fuego)
		#p fuego
		command.fire(fuego) #if (sensors.turret_heading.to_degrees - @enemy_engaged.to_degrees).abs < 5
		#puts "sensors.turret_heading #{sensors.turret_heading.to_degrees}"
		#puts "enemy_engaged          #{@enemy_engaged.to_degrees}"
	end
	
	def fuego
		#RTanque::Bot::MAX_FIRE_POWER
		
			RTanque::Bot::MAX_FIRE_POWER
		
		
	end
		
	def radar_y_torreta
		disparo(RTanque::Bot::MIN_FIRE_POWER)
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

 #a := sqr(target.velocityX) + sqr(target.velocityY) - sqr(projectile_speed)
			#b := 2 * (target.velocityX * (target.startX - cannon.X)
      #    + target.velocityY * (target.startY - cannon.Y))
			#c := sqr(target.startX - cannon.X) + sqr(target.startY - cannon.Y)
			a = delta_enemy_position_x**2 + 
					delta_enemy_position_y**2
			b = 2 * (delta_enemy_position_x * (@enemy_position_old.x - sensors.position.x))
			c = (@enemy_position_old.x - sensors.position.x)**2 + 
					(@enemy_position_old.y - sensors.position.y)**2
			
			#disc := sqr(b) - 4 * a * c
			disc = b**2 - 4 * a * c 
			
			#t1 := (-b + sqrt(disc)) / (2 * a)
			#t2 := (-b - sqrt(disc)) / (2 * a)
			t1 = (-b + disc**2) / (2 * a)
			t2 = (-b - disc**2) / (2 * a)
			#aim.X := t * target.velocityX + target.startX
			#aim.Y := t * target.velocityY + target.startY
			aim_x = t2 * delta_enemy_position_x - @enemy_position_old.x
			aim_y = t2 * delta_enemy_position_y - @enemy_position_old.y
			aim = RTanque::Point.new(aim_x,aim_y, @arena)
=end

