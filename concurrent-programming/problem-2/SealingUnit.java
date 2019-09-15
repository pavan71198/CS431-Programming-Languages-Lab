/* Standard Libraries */
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

/* Extend thread to sealing Class and define variables */
public class SealingUnit extends Thread {
	private Queue<Bottle> inputQueue = new LinkedList<Bottle>();

	/* The bottle being presently processed is saved in this */
	private Bottle processingBottle = null;

	private PackagingUnit packer;
	private Inventory inv;
	private int time;
	private Phaser secPhaser;
	public int b1Sealed = 0;
	public int b2Sealed = 0;

	/* Constructor */
	SealingUnit(int time, Inventory inv, Phaser secPhaser) {
		this.time = time;
		this.inv = inv;
		this.secPhaser = secPhaser;

		/* Registering the thread to phaser */
		secPhaser.register();
	}

	/* Setting the packaging unit object */
	public void setPackagingUnit(PackagingUnit packer) {
		this.packer = packer;
	}

	/* Synchronised method over input tray to know its size */
	public int inputQueueSize() {
		synchronized (inputQueue) {
			return inputQueue.size();
		}
	}

	/* Synchronised method over Input Tray to take a bottle from the Queue */
	public Bottle inputQueueTakeBottle() {
		synchronized (inputQueue) {
			if (this.inputQueueSize() != 0) {
				return inputQueue.remove();
			} else {
				return null;
			}
		}
	}

	/* Synchronised method over Input Tray to take a bottle into the Queue */
	public boolean inputQueuePutBottle(Bottle input) {
		synchronized (inputQueue) {
			if (this.inputQueueSize() < 2) {
				inputQueue.add(input);
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
				if (this.inputQueueSize() > 0) {
					processingBottle = this.inputQueueTakeBottle();
				} else {
					processingBottle = inv.getSealBottle();
					if (processingBottle == null) {
						time--;

						/* Waiting for packaging unit to process 1 second */
						secPhaser.arriveAndAwaitAdvance();

						// System.out.println("Sealer time: "+time);

						continue;
					}
				}
			}
			processingBottle.seal();
			time--;

			/* Waiting for packaging unit to process 1 second */
			secPhaser.arriveAndAwaitAdvance();

			// System.out.println("Sealer time: "+time);

			/*
			 * Checking whether the bottle is sealed and packed and deciding whether to send
			 * to godown or sealing unit
			 */
			if (processingBottle.sealed() && processingBottle.packed()) {
				if (processingBottle.bottleType == 1) {
					b1Sealed++;
					this.inv.godownB1PutBottle(processingBottle);
				} else {
					b2Sealed++;
					this.inv.godownB2PutBottle(processingBottle);
				}
				processingBottle = null;
			} else if (processingBottle.sealed() && !processingBottle.packed()) {
				if (processingBottle.bottleType == 1) {
					b1Sealed++;
					while (packer.b1InputQueueSize() == 3) {
						time--;

						/* Waiting for packaging unit to process 1 second */
						secPhaser.arriveAndAwaitAdvance();

						// System.out.println("Sealer time: "+time);

					}
					packer.b1InputQueuePutBottle(processingBottle);
				} else {
					b2Sealed++;
					while (packer.b2InputQueueSize() == 2) {
						time--;

						/* Waiting for packaging unit to process 1 second */
						secPhaser.arriveAndAwaitAdvance();

						// System.out.println("Sealer time: "+time);

					}
					packer.b2InputQueuePutBottle(processingBottle);
				}
				processingBottle = null;
			}
		}

		/* Deregistering the thread from Phaser */
		secPhaser.arriveAndDeregister();
	}
}