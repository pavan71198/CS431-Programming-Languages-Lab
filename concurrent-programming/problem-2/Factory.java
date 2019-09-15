/* 
	To compile $javac Factory.java
	To run $java Factory
*/

/* Libraries */
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

public class Factory {
	public static void main(String[] args) {

		/* Taking Input using Scanner */
		Scanner input = new Scanner(System.in);

		int b1Num = input.nextInt();
		int b2Num = input.nextInt();
		int time = input.nextInt();
		input.close();

		/* Calling Inventory function Inventory Class */
		Inventory inv = new Inventory(b1Num, b2Num);
		Phaser secPhaser = new Phaser();

		/* Calling Functions from rest of the classes */
		PackagingUnit packer = new PackagingUnit(time, inv, secPhaser);
		SealingUnit sealer = new SealingUnit(time, inv, secPhaser);
		packer.setSealingUnit(sealer);
		sealer.setPackagingUnit(packer);

		/* Using start() for each of the class function function */
		packer.start();
		sealer.start();

		/* A exception handler to check if join() and start() are waiting */
		try {
			packer.join();
			sealer.join();
		} catch (InterruptedException e) {
			System.out.println("Main thread Interrupted");
		}

		/* Printing Output */
		System.out.println("B1  Packed\t\t" + packer.b1Packed);
		System.out.println("B1  Sealed\t\t" + sealer.b1Sealed);
		System.out.println("B1  In Godown\t\t" + inv.godownB1Size());
		System.out.println("B2  Packed\t\t" + packer.b2Packed);
		System.out.println("B2  Sealed\t\t" + sealer.b2Sealed);
		System.out.println("B2  In Godown\t\t" + inv.godownB2Size());

	}
}