# server.rb
require 'socket'

server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"

loop do
  client = server.accept

  client.puts "HTTP/1.1 200 OK"

  puts "sleep 2"
  sleep 2  # Задержка для иллюстрации таймаута

  client.puts "Content-Type: text/plain"

  puts "sleep 2"
  sleep 2

  client.puts "Header: test test"

  puts "sleep 2"
  sleep 2

  client.puts "Hello syka"
  client.puts "\n"

  client.close  # Закрываем соединение
end

