package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class sendInvite extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";

	public void testDemo() throws UiObjectNotFoundException, FileNotFoundException {

		String peerID = getProperty("PeerID");
		int success = 0;
		for (int i = 1; i <= 3 && success == 0; i++) {
			System.out.println("Trying to Send Invitation for " + i + " time");
			success = connect(peerID);
		}
		if (success == 0) {
			Log.e(LOG_TAG, "Couldn't find peerID in list to send the invite");
		}

	}

	public int connect(String peerID) {
		int success = 0;
		UiScrollable peerDevices = new UiScrollable(new UiSelector().className("android.widget.ListView").scrollable(true));
		UiObject P2PdeviceID;
		for (int j = 0; j < 1; j++) {
			try {
				P2PdeviceID = peerDevices.getChild(new UiSelector().className("android.widget.TextView").textContains(peerID));
				if (P2PdeviceID != null) {
					Log.e(LOG_TAG, "Sending Invite to device with PeerID: " + peerID);
					P2PdeviceID.click();
					success = 1;
					break;
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Did not find device with PeerID: " + peerID + e.getLocalizedMessage());
			}

			// ////

			System.out.println("scrolling down and searching again..");
			try {
				peerDevices.scrollForward();
			} catch (UiObjectNotFoundException e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}

			try {
				P2PdeviceID = peerDevices.getChild(new UiSelector().className("android.widget.TextView").textContains(peerID));
				if (P2PdeviceID != null) {
					Log.e(LOG_TAG, "Sending Invite to device with PeerID: " + peerID);
					P2PdeviceID.click();
					success = 1;
					break;
				}
			} catch (UiObjectNotFoundException e) {
				System.out.println("Did not find device with PeerID: " + peerID + e.getLocalizedMessage());
				System.out.println("Scrolling to top..");
				try {
					peerDevices.scrollToBeginning(3);
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
