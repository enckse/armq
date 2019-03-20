#include <arpa/inet.h> 
#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <string.h>
#include <unistd.h>
#include <unordered_map>
#include <vector>

#ifdef DEBUG
# define debug(x) cout << x << endl;
#else
# define debug(x)
#endif

#define VERSION "1.1.0"
#define DELIMITER "`"

#define IP "127.0.0.1"

using std::string;
using std::endl;
using std::cout;
using std::stringstream;
using std::ofstream;
using std::hash;
using namespace std::chrono;

/**
 * Get the time, in milliseconds, since the epoch
 **/
string getTime() {
    return std::to_string(std::chrono::system_clock::now().time_since_epoch() / std::chrono::milliseconds(1));
}

/**
 * Send via dev shm (memory/tmpfs)
 **/
string useSharedMemory(string timestamp, string data) {
    debug("send via tmpfs");
    hash<string> hasher;
    size_t hash = hasher(data);
    string filename = FILEPATH + timestamp + "." + std::to_string(hash) + ".msg";
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

    return useSharedMemory(time, sending);
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
