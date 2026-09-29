// Lambda expressions examples — C++11/14
#include <algorithm>
#include <vector>
#include <functional>
#include <iostream>

void lambda_examples() {
    std::vector<int> numbers = {5, 2, 8, 1, 9, 3};

    // Basic lambda
    auto print = [](int n) { std::cout << n << " "; };
    std::for_each(numbers.begin(), numbers.end(), print);

    // Capture by value
    int threshold = 5;
    auto above_threshold = [threshold](int n) { return n > threshold; };

    // Capture by reference
    int count = 0;
    auto count_above = [&count, threshold](int n) {
        if (n > threshold) count++;
    };
    std::for_each(numbers.begin(), numbers.end(), count_above);

    // Generic lambda (C++14)
    auto generic_print = [](const auto& item) { std::cout << item << " "; };

    // Lambda as comparator
    std::sort(numbers.begin(), numbers.end(), [](int a, int b) { return a > b; });

    // Mutable lambda with init-capture (C++14)
    auto counter = [count = 0]() mutable { return ++count; };
    std::cout << counter() << "\n";  // 1
    std::cout << counter() << "\n";  // 2
}

// Returning lambdas
std::function<int(int)> make_multiplier(int factor) {
    return [factor](int n) { return n * factor; };
}
