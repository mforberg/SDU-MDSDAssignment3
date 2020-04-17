import java.util.*

public class MathComputation {

	public static interface Externals {
		public int power(int base, int exponent);
	}

	private Externals externals;

	public MathComputation(Externals _externals) {
		externals = _externals;
	}

	public void calculate() {
		System.out.println("first value " + 3);
		System.out.println("second value " + 3);
		System.out.println("external example " + 64);
	}

}
