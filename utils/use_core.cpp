#include <core/core.h>

#include <iostream>

int main(int argc, const char* argv[]) {
#ifdef CORE_OPTION
    std::cout << "CORE_OPTION defined" << std::endl;
#else
    std::cout << "CORE_OPTION undefined" << std::endl;
#endif

    std::cout << core::getProjectDescription(CORE_MAJOR_VERSION, CORE_MINOR_VERSION, CORE_PATCH_VERSION) << std::endl;
    return 0;
}
