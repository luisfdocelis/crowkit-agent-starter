// Move semantics — Rule of Five — C++11
#include <vector>
#include <string>
#include <utility>
#include <iostream>

class Buffer {
    size_t size_;
    int* data_;

public:
    Buffer(size_t size) : size_(size), data_(new int[size]) {}

    // Copy constructor
    Buffer(const Buffer& other) : size_(other.size_), data_(new int[other.size_]) {
        std::copy(other.data_, other.data_ + size_, data_);
    }

    // Move constructor — must be noexcept
    Buffer(Buffer&& other) noexcept : size_(other.size_), data_(other.data_) {
        other.size_ = 0;
        other.data_ = nullptr;
    }

    // Copy assignment
    Buffer& operator=(const Buffer& other) {
        if (this != &other) {
            delete[] data_;
            size_ = other.size_;
            data_ = new int[size_];
            std::copy(other.data_, other.data_ + size_, data_);
        }
        return *this;
    }

    // Move assignment — must be noexcept
    Buffer& operator=(Buffer&& other) noexcept {
        if (this != &other) {
            delete[] data_;
            size_ = other.size_;
            data_ = other.data_;
            other.size_ = 0;
            other.data_ = nullptr;
        }
        return *this;
    }

    ~Buffer() { delete[] data_; }
};

void move_semantics_example() {
    Buffer b1(100);
    Buffer b2 = std::move(b1);  // Move, not copy

    std::vector<Buffer> buffers;
    buffers.push_back(Buffer(50));  // Move constructor used

    // Perfect forwarding
    auto make_buffer = [](auto&&... args) {
        return Buffer(std::forward<decltype(args)>(args)...);
    };
}
