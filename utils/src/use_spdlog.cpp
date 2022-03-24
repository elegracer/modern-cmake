#include "core/core.h"

#include "spdlog/spdlog.h"

int main(int argc, const char *argv[]) {

    spdlog::info("{}", core::get_project_description());

    spdlog::error("???");

    return 0;
}
