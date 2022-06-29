#!/bin/sh

function_all() {
    ./$0 clean && ./$0 tools && ./$0 build && ./$0 test
}
function_clean() {
    echo "Cleaning up..."
}
function_tools() {
    echo "Preparing tools..."
}
function_build() {
    echo "Building..."
}
function_test() {
    echo "Testing..."
}
function_help() {
    echo "Usage:"
    echo "$0 [all|clean|tools|build|test|help]"
}

case $1 in
    all)   function_all;;
    clean) function_clean;;
    tools) function_tools;;
    build) function_build;;
    test)  function_test;;
    help)  function_help;;
    *)     function_help;;
esac