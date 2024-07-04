# server.rb
require 'socket'

server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"
char = "response 0"
loop do
  client = server.accept
  
  client.write char
  client.flush

  puts "sleep 1"
  sleep 2  # Задержка для иллюстрации таймаута
  client.write char
  client.flush


  puts "sleep 2"
  sleep 2
  client.write char
  client.flush


  puts "sleep 2"
  sleep 2
  client.write char
  client.flush


  puts "sleep 2"
  sleep 2
  client.write char
  client.flush

  puts "sleep 2"
  sleep 2
  client.write char
  client.flush

  puts "sleep 2"
  sleep 2
  client.write char
  client.flush

  client.close  # Закрываем соединение
end

