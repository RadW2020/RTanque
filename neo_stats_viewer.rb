puts " "
puts "BIG BATTLE RTANQUE STATS VIEWER"
puts "------#{Time.now}---------"

line_counter = 0

File.readlines("/home/radw/RTanque/outputSTATS.txt").each do |line|


=begin
create method warrior.name
create method warrior.name.wins
create method warrior.name.victory_ratio
create method warrior.name.half_life
create method puts allinfo
=end





life_monger_array = 
a = []
half_life_monger = 0
monger_wins = 
armando_wins = 
marksman_wins = 
#gbot_wins = 
monger_circulos_wins = 
medusa_wins =
seek_wins = 0

num_tanques = 6
monger_name = 'Monger'
armando_name = 'Armando'
marksman_name = 'Marksman'
#gbot_name = 'GBot'
monger_circulos = 'Monger_Circulos'
medusa_name = 'Medusa'
seek_name = 'Seek&Destroy'

File.readlines("/home/radw/RTanque/outputSTATS.txt").each do |line|
	counter = counter + 1
	a << line
  if monger_name == line[0..-2] then 
  	monger_wins += 1
  	half_life_monger += a[-2].to_f
  end
  
  if armando_name == line[0..-2] then armando_wins += 1 end
  if marksman_name == line[0..-2] then marksman_wins += 1 end
  if monger_circulos == line[0..-2] then monger_circulos_wins += 1 end
  #if gbot_name == line[0..-2] then gbot_wins += 1 end
  if medusa_name == line[0..-2] then medusa_wins += 1 end
  if seek_name == line[0..-2] then seek_wins += 1 end
end

batallas =  counter.to_f / 2 


porc_monger = ( monger_wins.to_f / batallas.to_f ) * 100
porc_arman = ( armando_wins.to_f / batallas.to_f ) * 100
porc_marks = ( marksman_wins.to_f / batallas.to_f ) * 100
#porc_gbot = ( gbot_wins.to_f / batallas.to_f ) * 100
porc_circ = ( monger_circulos_wins.to_f / batallas.to_f ) * 100
porc_medusa = ( medusa_wins.to_f / batallas.to_f ) * 100
porc_seek = ( seek_wins.to_f / batallas.to_f ) * 100
print "Monger:   victorias: #{porc_monger.round(2)}% - #{monger_wins}"
puts " y vida media supervivencia de #{(half_life_monger / monger_wins).round(2)}"

puts "Armando:  victorias: #{porc_arman.round(2)}% - #{armando_wins}"
puts "Marksman: victorias: #{porc_marks.round(2)}% - #{marksman_wins}"
#puts "GBot:     victorias: #{porc_gbot.round(2)}% - #{gbot_wins}"
puts "Circulos: victorias: #{porc_circ.round(2)}% - #{monger_circulos_wins}"
puts "Medusa:   victorias: #{porc_medusa.round(2)}% - #{medusa_wins}"
puts "Seek&Des: victorias: #{porc_seek.round(2)}% - #{seek_wins}"

puts "TOTAL BATALLAS #{batallas}"
puts "Con #{num_tanques} tanques la media de victorias sería #{100/num_tanques}%"
puts"Con una media de victorias por tanque de #{(batallas / num_tanques).round(2)}"
