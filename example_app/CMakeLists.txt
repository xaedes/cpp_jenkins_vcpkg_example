cmake_minimum_required(VERSION 3.8)

project( example_app )

add_executable( ${PROJECT_NAME} src/example_app.cpp )
target_link_libraries( ${PROJECT_NAME} PRIVATE example )