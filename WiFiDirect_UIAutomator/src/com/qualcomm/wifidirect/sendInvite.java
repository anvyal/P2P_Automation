package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class sendInvite extends UiAutomatorTestCase {

	String LOG = "WiFiDirectAutomation";
	public void testDemo() throws UiObjectNotFoundException,
			FileNotFoundException {
		// launchAppCalled("Android_7212");

		String peerID = getProperty("PeerID");
		int success = 0;
		for (int i = 1; i <= 3 && success == 0; i++) {
			System.out.println("Trying to Send Invitation for " + i + " time");
			success = connect(peerID);
		}
		if(success==0)
		{
			Log.e(LOG,"Couldn't find peerID in list to send the invite");
		}

	}

	public int connect(String peerID) {
		int success = 0;
		UiScrollable peerDevices = new UiScrollable(new UiSelector().className(
				"android.widget.ListView").scrollable(true));
		UiObject P2PdeviceID;
		for (int j = 0; j < 2; j++) {
			try {
				P2PdeviceID = peerDevices.getChild(new UiSelector().className(
						"android.widget.TextView").textContains(peerID));
				if (P2PdeviceID != null) {
					// Create a UiSelector to find the Settings app and simulate
					// a user click to launch the app.
					P2PdeviceID.clickAndWaitForNewWindow();
					success = 1;
					break;
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Did not find peer device in list "
						+ e.getLocalizedMessage());
			}

			try {
				System.out.println("scrolling down..");
				peerDevices.scrollForward();
			} catch (UiObjectNotFoundException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
			}
			
		}

		return success;
	}

	public String getProperty(String propName) {
		String propValue = null;
		try {
			propValue = (String) Class.forName("android.os.SystemProperties")
					.getMethod("get", new Class[] { String.class })
					.invoke(null, propName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return propValue;
	}

}
