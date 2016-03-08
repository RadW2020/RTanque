puts " "
puts "BIG BATTLE RTANQUE STATS VIEWER"
puts "------#{Time.now}---------"

counter = 0
life_monger_arr = 
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
=begin
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
=end
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
#file.close

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

BIG BATTLE RTANQUE STATS VIEWER
------2015-02-23 00:04:03 +0100---------
Monger:   victorias: 61.24% batallas 188 y vida media supervivencia de 38.18
Armando:  victorias: 18.24% batallas 56
Marksman: victorias: 2.93% batallas 9
GBot:     victorias: 0.98% batallas 3
Medusa:   victorias: 9.12% batallas 28
Seek&Des: victorias: 7.49% batallas 23
TOTAL BATALLAS 307.0
Con 6 tanques la media de victorias sería 16%
Con una media de victorias por tanque de 51.

BIG BATTLE RTANQUE STATS VIEWER
------2015-02-23 07:53:16 +0100---------
Monger:   victorias: 61.54% - 624 y vida media supervivencia de 36.63
Armando:  victorias: 21.2% - 215
Marksman: victorias: 2.56% - 26
GBot:     victorias: 2.37% - 24
Medusa:   victorias: 5.72% - 58
Seek&Des: victorias: 6.61% - 67
TOTAL BATALLAS 1014.0
Con 6 tanques la media de victorias sería 16%
Con una media de victorias por tanque de 169.0

BIG BATTLE RTANQUE STATS VIEWER
------2015-02-23 18:05:54 +0100---------
Monger:   victorias: 37.0% - 37 y vida media supervivencia de 29.36
Armando:  victorias: 2.0% - 2
Marksman: victorias: 1.0% - 1
Circulos: victorias: 59.0% - 59
Medusa:   victorias: 1.0% - 1
Seek&Des: victorias: 0.0% - 0
TOTAL BATALLAS 100.0
Con 6 tanques la media de victorias sería 16%
Con una media de victorias por tanque de 16.67

BIG BATTLE RTANQUE STATS VIEWER
------2015-02-24 01:08:48 +0100---------
Monger:   victorias: 30.19% - 32 y vida media supervivencia de 29.96
Armando:  victorias: 7.55% - 8
Marksman: victorias: 0.94% - 1
Circulos: victorias: 54.72% - 58
Medusa:   victorias: 0.94% - 1
Seek&Des: victorias: 5.66% - 6
TOTAL BATALLAS 106.0
Con 6 tanques la media de victorias sería 16%
Con una media de victorias por tanque de 17.67




=end
