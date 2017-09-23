#include <iostream>
#include "../djinni/Init.hpp"
#include "../djinni/Other.hpp"

int main() {
	auto a = Init::init();
	std::cout << a->version() << std::endl;
	auto p = a->test();
	std::cout << p.a << std::endl;

	return 0;
}