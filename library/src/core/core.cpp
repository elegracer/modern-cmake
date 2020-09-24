#include <core/core.h>

namespace core {

std::string getProjectDescription(int major, int minor, int patch) {
    return "modern-cmake template v"
           + std::to_string(major) + "."
           + std::to_string(minor) + "."
           + std::to_string(patch);
}

} // namespace core
