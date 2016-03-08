class PuppyKittyTron < RTanque::Bot::Brain
NAME = 'Puppy Kitty TRON (who will eat your greasy soul for breakfast, and then puke later)'
include RTanque::Bot::BrainHelper
 
def tick!
command.speed = MAX_BOT_SPEED
command.fire MIN_FIRE_POWER
command.heading = sensors.heading + 0.03
command.turret_heading = sensors.turret_heading - 0.05
end
end 
