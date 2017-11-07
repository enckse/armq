#include <string.h>
#include <arpa/inet.h> 
#include <unistd.h>

#define IP "127.0.0.1"
#define SUCCESS "SUCCESS"
#define SOCKET_ERROR "SOCKET"
#define INET_ERROR "INET"
#define CONN_ERROR "CONNECT"
#define SEND_ERROR "SEND"

/**
 * Send all data
 **/
int sendall(int s, char *buf, size_t len)
{
    size_t total = 0;
    size_t bytesleft = len;
    size_t n;
    int errors = 0;

    while(total < len) {
        n = send(s, buf+total, bytesleft, 0);
        if (n < 0)
        { errors++; break; }
        total += n;
        bytesleft -= n;
    }

    return errors;
} 

/**
 * Send data
 **/
char* senddata(const char* data)
{
    int sockfd = 0, n = 0;
    char recvBuff[1024];
    struct sockaddr_in serv_addr; 

    memset(recvBuff, '0',sizeof(recvBuff));
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        return SOCKET_ERROR;
    } 

    memset(&serv_addr, '0', sizeof(serv_addr)); 
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT); 

    if(inet_pton(AF_INET, IP, &serv_addr.sin_addr)<=0)
    {
        return INET_ERROR;
    } 

    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       return CONN_ERROR;
    }
    if (sendall(sockfd, "test", sizeof("test")) > 0) {
        return SEND_ERROR;
    }
    close(sockfd);
    return SUCCESS;
}

/**
 * ARMA3 extension
 **/
void RVExtension(char *output, int outputSize, const char *function)
{
    if (!strcmp(function, "version"))
    {
        strncpy(output, VERSION, outputSize);
    }
    else
    {
        char* res = senddata(function);
        strncpy(output, res, outputSize);
    }
    output[outputSize-1]='\0';

    return;
}
