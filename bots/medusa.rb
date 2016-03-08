# Silly Tank built for the Madrid.rb RTanque duel
# Author: @xuanxu
 
class Medusa < RTanque::Bot::Brain
  NAME = 'Medusa'
  include RTanque::Bot::BrainHelper
 
  def tick!
    move_to_destination
 
    if (target = self.nearest_target)
      self.fire_upon(target)
    else
      self.detect_targets
    end
  end
 
  def fire_upon(target)
    self.command.radar_heading = target.heading
    self.command.turret_heading = target.heading
    self.command.fire(MAX_FIRE_POWER)
  end
 
  def nearest_target
    self.sensors.radar.min { |a,b| a.distance <=> b.distance }
  end
 
  def detect_targets
    self.command.radar_heading = self.sensors.radar_heading + MAX_RADAR_ROTATION
    self.command.turret_heading = self.sensors.heading + RTanque::Heading::HALF_ANGLE
  end
 
  def destination_points
    @up    ||= RTanque::Point.new(self.arena.width/2.0, self.arena.height, self.arena)
    @left  ||= RTanque::Point.new(0, self.arena.height/2.0, self.arena)
    @rigth ||= RTanque::Point.new(self.arena.width, self.arena.height/2.0, self.arena)
    @down  ||= RTanque::Point.new(self.arena.width/2.0, 0, self.arena)
    [@up, @left, @down, @rigth]
  end
 
  def destination_point_cycle
    @destination_point_cycle ||= Hash[ destination_points.zip(destination_points.rotate) ]
  end
 
  def inverse_destination_point_cycle
    @inverse_destination_point_cycle ||= destination_point_cycle.invert
  end
 
  def current_destination
    @current_destination ||= destination_points.first
  end
 
  def update_destination
    @current_destination = (rand < 0.87 ? destination_point_cycle[@current_destination] : inverse_destination_point_cycle[@current_destination])
  end
 
  def move_to_destination
    if self.sensors.position.distance(current_destination) < 10
      update_destination
    end
 
    command.heading = self.sensors.position.heading(current_destination)
    command.speed = MAX_BOT_SPEED
  end
 
end