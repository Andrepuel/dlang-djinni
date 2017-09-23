import helpers : cpp_shared_ptr, cpp_string;

struct Other {
	cpp_string a;
}

extern (C++) class Init {
	void destroy1() {}
	void destroy2() {}

	cpp_string version_() {
		return cpp_string("0.0.0");
	}

	Other test() {
		return Other(cpp_string("test"));
	}
}

extern (C) cpp_shared_ptr!Init Init_init_instantiate() {
	import core.runtime : Runtime;
	Runtime.initialize();
	return cpp_shared_ptr!Init(new Init);
}