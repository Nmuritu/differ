#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <stdlib.h>

#define PORT 60000
#define BUFFER_SIZE 1024000

int main() {
    int server_sock, client_sock;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len;
    char buffer[BUFFER_SIZE];

    server_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sock < 0) {
        perror("Socket creation failed");
        return 1;
    }

    int optval = 1;
    if (setsockopt(server_sock, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)) < 0) {
        perror("setsockopt failed");
        close(server_sock);
        return 1;
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    server_addr.sin_port = htons(PORT);

    if (bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        close(server_sock);
        return 1;
    }

    if (listen(server_sock, 5) < 0) {
        perror("Listen failed");
        close(server_sock);
        return 1;
    }

    printf("C backend server listening on 127.0.0.1:%d...\n", PORT);

    addr_len = sizeof(client_addr);
    while(1) {
        client_sock = accept(server_sock, (struct sockaddr *)&client_addr, &addr_len);
        if (client_sock < 0) {
            perror("Accept failed");
            continue;
        }

        printf("Client connected\n");

        ssize_t bytes_received;
        while ((bytes_received = recv(client_sock, buffer, BUFFER_SIZE-1, 0)) > 0) {
            buffer[bytes_received] = '\0';
            printf("Received command: %s\n", buffer);

            // Echo back or run commands and send response:
            // For simplicity, echoing back the command with confirmation
            char response[BUFFER_SIZE + 50];
            snprintf(response, sizeof(response), "C Server received: %s\n", buffer);

            send(client_sock, response, strlen(response), 0);
        }

        if (bytes_received == 0) {
            printf("Client disconnected\n");
        } else if (bytes_received < 0) {
            perror("Recv failed");
        }

        close(client_sock);
    }

    close(server_sock);
    return 0;
}