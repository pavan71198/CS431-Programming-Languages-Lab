/*
	  Compile using $javac Merchandise.java 
	  Execute $java Merchandise 
*/

/* Libraries */
import java.util.*;
import java.lang.*;
import java.io.*;

/* Defining MainClass */
public class Merchandise {

	public static void main(String[] args) {
		/* calling inventory to store the values in inventory */
		Inventory inv = new Inventory();

		/* Scanner to read values and add to Inventory */
		Scanner sc = new Scanner(System.in);
		System.out.print(" Add your inventory list: \n");

		/* Store S quantity in inventory */
		System.out.print(" S :");
		inv.s = sc.nextInt();

		/* Store M quantity in inventory */
		System.out.print(" M :");
		inv.m = sc.nextInt();

		/* Store L quantity in inventory */
		System.out.print(" L :");
		inv.l = sc.nextInt();

		/* Store C quantity in inventory */
		System.out.print(" C :");
		inv.c = sc.nextInt();

		System.out.print("\n Number of Students Ordering is: ");
		int n;
		int j;
		n = sc.nextInt();

		/* Array to store if S or M or L or C for each student */
		char size[] = new char[n];

		/* Array to store quantity of each of the above orders */
		int quantity[] = new int[n];

		/* Scanning the input */
		for (int i = 0; i < n; i++) {
			sc.nextInt();
			size[i] = sc.next().charAt(0);
			quantity[i] = sc.nextInt();
		}

		/* Creating local variables to send to Order Function */
		int s = inv.s;
		int m = inv.m;
		int l = inv.l;
		int c = inv.c;

		/* Display the initial inventory list */
		System.out.print("Inventory is:");
		System.out.print(" S :" + inv.s + " , M :" + inv.m + " , L :" + inv.l + " , C :" + inv.c + "\n");

		/* Pass on the data to Order Class to create threads */
		for (int i = 0; i < n; i++) {
			new Order(size[i], quantity[i], i + 1, inv, s, m, l, c);
		}
	}
}
