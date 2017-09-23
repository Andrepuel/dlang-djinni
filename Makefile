all: cpp_main

djinni/Init.hpp: facade.djinni
	djinni --idl $^ --cpp-out djinni --objc-out djinni --objcpp-out djinni

cpp_helpers.o: source/cpp_helpers.cpp
	g++ $^ -c -o $@ -std=c++11

libdjinnipoc.a: source/*.d
	dub build

cpp_main: source/main.cpp libdjinnipoc.a
	g++ $^ -o $@ -std=c++11 -lphobos2 -L/usr/local/lib