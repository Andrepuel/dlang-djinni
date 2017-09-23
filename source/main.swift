let i = Init.init()!;
print(i.version());
let other = i.test();
print(other.a);

class MyImpl: Callback {
	public func str() -> String {
		return "Hello from swift";
	}
}

i.callme(MyImpl());