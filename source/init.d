import helpers : cpp_shared_ptr, cpp_string;

struct Other {
	cpp_string a;
}

mixin template CppDestructorsOffset() {
	void __destruct1() {}
	void __destruct2() {}
}

extern (C++) class Callback {
	mixin CppDestructorsOffset;

	abstract cpp_string str();
}

extern (C++) class Init {
	mixin CppDestructorsOffset;

	cpp_string version_() {
		return cpp_string("0.0.0");
	}

	Other test() {
		return Other(cpp_string("test"));
	}

	void callme(ref cpp_shared_ptr!Callback cb) {
		import std.stdio;
		writeln([cb.ptr.str.release]);
	}
}

extern (C) cpp_shared_ptr!Init Init_init_instantiate() {
	import core.runtime : Runtime;
	Runtime.initialize();
	return cpp_shared_ptr!Init(new Init);
}