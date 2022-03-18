#include "core/core.h"

#include "spdlog/fmt/fmt.h"

#include "boost/json.hpp"
#include "boost/json/src.hpp"

int main(int argc, const char *argv[]) {

    auto jv = boost::json::value({{"project", "modern-cmake"}, {"version", CORE_VERSION_STRING}});

    fmt::print("{}\n", boost::json::serialize(jv));

    return 0;
}
