#include <iostream>
#include "../djinni/Init.hpp"
#include "../djinni/Other.hpp"
#include "../djinni/Callback.hpp"

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