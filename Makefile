djinni=$(DJINNI_DIR)/src/run

all: cpp_main swift_main

djinni/cpp_Init.hpp: facade.djinni
	$(djinni) --idl $^ --cpp-out djinni --objc-out djinni --objcpp-out djinni \
	--jni-out djinni/jni --java-out djinni/com/example/djinnipoc --java-package com.example.djinnipoc \
	--ident-cpp-type cpp_FooBar --ident-cpp-file cpp_FooBar --ident-jni-class FooBar --ident-jni-file FooBar \
	--objc-swift-bridging-header objc_header

cpp_helpers.o: source/cpp_helpers.cpp
	g++ $^ -c -o $@ -std=c++11

libdjinnipoc.a: source/*.d cpp_helpers.o
	dub build

libdjinnipocobjc.a: djinni/cpp_Init.hpp
	mkdir -p objc_build
	cd objc_build && g++ ../djinni/*.mm -I$(DJINNI_DIR)/support-lib/objc $(DJINNI_DIR)/support-lib/objc/*.mm -std=c++11 -fobjc-arc -c
	cd objc_build && ar rvs ../libdjinnipocobjc.a *.o

libdjinnipocjni.dylib: djinni/cpp_Init.hpp libdjinnipoc.a
	g++ djinni/jni/*.cpp -shared -o $@ -I$(DJINNI_DIR)/support-lib/jni -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin -std=c++11 -Idjinni $(DJINNI_DIR)/support-lib/jni/*.cpp libdjinnipoc.a -L/usr/local/lib -lphobos2

cpp_main: source/main.cpp libdjinnipoc.a
	g++ $^ -o $@ -std=c++11 -lphobos2 -L/usr/local/lib

swift_main: source/main.swift libdjinnipocobjc.a libdjinnipoc.a djinni/cpp_Init.hpp
	swiftc -import-objc-header djinni/objc_header.h $^ -lc++ libdjinnipoc.a -lphobos2 -L/usr/local/lib -o $@