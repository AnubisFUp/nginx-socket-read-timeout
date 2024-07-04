#!/usr/bin/python3
import socket
import time

# Создаем TCP-сервер, прослушивающий порт 8082
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('127.0.0.1', 8082))
server.listen(5)  # Поддерживаем до 5 ожидающих клиентов

print("Server starts")

while True:
    client, addr = server.accept()
    print(f"Client connected: {addr}")

    # Чтение запроса клиента (обычно первая строка HTTP-запроса)
    # Подготавливаем ответ
    response_body = "This is a delayed response from the server.\n"
    response_headers = [
        "HTTP/1.1 200 OK",
        "Content-Type: text/plain",
        f"Content-Length: {len(response_body)}",
        "Connection: close"  # Закрываем соединение после ответа
    ]
    response = "\r\n".join(response_headers) + "\r\n\r\n" + response_body

    # Отправляем данные по частям с задержкой
    timer = 0.1
    for char in response:
        client.sendall(char.encode())  # Отправляем символ
        time.sleep(timer)
        # timer += 0.5  # Раскомментируйте, чтобы увеличить задержку по времени

    client.close()
    print("Client disconnected")
