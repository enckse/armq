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

#define IP "127.0.0.1"

using std::string;
using std::endl;
using std::cout;
using std::stringstream;
using std::ofstream;
using std::hash;
using namespace std::chrono;

/**
 * Send all data
 **/
int sendall(int s, const char *buf, size_t len)
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

string gettime() {
    return std::to_string(std::chrono::system_clock::now().time_since_epoch() / std::chrono::milliseconds(1));
}

string sendviammap(string timestamp, string data) {
#ifdef DEBUG
    cout << "send via mmap" << endl;
#endif
    hash<string> hasher;
    size_t hash = hasher(data);
    string filename = "/dev/shm/armq/" + timestamp + "." + std::to_string(hash) + ".msg";
#ifdef DEBUG
    cout << filename << endl;
#endif
    ofstream out(filename);
    if (!out.is_open()) {
        return "fileerr";
    }
    out << data;
    out.close();
    return "success";
}

string senddata(string data)
{
    if (data.length() == 0) {
        return "nullerr";
    }
#ifdef DEBUG
    cout << data << endl;
#endif
    string time = gettime();
    string sending = time + DELIMITER + VERSION + DELIMITER + data;
#ifdef DEBUG
    cout << sending << endl;
#endif

#ifdef SOCKET
    return sendviasocket(sending.c_str());
#else
    return sendviammap(time, sending);
#endif
}

/**
 * Send data
 **/
string sendviasocket(const char* d) {
#ifdef DEBUG
    cout << "send via socket" << endl;
#endif
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
    if (sendall(sockfd, d, strlen(d)) > 0)
    {
        result = "senderr";
    }

    close(sockfd);
    return result;
}

/**
 * Character identifier
 **/
char charid()
{
    return 'a' + (random() % 26);
}

string split(string strToSplit, char delimeter)
{
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
string run(const char *input)
{
    string raw = string(input);
    string function = split(raw, DELIMITER[0]);
#ifdef DEBUG
    cout << function << endl;
#endif
    if (function == "version")
    {
        return VERSION;
    }
    else
    {
        string res = senddata(raw);
#ifdef DEBUG
        cout << res << endl;
#endif
        if (function == "replay")
        {
            int seed = time(NULL);
            srand(seed);
            char a[4];
            a[0] = charid();
            a[1] = charid();
            a[2] = charid();
            a[3] = charid();
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
void RVExtension(char *output, int outputSize, const char *function)
{
    string res = run(function);
    char* buffer = (char*)malloc(100 * sizeof(char));
    snprintf(buffer, 100, "[\"ok\", %s]", res.c_str());
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
