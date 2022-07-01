cmake_minimum_required(VERSION 3.5)

project( example_tests )

enable_testing()
include(CTest)

# create the testing file and list of tests
create_test_sourcelist (Tests
    ${PROJECT_NAME}.cpp
    # add tests here
    perform_clever_computation.cpp
    perform_important_computation.cpp
)

# add the executable
add_executable (${PROJECT_NAME} ${Tests})
target_link_libraries( ${PROJECT_NAME} PRIVATE example )

# remove the test driver source file
set (TestsToRun ${Tests})
remove (TestsToRun ${PROJECT_NAME}.cpp)

# Add all the ADD_TEST for each test
foreach (test ${TestsToRun})
    get_filename_component (TName ${test} NAME_WE)
    add_test (NAME ${TName} COMMAND ${PROJECT_NAME} ${TName})
endforeach ()

# add_test(NAME example_app COMMAND example_app)

