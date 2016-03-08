Muy interesante, tiene buena pinta, luego habría que sacar la estadística, quizas por linux, sería interesante ver como se haría ya que yo de linux voy manejando lo justo para salir al paso.

Por cierto a mi no me va, me da este error incluso despues de crear directorio y los dos archivos:

`albertoscript: línea 10: error sintáctico cerca del elemento inesperado `done'
albertoscript: línea 10: `done'`


Yo por mi parte me aventuré a hacerlo a modo Ruby y la verdad estoy muy contento con el resultado y me ha servido para conocer el I/O que no habia tocado casi hasta ahora:

He modificado el archivo RTanque/bin/rtanque y dentro de el he añadido unas lineas al method print_runner_stats(runner) que sirve para mostrar el resultado por pantalla. Quedando así:

`def print_runner_stats(runner)
    say '='*30
    
    self.print_stats{ |table|
    	################# MODIFICADO PARA SCRIPT-STATS
    	output = File.open( "ubicación y nombre de tu archivo de estadisticas modo txt o como quieras","a+" )
    	output << runner.match.bots.map { |bot| 
    	"#{bot.health.round}" 
    	}
    	output.puts ""
    	output << runner.match.bots.map { |bot| 
    	"#{bot.name}" 
    	}
    	output.puts ""
    	output.close
        #################
      table << [set_color('Ticks', :blue), runner.match.ticks.to_s]
      table << [set_color('Survivors', :green)] + runner.match.bots.map { |bot| "#{bot.name} [#{bot.health.round}]" }
    }`

Entonces esto me va agregando datos al archivo de estadísticas, concretamente en una linea la vida del superviviente y en otra el nombre.

Por otro lado tengo un script que es el iniciador de batallas:
`echo "BIG BATTLE RTANQUE"
echo "2000 batallas con un máximo de ticks de 500.000"

for i in {1..2000}; 
	do bundle exec  bin/rtanque start --gui=false --max_ticks=500000 [[Aquí vuestros tanques]]; 
	sleep 4s
	done`

Y finalmente un codigo en Ruby que ejecuto para ver los porcentajes:
(mi tanque se llama RadW por ejemplo)

`puts " "
puts "BIG BATTLE RTANQUE STATS VIEWER"
puts "-------------------------------"

counter = 1
radW_wins = 
tanque1_wins = 
tanque2_wins = 
tanque3_wins = 0

num_tanques = 4
radW = '["RadW"]'
tanque1 = '["tanque1"]'
tanque2 = '["tanque2"]'
tanque3 = '["tanque3"]'
file = File.open("ubicación y nombre de tu archivo de estadisticas modo txt o como quieras", "r+")

while (line = file.gets)
  #puts "#{counter}: #{line}"
  counter = counter + 1
  if radW == line[0..-2] then radW_wins += 1 end
  if tanque1 == line[0..-2] then tanque1_wins += 1 end
  if tanque2 == line[0..-2] then tanque2_wins += 1 end
  if tanque3 == line[0..-2] then tanque2_wins += 1 end
end
batallas =  counter.to_f / 2 

porc_radW = ( radW_wins.to_f / batallas.to_f ) * 100
porc_tanque1 = ( tanque1_wins.to_f / batallas.to_f ) * 100
porc_tanque2 = ( tanque2_wins.to_f / batallas.to_f ) * 100
porc_tanque3 = ( tanque3_wins.to_f / batallas.to_f ) * 100

puts "RadW:    victorias: #{porc_radW.round(2)}% batallas ganadas #{radW_wins}"
puts "tanque1:  victorias: #{porc_tanque1.round(2)}% batallas ganadas #{tanque1_wins}"
puts "tanque2:  victorias: #{porc_tanque2.round(2)}% batallas ganadas #{tanque2_wins}"
puts "tanque3:  victorias: #{porc_tanque3.round(2)}% batallas ganadas #{tanque3_wins}"

puts "TOTAL BATALLAS #{batallas}"
puts "Con #{num_tanques} tanques la media sería #{100/num_tanques}%"
puts"Con una media de victorias por tanque de #{(batallas / num_tanques).round(2)}"
file.close`

Lo siguiente que quiero hacer es refactorizar todo esto para seguir la recomendacion de DRY, y que detecte automaticamente los nombres de los tanques conforme lee el archivo y mas en condiciones.

Y lo ideal seria hacer una aplicacion RoR para sacar una representación gráfica de las estadísticas. Aunque para esto aun me queda por aprender bastante por mi cuenta como hasta ahora [sic], o ganar el torneo y hacer el curso intesivo de desarrollo web de Ironhack :)
