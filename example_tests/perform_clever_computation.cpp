
#include <cassert>

#include <example/example.h>


int perform_clever_computation(int argc, char* argv[])
{
    int n[3] = {0,10,100};
    int truth[3] = {0,45,4950};
    for (int i = 0; i < 3; ++i)
    {
        int sum = 0;
        example::perform_clever_computation(n[i], sum);
        assert(sum == truth[i]);
    }
    return 0;
}
