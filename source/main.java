import com.example.djinnipoc.Init;
import com.example.djinnipoc.Other;
import com.example.djinnipoc.Callback;

public class main {
	static {
		System.loadLibrary("djinnipocjni");
	}

	public static void main(String[] args) {
		Init a = Init.init();
		System.out.println(a.version());
		Other b = a.test();
		System.out.println(b.getA());
		a.callme(new Callback() {
			@Override
			public String str() {
				return "Hello from Java";
			}
		});
	}
}