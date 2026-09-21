#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <iomanip>
#include <sstream>

using namespace std;

int main() {
    cout << "START CONVERT" << endl;

    ifstream infile("D:/University/Physical Design/RISC-V-ALU/Compile/raw.mem");
    if (!infile.is_open()) {
        cout << "Cannot open raw.mem" << endl;
        return 1;
    }

    vector<unsigned int> bytes_data;
    string token;

    while (infile >> token) {
        if (!token.empty() && token[0] == '@')
            continue;
        unsigned int val = 0;
        stringstream ss(token);
        ss >> hex >> val;
        bytes_data.push_back(val);
    }
    infile.close();

    vector<unsigned int> words;
    for (size_t i = 0; i + 3 < bytes_data.size(); i += 4) {
        unsigned int word = (bytes_data[i + 3] << 24)
                          | (bytes_data[i + 2] << 16)
                          | (bytes_data[i + 1] << 8)
                          |  bytes_data[i];
        words.push_back(word);
    }

    ofstream outfile("D:/University/Physical Design/RISC-V-ALU/programR.mem");
    if (!outfile.is_open()) {
        cout << "Cannot create programR.mem" << endl;
        return 1;
    }

    // ✅ In thẳng, không nhóm, không dòng trống
    for (size_t i = 0; i < words.size(); i++) {
        outfile << hex << setw(8) << setfill('0') << words[i] << "\n";
    }

    outfile.close();
    cout << "DONE -> programR.mem generated" << endl;
    return 0;
}