# server.rb
require 'socket'

server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"

loop do
  client = server.accept
#  request = client.gets  # Чтение HTTP-запроса (обычно первая строка запроса)
#  puts request  # Печать первой строки запроса для отладки

  # Подготавливаем HTTP/1.1 ответ
  response_body = "Response from server"
  response_headers = [
    "HTTP/1.1 200 OK",
    "Content-Type: text/plain",
    "Content-Length: #{response_body.bytesize}",
    "Connection: close"  # Закрываем соединение после ответа
  ]

  response = response_headers.join("\r\n") + "\r\n\r\n" + response_body

#  sleep 5  # Задержка для иллюстрации таймаута

  client.puts response  # Отправляем ответ
  sleep 100
  client.puts response  # Отправляем ответ
#  client.close  # Закрываем соединение
end
