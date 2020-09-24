#include <core/core.h>

#include <iostream>

int main(int argc, const char *argv[]) {
#ifdef OPTION_A
    std::cout << "OPTION_A defined" << std::endl;
#else
    std::cout << "OPTION_A undefined" << std::endl;
#endif

    std::cout << core::getProjectDescription(LIBRARY_MAJOR_VERSION, LIBRARY_MINOR_VERSION, LIBRARY_PATCH_VERSION) << std::endl;
    return 0;
}
