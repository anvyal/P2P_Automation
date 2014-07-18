package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class connectP2PWiFi extends UiAutomatorTestCase {
	private static final String LOG_TAG = "WiFiDirectAutomation";

	public void testDemo() throws UiObjectNotFoundException, FileNotFoundException {
		// Open WiFi Settings
		UiObject wifiOption = new UiObject(new UiSelector().className("android.widget.TextView").textContains("Fi"));
		try {
			wifiOption.clickAndWaitForNewWindow();
		} catch (UiObjectNotFoundException e) {
			wifiOption = new UiObject(new UiSelector().className("android.widget.TextView").textContains("WLAN"));
			try {
				wifiOption.clickAndWaitForNewWindow();
			} catch (UiObjectNotFoundException e1) {
				System.out.println("Unable to enter WiFi Settings");
			}
		}
		sleep(2000);

		String ssid = getProperty("ssid");
		int success = 0;
		for (int i = 1; i <= 3 && success == 0; i++) {
			System.out.println("Trying to Join P2P WiFi Network for " + i + " time");
			success = select(ssid);
			connect();
		}
		if (success == 0) {
			Log.e(LOG_TAG, "Couldn't find SSID in list to send the invite");
		}

	}

	private void connect() {
		// TODO Auto-generated method stub
		UiObject enterText = new UiObject(new UiSelector().className("android.widget.EditText"));
		String psk = getProperty("clientPSK");
		try {
			enterText.setText(psk);
		} catch (UiObjectNotFoundException e) {
			System.out.println("Unable to Enter PSK as Password");
		}
		UiObject connectBtn = new UiObject(new UiSelector().resourceId("android:id/button1"));
		sleep(3000);
		try {
			connectBtn.clickAndWaitForNewWindow();

		} catch (UiObjectNotFoundException e) {
			System.out.println("Unable to Enter PSK as Password");
		}

	}

	public int select(String SSID) {
		int success = 0;
		UiScrollable networkList = new UiScrollable(new UiSelector().className("android.widget.ListView"));
		UiObject P2PdeviceID;
		for (int j = 0; j < 1; j++) {
			try {
				P2PdeviceID = networkList.getChild(new UiSelector().className("android.widget.TextView").textContains(SSID));
				if (P2PdeviceID != null) {
					Log.e(LOG_TAG, "Sending Invite to network with SSID: " + SSID);
					P2PdeviceID.click();
					success = 1;
					break;
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Did not find network with SSID: " + SSID + e.getLocalizedMessage());
			}

			// ////

			System.out.println("scrolling down and searching again..");
			try {
				networkList.scrollForward();
			} catch (UiObjectNotFoundException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}

			try {
				P2PdeviceID = networkList.getChild(new UiSelector().className("android.widget.TextView").textContains(SSID));
				if (P2PdeviceID != null) {
					Log.e(LOG_TAG, "Sending Invite to network with SSID: " + SSID);
					P2PdeviceID.click();
					success = 1;
					break;
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Did not find device with SSID: " + SSID + e.getLocalizedMessage());
				System.out.println("Scrolling to top..");
				try {
					networkList.scrollToBeginning(3);
				} catch (UiObjectNotFoundException e1) {
					// Do Nothing
				}
			}
		}
		return success;
	}

	public String getProperty(String propName) {
		String propValue = null;
		try {
			propValue = (String) Class.forName("android.os.SystemProperties").getMethod("get", new Class[] { String.class }).invoke(null, propName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return propValue;
	}

}
