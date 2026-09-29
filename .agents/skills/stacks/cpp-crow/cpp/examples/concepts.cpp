// Concepts — C++20
#include <concepts>
#include <iostream>
#include <vector>

// Custom concept
template<typename T>
concept Numeric = std::integral<T> || std::floating_point<T>;

template<Numeric T>
T add(T a, T b) { return a + b; }

// Concept with requires expression
template<typename T>
concept Printable = requires(T t) {
    { std::cout << t } -> std::convertible_to<std::ostream&>;
};

template<Printable T>
void print(const T& value) { std::cout << value << "\n"; }

// Range concept
template<typename T>
concept Range = requires(T r) { r.begin(); r.end(); };

template<Range R>
void print_range(const R& range) {
    for (const auto& item : range) { std::cout << item << " "; }
    std::cout << "\n";
}

// Container concept with associated types
template<typename T>
concept Container = requires(T c) {
    typename T::value_type;
    typename T::iterator;
    { c.begin() } -> std::same_as<typename T::iterator>;
    { c.end() }   -> std::same_as<typename T::iterator>;
    { c.size() }  -> std::convertible_to<std::size_t>;
};

void concepts_example() {
    auto result = add(5, 10);        // OK — int
    auto dresult = add(5.5, 2.3);    // OK — double
    // add("hi", "there");           // Error: doesn't satisfy Numeric

    print(42);
    print("Hello");

    std::vector<int> vec{1, 2, 3};
    print_range(vec);
}
