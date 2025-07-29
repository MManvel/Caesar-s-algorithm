#include <iostream>
#include <string>
#include <dlfcn.h>
#include "unit_test.h"

void run_unit_test() {
    void* handle = dlopen("./lib/libcaesar.so", RTLD_LAZY);
    if (!handle) {
        std::cerr << "Չհաջողվեց բացել Caesar գրադարանը: " << dlerror() << std::endl;
        return;
    }

    typedef const char* (*func_t)(const char*, int);
    func_t encode = (func_t)dlsym(handle, "encode");
    func_t decode = (func_t)dlsym(handle, "decode");

    if (!encode || !decode) {
        std::cerr << "Չհաջողվեց բեռնել ֆունկցիաները: " << dlerror() << std::endl;
        dlclose(handle);
        return;
    }

    std::string input;
    while (true) {
        std::cout << "Մուտքագրեք տեքստ (կամ 'break'՝ դադարելու համար): ";
        std::getline(std::cin, input);

        if (input == "break") break;

        const char* encoded = encode(input.c_str(), 3);
        const char* decoded = decode(encoded, 3);

        std::cout << "Encoded: " << encoded << "\n";
        std::cout << "Decoded: " << decoded << "\n";

        if (input == decoded)
            std::cout << "✅ Թեստը հաջողությամբ անցավ\n";
        else
            std::cout << "❌ Թեստը ձախողվեց\n";
    }

    dlclose(handle);
}

