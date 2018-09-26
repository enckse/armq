#include <string.h>
#include <arpa/inet.h> 
#include <unistd.h>
#include <string>
#include <iostream>
#include <vector>
#include <sstream>
#include <chrono>
#include <fstream>
#include <unordered_map>
#include "client.h"

#ifdef DEBUG
# define debug(x) cout << x << endl;
#else
# define debug(x)
#endif

#define IP "127.0.0.1"

using std::string;
using std::endl;
using std::cout;
using std::stringstream;
using std::ofstream;
using std::hash;
using namespace std::chrono;

/**
 * Send all data over a socket
 **/
int sendSocket(int s, const char *buf, size_t len) {
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
 * Get the time, in milliseconds, since the epoch
 **/
string getTime() {
    return std::to_string(std::chrono::system_clock::now().time_since_epoch() / std::chrono::milliseconds(1));
}

/**
 * Send via dev shm (memory/tmpfs)
 **/
string useDevShm(string timestamp, string data) {
    debug("send via /dev/shm");
    hash<string> hasher;
    size_t hash = hasher(data);
    string filename = "/dev/shm/armq/" + timestamp + "." + std::to_string(hash) + ".msg";
    debug(filename);
    ofstream out(filename);
    if (!out.is_open()) {
        return "fileerr";
    }
    out << data;
    out.close();
    return "success";
}

/**
 * Send data via sockets
 **/
string useSocket(const char* d) {
    debug("send via socket");
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
        close(sockfd);
        return "ineterr";
    } 

    if( connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        close(sockfd);
        return "connerr";
    }

    string result = "success";
    if (sendSocket(sockfd, d, strlen(d)) > 0)
    {
        result = "senderr";
    }

    close(sockfd);
    return result;
}

/**
 * Sends data out via the built method (not configured at runtime)
 **/
string sendData(string data) {
    if (data.length() == 0) {
        return "nullerr";
    }
    debug(data);
    string time = getTime();
    string sending = time + DELIMITER + VERSION + DELIMITER + data;
    debug(sending);

#ifdef SOCKET
    return useSocket(sending.c_str());
#else
    return useDevShm(time, sending);
#endif
}


/**
 * Character identifier
 **/
char charId() {
    return 'a' + (random() % 26);
}

/**
 * Split a string and get the first element
 **/
string splitFirst(string strToSplit, char delimeter) {
    if (strToSplit.length() == 0) {
        return "";
    }
    stringstream ss(strToSplit);
    string item;
    std::vector<string> splittedStrings;
    while (std::getline(ss, item, delimeter))
    {
       splittedStrings.push_back(item);
    }
    return splittedStrings[0];
}

/**
 * Run the command
 **/
string run(const char *input) {
    string raw = string(input);
    string function = splitFirst(raw, DELIMITER[0]);
    debug(function);
    if (function == "version")
    {
        return VERSION;
    }
    else
    {
        string res = sendData(raw);
        debug(res);
        if (function == "replay")
        {
            int seed = time(NULL);
            srand(seed);
            char a[4];
            for (int i = 0; i < 4; i++) {
                a[i] = charId();
            }
            return "\"" + string(a) + "\"";
        }
        else
        {
            return "\"\"";
        }
    }
}

extern "C" {
    void RVExtension(char *output, int outputSize, const char *function);
}

/**
 * ARMA3 extension
 **/
void RVExtension(char *output, int outputSize, const char *function) {
    string res = run(function);
    char* buffer = (char*)malloc(100 * sizeof(char));
    snprintf(buffer, 100, "[\"ok\", %s]", res.c_str());
    strncpy(output, buffer, outputSize);
    output[outputSize-1]='\0';
    free(buffer);
    return;
}

#ifdef HARNESS
int main(int argc, char *argv[]) {
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
