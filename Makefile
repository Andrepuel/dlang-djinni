djinni=$(DJINNI_DIR)/src/run

all: cpp_main swift_main

djinni/Init.hpp: facade.djinni
	$(djinni) --idl $^ --cpp-out djinni --objc-out djinni --objcpp-out djinni --ident-cpp-type cpp_FooBar

cpp_helpers.o: source/cpp_helpers.cpp
	g++ $^ -c -o $@ -std=c++11

libdjinnipoc.a: source/*.d cpp_helpers.o
	dub build

libdjinnipocobjc.a: djinni/Init.hpp
	mkdir -p objc_build
	cd objc_build && g++ ../djinni/*.mm -I$(DJINNI_DIR)/support-lib/objc $(DJINNI_DIR)/support-lib/objc/*.mm -std=c++11 -fobjc-arc -c
	cd objc_build && ar rvs ../libdjinnipocobjc.a *.o

cpp_main: source/main.cpp libdjinnipoc.a
	g++ $^ -o $@ -std=c++11 -lphobos2 -L/usr/local/lib

swift_main: source/main.swift libdjinnipocobjc.a libdjinnipoc.a
	swiftc -import-objc-header source/objc_header.h $^ -lc++ libdjinnipoc.a -lphobos2 -L/usr/local/lib -o $@