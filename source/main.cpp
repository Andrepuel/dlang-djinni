#include <iostream>
#include "../djinni/cpp_Init.hpp"
#include "../djinni/cpp_Other.hpp"
#include "../djinni/cpp_Callback.hpp"

class Implement : public cpp_Callback {
	virtual std::string str() override {
		return "Hello world!";
	}
};

int main() {
	auto a = cpp_Init::init();
	std::cout << a->version() << std::endl;
	auto p = a->test();
	std::cout << p.a << std::endl;

	a->callme(std::make_shared<Implement>());

	return 0;
}