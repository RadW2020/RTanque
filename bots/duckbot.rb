class Duckbot < RTanque::Bot::Brain
  NAME = 'duckbot'
  include RTanque::Bot::BrainHelper

  def tick!
    command.speed = 20
    # command.heading = Math::PI/2.0
    command.fire(1)
    # command.radar_heading = Math::PI / 2.0
    # command.turret_heading = Math::PI / 2.0

    if @target_tank_heading
      command.radar_heading = sensors.radar_heading + MAX_RADAR_ROTATION
      command.turret_heading = @target_tank_heading + sensors.heading
      command.heading = @target_tank_heading
    else
      # command.radar_heading = sensors.radar_heading + Math::PI/2.0
      command.radar_heading = sensors.radar_heading + MAX_RADAR_ROTATION
      command.turret_heading = sensors.heading + RTanque::Heading::HALF_ANGLE
      command.heading = MAX_RADAR_ROTATION
    end

    puts "tank found! tick: #{sensors.ticks}" if @target_tank_heading
		puts ": #{sensors.radar.to_a}" if @target_tank_heading

      

    sensors.radar.each do |tank|
      @target_tank_heading = tank.heading
    end


#    if sensors.radar
#       sensors.radar.each do |tank|
#          command.heading = tank.heading
#          command.turret_heading = tank.heading
#          puts tank.inspect
#         @target_tank_heading ||= tank.heading
#       end
#     else
#       @target_tank_heading = nil
#     end

    # sensors

    # command


    ## main logic goes here
    
    # use self.sensors to detect things
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Sensors
    
    # use self.command to control tank
    # See http://rubydoc.info/github/awilliams/RTanque/master/RTanque/Bot/Command
    
    # self.arena contains the dimensions of the arena
    # See http://rubydoc.info/github/awilliams/RTanque/master/frames/RTanque/Arena
  end
end



