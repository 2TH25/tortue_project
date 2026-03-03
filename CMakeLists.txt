cmake_minimum_required(VERSION 3.10)

project(TURTLE C)

find_package(BISON)
find_package(FLEX)

set(CMAKE_C_FLAGS "-Wall -std=c99 -O2 -g")

bison_target(turtle-parser
  turtle-parser.y
  "${CMAKE_CURRENT_BINARY_DIR}/turtle-parser.c"
  COMPILE_FLAGS "-v"
)

flex_target(turtle-lexer
  turtle-lexer.l
  "${CMAKE_CURRENT_BINARY_DIR}/turtle-lexer.c"
  DEFINES_FILE "${CMAKE_CURRENT_BINARY_DIR}/turtle-lexer.h"
)

add_flex_bison_dependency(turtle-lexer turtle-parser)

add_executable(turtle
  turtle.c
  turtle-ast.c
  ${BISON_turtle-parser_OUTPUTS}
  ${FLEX_turtle-lexer_OUTPUTS}
)

target_include_directories(turtle
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_BINARY_DIR}"
)

target_link_libraries(turtle m)

target_compile_definitions(turtle
  PRIVATE
    _POSIX_C_SOURCE=200809L
)
