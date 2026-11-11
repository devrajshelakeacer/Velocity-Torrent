# SPDX-License-Identifier: GPL-3.0-or-later
cmake_minimum_required(VERSION 3.25)

project(VELOCITY
    VERSION 1.0.0
    DESCRIPTION "Intelligent Torrent Downloading for Windows"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Global include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Compiler Warnings & Optimization Flags
if(MSVC)
    add_compile_options(/W4 /permissive- /utf-8 /experimental:deterministic)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Core Library Target
set(VELOCITY_CORE_SOURCES
    src/security/VShieldSanitizer.cpp
    src/engine/PeerScorer.cpp
    src/engine/V200Pipeline.cpp
    src/hardware/ThermalGuardian.cpp
    src/engine/VForceController.cpp
    src/network/NetworkInterfaceManager.cpp
    src/engine/VSEEngine.cpp
    src/models/TorrentListModel.cpp
    src/models/DashboardViewModel.cpp
)

add_library(velocity_core STATIC ${VELOCITY_CORE_SOURCES})

# Client Executable Target
add_executable(velocity_client src/main.cpp)
target_link_libraries(velocity_client PRIVATE velocity_core)

# Unit Test Runner Target
add_executable(velocity_tests
    tests/unit/Test_Main.cpp
    tests/unit/Test_VShieldSanitizer.cpp
    tests/unit/Test_PeerScorer.cpp
    tests/unit/Test_V200Pipeline.cpp
    tests/unit/Test_VForceController.cpp
)
target_link_libraries(velocity_tests PRIVATE velocity_core)

enable_testing()
add_test(NAME VelocityCoreTests COMMAND velocity_tests)
