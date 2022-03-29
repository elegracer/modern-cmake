#include "core/core.h"

#include "spdlog/fmt/fmt.h"
#include "spdlog/fmt/bundled/ranges.h"

#include "range/v3/view/sliding.hpp"

#include <vector>

int main(int argc, const char *argv[]) {


    auto v = std::vector {1, 2, 3, 4, 5};
    for (auto &&t : v | ranges::views::sliding(3)) {
        fmt::print("{}\n", fmt::join(t.begin(), t.end(), ","));
    }

    return 0;
}
