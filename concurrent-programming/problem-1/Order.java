/* 
	Check Merchandise.java for compilation process
*/

/* Extending Class order with threads and initialize variables to use in the functions of Order */
public class Order extends Thread {
	char size;
	int quantity;
	int orderNum;
	Inventory inv;
	int s, m, l, c;

	/* This Order Function will be called from Merchandise class */
	Order(char size, int quantity, int orderNum, Inventory inv, int s, int m, int l, int c) {
		/* Store the values from Merchandise in variables from this class */
		this.size = size;
		this.quantity = quantity;
		this.inv = inv;
		this.orderNum = orderNum;
		this.s = s;
		this.m = m;
		this.l = l;
		this.c = c;

		/* start() is initiated, Threads will be created at this instance */
		start();
	}

	/* run() is used in corresspondance with start() */
	public void run() {
		/* Synchornised blocks on inventory, This brings the monitor */
		synchronized (inv) {

			/* Check the item */
			if (size == 'S') {
				/* if the items are more than quantity required order is succesfull */
				if (inv.s >= quantity) {
					inv.s = inv.s - quantity;
					s = inv.s;

					/* Print order is success */
					System.out.print("Order " + orderNum + " is successful\n");
				} else
					/* Else Order is failed */
					System.out.print("Order " + orderNum + " failed\n");
			}

			if (size == 'M') {
				/* if the items are more than quantity required order is succesful */
				if (inv.m >= quantity) {
					inv.m = inv.m - quantity;
					m = inv.m;

					/* Print order is success */
					System.out.print("Order " + orderNum + " is successful\n");
				} else
					/* Else Order is failed */
					System.out.print("Order " + orderNum + " failed\n");
			}

			/* Check the item */
			if (size == 'L') {
				/* if the items are more than quantity required order is succesful */
				if (inv.l >= quantity) {
					inv.l = inv.l - quantity;
					l = inv.l;
					/* Print order is success */
					System.out.print("Order " + orderNum + " is successful\n");
				} else
					/* Else Order is failed */
					System.out.print("Order " + orderNum + " failed\n");
			}

			/* Check the item */
			if (size == 'C') {
				/* if the items are more than quantity required order is succesful */
				if (inv.c >= quantity) {
					inv.c = inv.c - quantity;
					c = inv.c;
					/* Print order is success */
					System.out.print("Order " + orderNum + " is successful\n");
				} else
					/* Else Order is failed */
					System.out.print("Order " + orderNum + " failed\n");
			}

			/* Show the Inventory list to the user */
			System.out.print("Inventory:  S :" + s + " , M :" + m + " , L :" + l + " , C :" + c + "\n");

		}
	}
}
