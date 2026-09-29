// auto type inference examples — C++11/14/17
#include <iostream>
#include <vector>
#include <map>
#include <string>

void auto_examples() {
    // Simple type inference
    auto x = 42;              // int
    auto pi = 3.14159;        // double
    auto name = "Alice";      // const char*
    auto message = std::string("Hello");  // std::string

    // Iterator simplification
    std::vector<int> numbers = {1, 2, 3, 4, 5};

    // Before C++11
    for (std::vector<int>::iterator it = numbers.begin(); it != numbers.end(); ++it) {
        std::cout << *it << " ";
    }

    // With auto
    for (auto it = numbers.begin(); it != numbers.end(); ++it) {
        std::cout << *it << " ";
    }

    // Complex types
    std::map<std::string, std::vector<int>> data;
    auto it = data.find("key");

    // Return type deduction (C++14)
    auto multiply = [](int a, int b) { return a * b; };

    // Structured bindings (C++17)
    std::map<std::string, int> scores = {{"Alice", 95}, {"Bob", 87}};
    for (const auto& [name, score] : scores) {
        std::cout << name << ": " << score << "\n";
    }
}
