#include <string.h>
#include <arpa/inet.h> 
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

// IP address (localhost, no network latency)
#define IP "127.0.0.1"

// Return strings from sending
#define SUCCESS "SUCCESS"
#define SOCKET_ERROR "SOCKET"
#define INET_ERROR "INET"
#define CONN_ERROR "CONNECT"
#define SEND_ERROR "SEND"

// R3 specific data points
#define DELIMITER "`"
#define R3_EMPTY "\"\""
#define R3_DELIMIT "\"" DELIMITER "\""
#define R3_TRUE "true"
#define R3_UNKNOWN "\"unknown\""
#define R3_REPLAY "\"r3replay\""

/**
 * Send all data
 **/
int sendall(int s, char *buf, size_t len)
{
    size_t total = 0;
    size_t left = len;
    size_t n;
    int errors = 0;
    while(total < len)
    {
        n = send(s, buf+total, left, 0);
        if (n < 0)
        {
            errors++;
            break;
        }

        total += n;
        left -= n;
    }

    return errors;
} 

/**
 * Send data
 **/
char* senddata(char* data)
{
    int sockfd = 0;
    int n = 0;
    struct sockaddr_in serv_addr; 
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        return SOCKET_ERROR;
    } 

    memset(&serv_addr, '0', sizeof(serv_addr)); 
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT); 
    if(inet_pton(AF_INET, IP, &serv_addr.sin_addr) <= 0)
    {
        return INET_ERROR;
    } 

    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       return CONN_ERROR;
    }

    if (sendall(sockfd, data, sizeof("test")) > 0)
    {
        return SEND_ERROR;
    }

    close(sockfd);
    return SUCCESS;
}

/**
 * Run the command
 **/
char* run(const char *input)
{
    char* function = strdup(input);
    if (strstr(function, DELIMITER) != NULL)
    {
        char* token;
        while ((token = strsep(&function, DELIMITER)) != NULL)
        {
            function = token;
            break;
        }
    }

    if (!strcmp(function, "version"))
    {
        return VERSION;
    }
    else
    {
        char* res = senddata(function);
#ifdef DEBUG
        printf("%s\n", res);
#endif

        if (!strcmp(function, "connect"))
        {
            return R3_TRUE;
        }
        else
        {
            if (!strcmp(function, "separator"))
            {
                return R3_DELIMIT;
            }
            else
            {
                if (!strcmp(function, "replay"))
                {
                    return R3_REPLAY;
                }
                else
                {
                    int capture = 0;
                    if (strcmp(function, "player"))
                    {
                        if (strcmp(function, "event"))
                        {
                            capture = 1;
                        }
                    }

                    if (capture == 0)
                    {
                        return R3_EMPTY;
                    }
                }
            }
        }
    }

    return R3_UNKNOWN;
}

/**
 * ARMA3 extension
 **/
void RVExtension(char *output, int outputSize, const char *function)
{
    char* res = run(function);
    char* buffer = (char*)malloc(100 * sizeof(char));
    snprintf(buffer, 100, "[\"ok\", %s]", res);
    strncpy(output, buffer, outputSize);
    output[outputSize-1]='\0';
    return;
}

#ifdef HARNESS
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("argument required\n");
        return 1;
    }

    char* buffer = (char*)malloc(100 * sizeof(char));
    RVExtension(buffer, 100, argv[1]);
    printf("%s\n", buffer);
}
#endif
