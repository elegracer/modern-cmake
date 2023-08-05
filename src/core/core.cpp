#include <core/core.h>

namespace core {

std::string get_project_description() {
    return {CORE_VERSION_STRING};
}

} // namespace core
