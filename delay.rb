# delayed_server.rb
require 'socket'

# Создаем TCP-сервер, прослушивающий порт 8082
server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"

# Бесконечный цикл для обработки входящих подключений
loop do
  client = server.accept
  puts "Client connected"

  # Чтение запроса клиента (обычно первая строка HTTP-запроса)
  # Подготавливаем ответ
  response_body = "This is a delayed response from the server.\n"
  response_headers = [
    "HTTP/1.1 200 OK",
    "Content-Type: text/plain",
    "Content-Length: #{response_body.bytesize}",
    "Connection: close"  # Закрываем соединение после ответа
  ]
  response = response_headers.join("\r\n") + "\r\n\r\n" + response_body

  # Отправляем данные по частям с задержкой
  timer = 0.1
  response.each_char do |char|
#    client.write char
#    client.flush  # Принудительно отправляем данные
    client.puts char
    sleep timer     # Имитация задержки в 0.1 секунду для каждого символа
#    timer += 0.5
  end

  client.close
  puts "Client disconnected"
end

