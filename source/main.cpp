#include <iostream>
#include "../djinni/Init.hpp"
#include "../djinni/Other.hpp"

extern "C" std::shared_ptr<Init> Init_init_instantiate();

std::shared_ptr<Init> Init::init() {
	return Init_init_instantiate();
}

int main() {
	auto a = Init::init();
	std::cout << a->version() << std::endl;
	auto p = a->test();
	std::cout << p.a << std::endl;

	return 0;
}