#include <string.h>
#include <arpa/inet.h> 
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>

using std::string;

// IP address (localhost, no network latency)
#define IP "127.0.0.1"
#define VERSION "1.0.0"

// adc  specific data points
#define DELIMITER "`"
#define TIME_FORMAT DELIMITER "%Y-%m-%d-%H-%M-%S" DELIMITER VERSION
#define REPLAY "replay"

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
string senddata(char* data)
{
    int sockfd = 0;
    int n = 0;
    struct sockaddr_in serv_addr; 
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        return "sockerr";
    } 

    memset(&serv_addr, '0', sizeof(serv_addr)); 
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT); 
    if(inet_pton(AF_INET, IP, &serv_addr.sin_addr) <= 0)
    {
        return "ineterr";
    } 

    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
       return "connerr";
    }

#ifdef DEBUG
    printf("%s\n", data);
#endif
    if (sendall(sockfd, data, strlen(data)) > 0)
    {
        return "senderr";
    }

    time_t     now;
    struct tm  ts;
    char       buf[80];
    time(&now);
    ts = *localtime(&now);
    strftime(buf, sizeof(buf), TIME_FORMAT, &ts);
#ifdef DEBUG
    printf("%s\n", buf);
#endif
    if (sendall(sockfd, buf, strlen(buf)) > 0)
    {
        return "metaerr";
    }

    close(sockfd); 
    return "success";
}

/**
 * Character identifier
 **/
char charid()
{
    return 'a' + (random() % 26);
}

/**
 * Run the command
 **/
string run(const char *input)
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
        string res = senddata(strdup(input));
#ifdef DEBUG
        printf("%s\n", res);
#endif
        if (!strcmp(function, REPLAY))
        {
            int seed = time(NULL);
            srand(seed);
            char* buf = (char*)malloc(5 * sizeof(char));
            snprintf(buf,
                     10,
                     "\"%c%c%c%c\"",
                     charid(), charid(), charid(), charid());
            return buf;
        }
        else
        {
            return "\"\"";
        }
    }
}

void RVExtensionVersion(char *output, int outputSize)
{
	strncpy(output, VERSION, outputSize - 1);
}

int RVExtensionArgs(char *output, int outputSize, const char *function, const char **argv, int argc)
{
    return 0;
}

/**
 * ARMA3 extension
 **/
void RVExtension(char *output, int outputSize, const char *function)
{
    string res = run(function);
    char* buffer = (char*)malloc(100 * sizeof(char));
    snprintf(buffer, 100, "[\"ok\", %s]", res);
    strncpy(output, buffer, outputSize);
    output[outputSize-1]='\0';
    free(buffer);
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
    free(buffer);
}
#endif
