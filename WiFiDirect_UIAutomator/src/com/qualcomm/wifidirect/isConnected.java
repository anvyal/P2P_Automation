package com.qualcomm.wifidirect;

import java.io.IOException;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class isConnected extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";	

	public void testDemo() throws UiObjectNotFoundException {

		System.out.println("Waiting for Connection Confirmation..!");
		Log.e(LOG_TAG, "Waiting for Connection Confirmation..!");

		boolean success = false;

		// set P2Pinvitation to NA
		try {
			String progArray = "setprop P2PConnected NA";
			java.lang.Process p = Runtime.getRuntime().exec(progArray);
		} catch (IOException e) {
			e.printStackTrace();
		}

		for (int i = 1; i <= 7 && !success; i++) {
			System.out.println("Trying to Check for Connection status for " + i + " time");

			checkConnection();
			System.out.println(getProperty("P2PConnected"));
			if (getProperty("P2PConnected").equals("Accepted")) {
				success = true;				
			}
		}
		if (!success) {
			System.out.println("\nCouldn't establish P2P connection..");
			Log.e(LOG_TAG, "Couldn't establish P2P connection..");
		}

	}

	public void checkConnection() {

		UiObject peerDevices = new UiObject(new UiSelector().className("android.widget.ListView"));
		System.out.println("In checkConnection()");
		UiObject P2PdeviceID;
		for (int j = 0; j < 1; j++) {
			try {
				P2PdeviceID = peerDevices.getChild(new UiSelector().className("android.widget.TextView").textContains("Connected"));
				if (P2PdeviceID != null) {
					P2PdeviceID.click();
					System.out.println("P2P Connection established");
					Log.e(LOG_TAG, "P2P Connection established");
					// P2PdeviceID.click();
					try {
						String progArray = "setprop P2PConnected Accepted";
						java.lang.Process p = Runtime.getRuntime().exec(progArray);
					} catch (IOException e) {
						e.printStackTrace();
					}
					sleep(2000);
					UiObject cancelButton = new UiObject(new UiSelector().className("android.widget.Button").textContains("Cancel"));
					try{
						cancelButton.click();
					}catch (UiObjectNotFoundException e) {
						e.printStackTrace();
					}					
				}
				else {
					System.out.println("In Else Block");
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Seems that P2P is not yet connected.. Checking again.. " + e.getLocalizedMessage());
			}

		}

	}

	public String getProperty(String propName) {
		String propValue = null;
		try {
			propValue = (String) Class.forName("android.os.SystemProperties").getMethod("get", new Class[] { String.class }).invoke(null, propName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return propValue;
	}
}