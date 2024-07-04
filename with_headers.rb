# когда пытаюсь отправить все тело ответа последовательно, где каждый пакет 
# отправляет 1 строчку ответа, то данный случай не работает, даже если таймаут между пакетами
# ниже чем в директиве таймаута 
# <center><h1>504 Gateway Time-out</h1></center> :(

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
      "Connection: close"  
    ]
    response = response_headers.join("\r\n") + "\r\n\r\n" + response_body

    # Отправляем тело ответа построчно
    response.each_line do |line|
      client.write line
      sleep 3  # Задержка между строками тела
    end

  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  ensure
    client.close
    puts "Client disconnected"
  end
end

