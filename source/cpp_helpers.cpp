#include <string>
#include <memory>

extern "C" {
size_t shared_ptr_size() {
	return sizeof(std::shared_ptr<void>);
}

void shared_ptr_init(void* self, void* value, void (*destruc)(void* value)) {
	new(self) std::shared_ptr<void>(value, destruc);
}

void* shared_ptr_ptr(std::shared_ptr<void>* self) {
	return self->get();
}

void shared_ptr_deinit(std::shared_ptr<void>* self) {
	self->~shared_ptr();
}

size_t string_size() {
	return sizeof(std::string);
}

void string_init(void* self, const char* value, size_t length) {
	new(self) std::string(value, value + length);
}

const char* string_value(std::string* self, size_t* out_length) {
	*out_length = self->length();
	return self->data();
}

void string_deinit(std::string* self) {
	using std::string;
	self->~string();
}
}