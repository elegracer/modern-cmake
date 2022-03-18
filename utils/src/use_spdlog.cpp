#include "core/core.h"

#include "spdlog/spdlog.h"

int main(int argc, const char *argv[]) {

    spdlog::info("{}\n", core::get_project_description());

    return 0;
}
