#include <example/example.h>

namespace example {

    void perform_important_computation(int n, int& result)
    {
        result = 0;
        for (int i = 0; i < n; ++i)
        {
            result += i;
        }
    }

    void perform_clever_computation(int n, int& result)
    {
        result = (n*n - n)>>1;
    }


} // namespace example
