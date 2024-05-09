cmake_minimum_required(VERSION 3.23)
set(CXX_COMPILER g++)
set(C_COMPILER gcc)

project(str_func CXX C ASM)

set_property(SOURCE str.s APPEND PROPERTY COMPILE_OPTIONS "-x" "assembler")
set_property(SOURCE str.c APPEND PROPERTY COMPILE_OPTIONS "-x" "c" "-Og")


add_executable(test_c test_c.cpp)
add_executable(test_s test_s.cpp)
add_executable(main_c main_c.cpp)
add_executable(main_s main_s.cpp)
add_library(s_lib_str str.s)
add_library(c_lib_str str.c)    

target_link_libraries(main_c c_lib_str)
target_link_libraries(main_s s_lib_str)
target_link_libraries(test_c c_lib_str)
target_link_libraries(test_s s_lib_str)

find_package(GTest REQUIRED)
include_directories(${GTEST_INCLUDE_DIRS})
target_link_libraries(test_c GTest::gtest_main)
target_link_libraries(test_s GTest::gtest_main)


install(FILES test_strings.txt DESTINATION ./test_files)
install(TARGETS main_s main_c test_s test_c)