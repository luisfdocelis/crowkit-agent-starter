// Structured bindings — C++17
#include <tuple>
#include <map>
#include <string>
#include <array>
#include <iostream>

struct Person {
    std::string name;
    int age;
    double salary;
};

std::tuple<int, std::string, double> get_employee() {
    return {42, "Alice", 75000.0};
}

void structured_bindings() {
    // Tuple decomposition
    auto [id, name, salary] = get_employee();

    // Pair decomposition
    std::pair<int, std::string> p{1, "one"};
    auto [num, text] = p;

    // Struct decomposition
    Person person{"Bob", 30, 80000.0};
    auto [pname, page, psalary] = person;

    // Array decomposition
    std::array<int, 3> arr{1, 2, 3};
    auto [a, b, c] = arr;

    // Map iteration — most common use case
    std::map<std::string, int> scores{{"Alice", 95}, {"Bob", 87}};
    for (const auto& [name, score] : scores) {
        std::cout << name << ": " << score << "\n";
    }

    // Modify via reference binding
    auto& [rname, rage, rsalary] = person;
    rage = 31;  // Modifies person.age
}
