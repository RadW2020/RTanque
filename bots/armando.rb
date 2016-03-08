class Predictor
  attr_accessor :ticks, :enemies, :bot

  def initialize bot
    @ticks = 0
    @enemies = {}
    @bot = bot
  end

  def predict_coordinates &b
    pick_enemy do |info|
      time = shell_time info.distances.last
      yield NewtonCalc.cuadratic_approximation [-2,-1,0], info.coordinates[-3..-1], time
    end
  end

  def process_info reflection
    info = enemy_info reflection
    info.process reflection, ticks
  end

  def tick
    @enemies.delete_if do |name,enemy_info|
      enemy_info.last_updated < @ticks
    end
    @ticks += 1
  end

  private

  def enemy_info reflection
    @enemies[reflection.name] ||= EnemyInfo.new(bot,reflection)
  end

  def shell_time distance
    shell_speed = fire_power*RTanque::Shell::SHELL_SPEED_FACTOR
    distance/shell_speed
  end

  def fire_power
    5
  end

  def pick_enemy &b
    info = @enemies.values.last #designed for only 1 enemy, so get the last EnemyInfo
    yield info if info and info.coordinates.count >= 3 # need at least 3 observations to make a cuadratic approx.
  end
end


class EnemyInfo
  attr_accessor :name, :headings, :distances, :last_updated, :bot, :coordinates

  def initialize bot, reflection
    @name = reflection.name
    @headings = []
    @distances = []
    @coordinates = []
    @last_updated = 0
    @bot = bot
  end

  def process reflection, ticks
    headings << reflection.heading
    distances << reflection.distance
    coordinates << enemy_coordinates(reflection)
    @last_updated = ticks
  end

  def enemy_coordinates reflection
    Coordinates.new_from_polars(reflection.heading.to_f, reflection.distance) + bot.sensors.position
  end
end


class Maneuverer
  include Math
  include RTanque

  MAX_ROTATION = RTanque::Heading::ONE_DEGREE * 1.5
  MAX_SPEED = 3

  DIRECTION_CHANGE_INTERVAL = 40
  DESTINATION_CHANGE_INTERVAL = 120

  attr_accessor :bot

  def initialize bot
    @bot = bot
    @last_changed_destination = -9999
    @last_changed_direction = -9999
    @direction_modifier = 0
    @destination = Coordinates.new(0,0)
  end

  def maneuver enemy = nil
    @enemy = enemy
    generate_destination if should_change_destination?
    zigzag_direction if should_change_direction?
    command.heading = direction
    command.speed = MAX_SPEED
  end

  private

  def direction
    base_direction + @direction_modifier
  end

  def base_direction
    Heading.new((@destination - sensors.position).angle)
  end

  def sensors
    bot.sensors
  end

  def command
    bot.command
  end

  def zigzag_direction
    @cycler ||= [-1,2].cycle
    @direction_modifier = ((rand+0.5) * PI/8) * @cycler.next
  end

  def generate_destination
    width = bot.arena.width
    height = bot.arena.height
    @destination = Coordinates.new(rand * width, rand * height)
    while distance_to_destination(sensors.position) < 500 do
      @destination = Coordinates.new(rand * width, rand * height)
    end
  end

  def distance_to_destination pos
    (@destination - pos).modulus
  end

  def should_change_direction?
    if sensors.ticks - @last_changed_direction > DIRECTION_CHANGE_INTERVAL
      @last_changed_direction = sensors.ticks
    end
  end

  def should_change_destination?
    if sensors.ticks - @last_changed_destination > DESTINATION_CHANGE_INTERVAL
      @last_changed_destination = sensors.ticks
    end
  end

end


class Coordinates < RTanque::Point
  def initialize x, y
    super(x.to_f, y.to_f)
  end

  def +(coord)
    Coordinates.new(x + coord.x, y + coord.y)
  end

  def -(coord)
    Coordinates.new(x - coord.x, y - coord.y)
  end

  def *(number)
    Coordinates.new(x * number, y * number)
  end

  def /(number)
    Coordinates.new(x/number, y/number)
  end

  def angle
    Math.atan2(x,y)
  end

  def modulus
    Math.sqrt(x * x + y * y)
  end

  def self.new_from_polars angle, radius
    angle -= Math::PI/2
    angle *= -1
    self.new(radius * Math.cos(angle), radius * Math.sin(angle))
  end
end

module NewtonCalc

  #ts: valores de la variable independiente
  #ys: valores de la imagen en t
  #t: valor de la variable independiente para evaluar la aproximacion
  def self.cuadratic_approximation ts, ys, t
    t0,t1,t2 = ts
    y0,y1,y2 = ys

    b1 = (y1 - y0) / (t1 - t0)
    b2 = (y2 - y1) / (t2 - t1)
    b3 = (b2 - b1) / (t2 - t0)

    prediccion = y0 + b1 * (t - t0) + b3 * (t - t0) * (t - t1)
  end
end


class Armando < RTanque::Bot::Brain

  include RTanque
  include Math
  include Bot::BrainHelper

  NAME = 'Armando'
  ONE_DEGREE = Heading::ONE_DEGREE

  def initialize params
    super
    @predictor ||= Predictor.new(self)
    @maneuverer ||= Maneuverer.new(self)
  end

  def tick!
    tick_predictor
    move_radar
    search_enemies do |enemy|
      @predictor.process_info enemy
      @aim_lock = enemy
    end
    shoot
    evade
  end

  def tick_predictor
    @predictor.tick
  end

  def evade
    @maneuverer.maneuver @aim_lock
  end

  def aim &b
    @predictor.predict_coordinates do |prediction|
      aiming_vector = prediction - sensors.position
      yield Heading.new(aiming_vector.angle)
    end
  end

  def shoot
    aim do |heading|
      command.turret_heading = heading
      angle_delta = sensors.turret_heading.delta(heading).abs
      if angle_delta < 0.05
        command.fire 5
      end
    end
  end

  def move_radar
    if @aim_lock
      command.radar_heading = @aim_lock.heading
    else
      command.radar_heading = sensors.radar_heading + ONE_DEGREE * 10
      command.turret_heading = sensors.radar_heading
    end
  end

  def search_enemies &b
    @aim_lock = nil
    sensors.radar.find {|r| yield r}
  end
end
