puts " "
puts "BIG BATTLE RTANQUE STATS VIEWER"
puts "-------------------------------"

counter = 0
half_life_arr = []
monger_wins = 
armando_wins = 
marksman_wins = 
gbot_wins = 
medusa_wins = 
seek_wins = 0

num_tanques = 6
monger_name = '["Monger"]'
armando_name = '["Armando"]'
marksman_name = '["Marksman"]'
gbot_name = '["GBot"]'
medusa_name = '["Medusa"]'
seek_name = '["Seek&Destroy"]'
file = File.open("/home/radw/RTanque/outputSTATS.yml", "r+")
a = IO.readlines("/home/radw/RTanque/outputSTATS.yml")

while (line = file.gets)
  #puts "#{counter}: #{line}"
  counter = counter + 1
  if monger_name == line[0..-2] then 
  	monger_wins += 1 
  	
  end
  if armando_name == line[0..-2] then armando_wins += 1 end
  if marksman_name == line[0..-2] then marksman_wins += 1 end
  if gbot_name == line[0..-2] then gbot_wins += 1 end
  if medusa_name == line[0..-2] then medusa_wins += 1 end
  if seek_name == line[0..-2] then seek_wins += 1 end
end
batallas =  counter.to_f / 2 


porc_monger = ( monger_wins.to_f / batallas.to_f ) * 100
porc_arman = ( armando_wins.to_f / batallas.to_f ) * 100
porc_marks = ( marksman_wins.to_f / batallas.to_f ) * 100
porc_gbot = ( gbot_wins.to_f / batallas.to_f ) * 100
porc_medusa = ( medusa_wins.to_f / batallas.to_f ) * 100
porc_seek = ( seek_wins.to_f / batallas.to_f ) * 100
puts "Monger:   victorias: #{porc_monger.round(2)}% batallas ganadas #{monger_wins}"
puts "Armando:  victorias: #{porc_arman.round(2)}% batallas ganadas #{armando_wins}"
puts "Marksman: victorias: #{porc_marks.round(2)}% batallas ganadas #{marksman_wins}"
puts "GBot:     victorias: #{porc_gbot.round(2)}% batallas ganadas #{gbot_wins}"
puts "Medusa:   victorias: #{porc_medusa.round(2)}% batallas ganadas #{medusa_wins}"
puts "Seek&Des: victorias: #{porc_seek.round(2)}% batallas ganadas #{seek_wins}"

puts "TOTAL BATALLAS #{batallas}"
puts "Con #{num_tanques} tanques la media sería #{100/num_tanques}%"
puts"Con una media de victorias por tanque de #{(batallas / num_tanques).round(2)}"
file.close

=begin
	puts "monger_name.class #{monger_name.class}"
  puts "monger_name #{monger_name}"
  puts "monger_name.inspect #{monger_name.inspect}"
  puts "#{monger_name == line}"
  puts "line.class #{line.class}"
  puts "line #{line}"
  puts "line.inspect #{line.inspect}"
  puts " "  
  
  
  BIG BATTLE RTANQUE STATS VIEWER
-------------------------------
Monger:   victorias: 32.86% batallas ganadas 196
Armando:  victorias: 45.1% batallas ganadas 269
Marksman: victorias: 6.04% batallas ganadas 36
GBot:     victorias: 0.84% batallas ganadas 5
TOTAL BATALLAS 596.5
Con 6 tanques la media sería 16%
Con una media de victorias por tanque de 99.42

BIG BATTLE RTANQUE STATS VIEWER
-------------------------------
Monger:   victorias: 32.32% batallas ganadas 219
Armando:  victorias: 45.31% batallas ganadas 307
Marksman: victorias: 6.35% batallas ganadas 43
GBot:     victorias: 0.89% batallas ganadas 6
TOTAL BATALLAS 677.5
Con 6 tanques la media sería 16%
Con una media de victorias por tanque de 112.92
radw@LapTop:~/RTanque$ ruby stats_viewer.rb
 
BIG BATTLE RTANQUE STATS VIEWER
-------------------------------
Monger:   victorias: 31.48% batallas ganadas 794
Armando:  victorias: 44.28% batallas ganadas 1117
Marksman: victorias: 6.54% batallas ganadas 165
GBot:     victorias: 1.31% batallas ganadas 33
TOTAL BATALLAS 2522.5
Con 6 tanques la media sería 16%
Con una media de victorias por tanque de 420.42

BIG BATTLE RTANQUE STATS VIEWER
-------------------------------
Monger:   victorias: 59.1% batallas ganadas 1184
Armando:  victorias: 23.31% batallas ganadas 467
Marksman: victorias: 2.85% batallas ganadas 57
GBot:     victorias: 1.35% batallas ganadas 27
Medusa:   victorias: 6.44% batallas ganadas 129
Seek&Dest:victorias: 6.69% batallas ganadas 134
TOTAL BATALLAS 2003.5
Con 6 tanques la media sería 16%
Con una media de victorias por tanque de 333.92


=end
