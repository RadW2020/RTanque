# encoding: utf-8

class BringItOnâ˜‘ < RTanque::Bot::Brain
  NAME = 'BRING IT ON â˜‘'
  include RTanque::Bot::BrainHelper

  def centre
    RTanque::Point.new(arena.height / 2.0, arena.height / 2.0)
  end

  def tick!
    heading = RTanque::Heading.new_between_points(sensors.position, centre)
    command.speed = 9001
    command.turret_heading = heading
    command.fire_power = 9001
    command.heading = heading
  end
end
