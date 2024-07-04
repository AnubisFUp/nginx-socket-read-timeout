# nginx.conf: proxy_read_timeout 5s;
# curl /location_where_this_server

# в данном случае nginx отдает ответ как положено
# каждая строка response_body отправляется в отдельном пакете
# работает если вначале отправить все заголовки 
# и если задержка между пакетами не превышает таймаута в параметре выше
# то запрос отдается корректно

# этот вариант подходит под оригинальное описание proxy_read_timeout дерективы
# т.к. в ней указыавется что таймаут между двумя операциями чтения
# и вероятно 1 чтением считается получение 1 пакета или нескольких (возможно чтение 1, а пакетов в буфере несколько, ну пофакту чтение остается то одно)

require 'socket'

server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"

loop do
  client = server.accept
  puts "Client connected"

  begin
    response_body = <<~EOF
      This is a delayed response from the server.
      The response will be sent line by line.
      Each line will have a 1 second delay.
      This is the end of the response.
    EOF

    response_headers = [
      "HTTP/1.1 200 OK",
      "Content-Type: text/plain",
      "Content-Length: #{response_body.bytesize}",
      "Connection: close"  # Закрываем соединение после ответа
    ]
    response = response_headers.join("\r\n") + "\r\n\r\n"

    # Отправляем заголовки
    client.write response

    # Отправляем тело ответа построчно
    response_body.each_line do |line|
      client.write line
      sleep 3  
    end

  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  ensure
    client.close
    puts "Client disconnected"
  end
end

