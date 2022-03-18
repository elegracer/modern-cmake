#include "core/core.h"

#include "spdlog/fmt/fmt.h"

int main(int argc, const char *argv[]) {

    fmt::print("{}\n", core::get_project_description());

    return 0;
}
