/* Standard Libraries */
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

/* Extend thread to packaging Class and define variables */
public class PackagingUnit extends Thread {
	private Queue<Bottle> b1InputQueue = new LinkedList<Bottle>();
	private Queue<Bottle> b2InputQueue = new LinkedList<Bottle>();

	/* The bottle being presently processed is saved in this */
	private Bottle processingBottle = null;

	private Inventory inv;
	private SealingUnit sealer;
	private int queuePriority = 1;
	private int time;
	private Phaser secPhaser;
	public int b1Packed = 0;
	public int b2Packed = 0;

	/* Constructor */
	PackagingUnit(int time, Inventory inv, Phaser secPhaser) {
		this.time = time;
		this.inv = inv;
		this.secPhaser = secPhaser;

		/* Registering the thread to phaser */
		secPhaser.register();
	}

	/* Setting the sealing unit object */
	public void setSealingUnit(SealingUnit sealer) {
		this.sealer = sealer;
	}

	/* Synchronised method over B1 input tray to know its size */
	public int b1InputQueueSize() {
		synchronized (b1InputQueue) {
			return b1InputQueue.size();
		}
	}

	/* Synchronised method over B1 Input Tray to take a bottle from the Queue */
	public Bottle b1InputQueueTakeBottle() {
		synchronized (b1InputQueue) {
			if (this.b1InputQueueSize() != 0) {
				return b1InputQueue.remove();
			} else {
				return null;
			}
		}
	}

	/* Synchronised method over B1 Input Tray to take a bottle into the Queue */
	public boolean b1InputQueuePutBottle(Bottle b1Input) {
		synchronized (b1InputQueue) {
			if (this.b1InputQueueSize() < 2) {
				b1InputQueue.add(b1Input);
				return true;
			} else {
				return false;
			}
		}
	}

	/* Synchronised method over B2 input tray to know its size */
	public int b2InputQueueSize() {
		synchronized (b2InputQueue) {
			return b2InputQueue.size();
		}
	}

	/* Synchronised method over B1 Input Tray to take a bottle from the Queue */
	public Bottle b2InputQueueTakeBottle() {
		synchronized (b2InputQueue) {
			if (this.b2InputQueueSize() != 0) {
				return b2InputQueue.remove();
			} else {
				return null;
			}
		}
	}

	/* Synchronised method over B1 Input Tray to take a bottle into the Queue */
	public boolean b2InputQueuePutBottle(Bottle b2Input) {
		synchronized (b2InputQueue) {
			if (this.b2InputQueueSize() < 2) {
				b2InputQueue.add(b2Input);
				return true;
			} else {
				return false;
			}
		}
	}

	@Override
	public void run() {
		while (time > 0) {
			if (processingBottle == null) {
				if (this.b1InputQueueSize() == 0 && this.b2InputQueueSize() == 0) {
					processingBottle = this.inv.getPackBottle();
					if (processingBottle == null) {
						time--;

						/* Waiting for sealing unit to process 1 second */
						secPhaser.arriveAndAwaitAdvance();

						// System.out.println("Packer time: "+time);

						continue;
					}
				} else {
					if (queuePriority == 1) {
						if (this.b1InputQueueSize() > 0) {
							processingBottle = this.b1InputQueueTakeBottle();
							queuePriority = 2;
						} else if (this.b2InputQueueSize() > 0) {
							processingBottle = this.b2InputQueueTakeBottle();
							queuePriority = 1;
						}
					} else {
						if (this.b2InputQueueSize() > 0) {
							processingBottle = this.b2InputQueueTakeBottle();
							queuePriority = 1;
						} else if (this.b1InputQueueSize() > 0) {
							processingBottle = this.b1InputQueueTakeBottle();
							queuePriority = 2;
						}
					}
				}
			}
			processingBottle.pack();
			time--;

			/* Waiting for sealing unit to process 1 second */
			secPhaser.arriveAndAwaitAdvance();

			// System.out.println("Packer time: "+time);

			/*
			 * Checking whether the bottle is sealed and packed and deciding whether to send
			 * to godown or sealing unit
			 */
			if (processingBottle.sealed() && processingBottle.packed()) {
				if (processingBottle.bottleType == 1) {
					b1Packed++;
					this.inv.godownB1PutBottle(processingBottle);
				} else {
					b2Packed++;
					this.inv.godownB2PutBottle(processingBottle);
				}
				processingBottle = null;
			} else if (!processingBottle.sealed() && processingBottle.packed()) {
				if (processingBottle.bottleType == 1) {
					b1Packed++;
				} else {
					b2Packed++;
				}
				while (sealer.inputQueueSize() == 3) {
					time--;

					/* Waiting for sealing unit to process 1 second */

					secPhaser.arriveAndAwaitAdvance();

					// System.out.println("Packer time: "+time);
				}
				sealer.inputQueuePutBottle(processingBottle);
				processingBottle = null;
			}
		}

		/* Deregistering the thread from Phaser */
		secPhaser.arriveAndDeregister();
	}

}