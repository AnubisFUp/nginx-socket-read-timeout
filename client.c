#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/types.h>

#define BUFFER_SIZE 1024
#define TIMEOUT_SEC 8  // Таймаут между операциями чтения

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    fd_set read_fds;
    struct timeval timeout;
    char buffer[BUFFER_SIZE];

    // Создание сокета
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        return 1;
    }

    // Настройка параметров сервера
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(8082);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    // Установка соединения с сервером
    if (connect(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Connection failed");
        close(sockfd);
        return 1;
    }

    // Цикл для чтения данных с таймаутом
    while (1) {
        // Устанавливаем таймаут на чтение
        FD_ZERO(&read_fds);  // Очищаем множество файловых дескрипторов
        FD_SET(sockfd, &read_fds);  // Добавляем сокет в множество для чтения
        timeout.tv_sec = TIMEOUT_SEC;
        timeout.tv_usec = 0;

        // Вызов select для ожидания событий в сокетах
        int select_result = select(sockfd + 1, &read_fds, NULL, NULL, &timeout);
        if (select_result < 0) {
            perror("Select failed");
            break;
        } else if (select_result == 0) {
            printf("Read timeout occurred\n");
            break;  // Таймаут на чтение данных
        }

        // Таймаут не произошел, читаем данные
        ssize_t len = recv(sockfd, buffer, sizeof(buffer) - 1, 0);
        if (len < 0) {
            perror("Receive failed");
            break;
        } else if (len == 0) {
            printf("Server closed connection\n");
            break;  // Соединение закрыто сервером
        }

        buffer[len] = '\0';  // Добавляем завершающий нуль-символ для строки
        printf("Received: %s\n", buffer);  // Выводим полученные данные
    }

    // Закрываем сокет и завершаем программу
    close(sockfd);
    return 0;
}

