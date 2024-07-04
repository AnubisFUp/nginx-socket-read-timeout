# тут тестил отправку побуквенно
# доказывает то что вначале надо отправлять заголовки
# видимо там так обработчик работает
# или что то в http протоколе, что если за первый пакет заголовки не пришли - то пизда и таймаут
require 'socket'

server = TCPServer.new('127.0.0.1', 8082)
puts "Server starts"

loop do
  client = server.accept
  puts "Client connected"

  begin
    response_body = <<~EOF
      This is a delayed response from the server.
    EOF

    response_headers = [
      "HTTP/1.1 200 OK",
      "Content-Type: text/plain",
      "Content-Length: #{response_body.bytesize}",
      "Connection: close"  # Закрываем соединение после ответа
    ]
    response = response_headers.join("\r\n") + "\r\n\r\n" 
    # Шлем заголовки
    client.write response
    # Отправляем каждый символ по отдельности
    response_body.each_char do |char|
      client.write(char)  
      puts "Send: #{char}"
      sleep 0.5 # суммарно время ответа выходит больше 5 секунд из-за длины строки 
      # значит он считает таймаут между tcp пакетами
    end

  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  ensure
    client.close
    puts "Client disconnected"
  end
end

