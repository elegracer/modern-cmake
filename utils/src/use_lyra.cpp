#include "lyra/lyra.hpp"

#include "spdlog/fmt/fmt.h"
#include "spdlog/fmt/ostr.h"

int main(int argc, const char *argv[]) {

    bool show_help = false;
    auto name = std::string {};

    auto cli =
        lyra::help(show_help)
        | lyra::opt(name, "name")["-n"]["--name"]("By what name should I be known").required();

    auto cli_result = cli.parse({argc, argv});
    if (!cli_result) {
        fmt::print(stderr, "Error in command line: {}\n{}", cli_result.message(), cli);
        return EXIT_FAILURE;
    }

    if (show_help) {
        fmt::print("{}\n", cli);
        return EXIT_SUCCESS;
    }

    fmt::print("name: {}\n", name);

    return EXIT_SUCCESS;
}
