// C++20 Ranges library examples
#include <ranges>
#include <vector>
#include <iostream>
#include <algorithm>

void ranges_examples() {
    std::vector<int> numbers{1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    auto even  = [](int n) { return n % 2 == 0; };
    auto square = [](int n) { return n * n; };

    // Lazy composable pipeline — no intermediate copies
    auto result = numbers
        | std::views::filter(even)
        | std::views::transform(square)
        | std::views::take(3);

    for (int n : result) { std::cout << n << " "; }  // 4 16 36
    std::cout << "\n";

    // Range algorithms with projection
    struct Person { std::string name; int age; };
    std::vector<Person> people{{"Alice", 30}, {"Bob", 25}, {"Charlie", 35}};

    auto it = std::ranges::find(people, "Bob", &Person::name);

    // iota — number generation without container
    for (int i : std::views::iota(1, 6)) { std::cout << i << " "; }
    std::cout << "\n";

    // split view
    std::string text = "one,two,three";
    for (auto word : text | std::views::split(',')) {
        for (char c : word) { std::cout << c; }
        std::cout << " ";
    }
}
