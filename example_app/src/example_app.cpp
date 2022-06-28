#include <iostream>

#include <example/example.h>

int main(int argc, char **argv)
{
    int n = 100;
    int sum = 0;
    example::perform_important_computation(n, sum);

    std::cout << "sum " << sum << std::endl;

    int exit_code = (
        (sum == ((n*n-n)>>1))
        ? 0
        : -1
    );
    return exit_code;
}
