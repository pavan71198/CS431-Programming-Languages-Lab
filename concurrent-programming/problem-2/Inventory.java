/* Libraries used */
import java.io.*;
import java.util.*;

public class Inventory {

	/* Writing a queue for the two trays and the godowns, to store Bottles info */
	private static Queue<Bottle> unfinishedTrayB1 = new LinkedList<Bottle>();
	private static Queue<Bottle> unfinishedTrayB2 = new LinkedList<Bottle>();
	private static Queue<Bottle> godownB1 = new LinkedList<Bottle>();
	private static Queue<Bottle> godownB2 = new LinkedList<Bottle>();

	/* Setting Priorities for the pack and seal */
	private int packPriority = 1;
	private int sealPriority = 2;

	/* Adding the bottles in the inventory to the unfinished trays */
	Inventory(int b1Num, int b2Num) {
		for (int i = 0; i < b1Num; i++) {
			unfinishedTrayB1.add(new Bottle(1));
		}
		for (int i = 0; i < b2Num; i++) {
			unfinishedTrayB2.add(new Bottle(2));
		}
	}

	/*
	 * Get bottle B1 or B2 based on priority from unfinished tray for packaging unit
	 */
	public Bottle getPackBottle() {

		/* Synchronised over the inventory object */
		synchronized (this) {

			if (packPriority == 1) {
				if (unfinishedTrayB1.size() != 0) {
					packPriority = 2;
					return unfinishedTrayB1.remove();
				} else {
					if (unfinishedTrayB2.size() != 0) {
						return unfinishedTrayB2.remove();
					} else {
						return null;
					}
				}
			} else {
				if (unfinishedTrayB2.size() != 0) {
					packPriority = 1;
					return unfinishedTrayB2.remove();
				} else {
					if (unfinishedTrayB1.size() != 0) {
						return unfinishedTrayB1.remove();
					} else {
						return null;
					}
				}
			}
		}
	}

	/*
	 * Get bottle B1 or B2 based on priority from unfinished tray for sealing unit
	 */
	public Bottle getSealBottle() {
		synchronized (this) {
			if (sealPriority == 1) {
				if (unfinishedTrayB1.size() != 0) {
					sealPriority = 2;
					return unfinishedTrayB1.remove();
				} else {
					if (unfinishedTrayB2.size() != 0) {
						return unfinishedTrayB2.remove();
					} else {
						return null;
					}
				}
			} else {
				if (unfinishedTrayB2.size() != 0) {
					sealPriority = 1;
					return unfinishedTrayB2.remove();
				} else {
					if (unfinishedTrayB1.size() != 0) {
						return unfinishedTrayB1.remove();
					} else {
						return null;
					}
				}
			}
		}
	}

	/*
	 * Synchonise ( As both B1 and B2 can't use godown at same time) and Send Sealed
	 * and Pcked Bottles to godown
	 */
	public void godownB1PutBottle(Bottle input) {
		synchronized (godownB1) {
			godownB1.add(input);
		}
	}

	/* Return Sizes of B1 in godown */
	public int godownB1Size() {
		return godownB1.size();
	}

	/*
	 * Synchonise ( As both B1 and B2 can't use godown at same time) and Send Sealed
	 * and Pcked Bottles to godown
	 */
	public void godownB2PutBottle(Bottle input) {
		synchronized (godownB2) {
			godownB2.add(input);
		}
	}

	/* Return Sizes of B1 in godown */
	public int godownB2Size() {
		return godownB2.size();
	}

}