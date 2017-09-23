module helpers;

extern (C) {
	size_t shared_ptr_size();
	void shared_ptr_init(cpp_shared_ptr_* self, void* value, void function(void* value) destruc);
	void* shared_ptr_ptr(cpp_shared_ptr_* self);
	void shared_ptr_deinit(cpp_shared_ptr_* self);
	size_t string_size();
	void string_init(cpp_string* self, const char* value, size_t length);
	const(char)* string_value(const(cpp_string)* self, size_t* out_length);
	void string_deinit(cpp_string* self);
}

struct cpp_shared_ptr_ {
	size_t[2] data;

	extern (C) static dlang_gc_lock(void* ptr) {
		import core.memory : GC;
		GC.addRoot(cast(void*)ptr);
		GC.setAttr(cast(void*)ptr, GC.BlkAttr.NO_MOVE);
	}

	extern (C) static dlang_gc_unlock(void* ptr) {
		import core.memory : GC;
		GC.removeRoot(ptr);
		GC.clrAttr(ptr, GC.BlkAttr.NO_MOVE);
	}
}

struct cpp_string {
	size_t[3] data;

	this(const(char)[] data) {
		string_init(&this, data.ptr, data.length);
		assert(this.data[] != [0,0,0]);
	}

	void deinit() {
		assert(this.data[] != [0,0,0]);
		string_deinit(&this);
		data[] = 0;
	}

	const(char)[] str() const {
		ulong len;
		return string_value(&this, &len)[0..len];
	}

	const(char)[] release() {
		auto r = str().dup;
		deinit();
		return r;
	}
}

shared static this() {
	assert(shared_ptr_size() == cpp_shared_ptr_.sizeof, "Runtime shared_ptr length mismatched");
	assert(string_size() == cpp_string.sizeof, "Runtime string length mismatched");
}

struct cpp_shared_ptr(T) {
	cpp_shared_ptr_ self;

	this(T stuff) {
		shared_ptr_init(&self, cast(void*)stuff, &cpp_shared_ptr_.dlang_gc_unlock);
		cpp_shared_ptr_.dlang_gc_lock(cast(void*)stuff);
	}

	void deinit() {
		shared_ptr_deinit(&self);
	}

	T ptr() {
		return cast(T)shared_ptr_ptr(&self);
	}
}