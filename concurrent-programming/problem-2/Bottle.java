/* Declaring variables in the class Bottle */
public class Bottle {
	public int bottleType;
	private int packing = 0;
	private int sealing = 0;

	Bottle(int bottleType) {
		this.bottleType = bottleType;
	}

	/* While pack() is called packing time is incremented */
	public void pack() {
		this.packing++;
	}

	/* While seal() is called Sealing time is incremented */
	public void seal() {
		this.sealing++;
	}

	/* Packing Takes only 2 seconds to complete */
	public boolean packed() {
		if (this.packing == 2) {
			return true;
		} else {
			return false;
		}
	}

	/* Sealing takes only 3 seconds to complete */
	public boolean sealed() {
		if (this.sealing == 3) {
			return true;
		} else {
			return false;
		}
	}
}