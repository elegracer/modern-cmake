#include "Eigen/Eigen"

#include "spdlog/fmt/fmt.h"
#include "spdlog/fmt/ostr.h"

int main(int argc, const char *argv[]) {

    Eigen::Vector3d vector3d {1.0, 2.0, 3.0};

    fmt::print("{}\n", vector3d.transpose());

    return 0;
}
