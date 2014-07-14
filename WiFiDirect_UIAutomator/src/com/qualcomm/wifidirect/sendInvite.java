package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;
import java.io.IOException;

import android.util.Log;

import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiWatcher;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class sendInvite extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";
	private static final String MYOKCANCELDIALOGWATCHER_STRING = "InvitationWatcher";

	public void testDemo() throws UiObjectNotFoundException, FileNotFoundException {

		String peerID = getProperty("PeerID");
		int success = 0;

		// set P2Ppin to NA
		try {
			String progArray = "setprop P2Ppin NA";
			java.lang.Process p = Runtime.getRuntime().exec(progArray);
		} catch (IOException e) {
			e.printStackTrace();
		}

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
		UiScrollable peerDevices = new UiScrollable(new UiSelector().className("android.widget.ListView"));
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
		sleep(2000);
		invitePIN();
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

	public void invitePIN() {

		// Define watcher
		UiWatcher InvitationWatcher = new UiWatcher() {
			@Override
			public boolean checkForCondition() {
				UiObject okCancelDialog = new UiObject(new UiSelector().textContains("Invitation sent"));
				UiObject pin;
				String pinID = null;

				if (okCancelDialog.exists()) {
					Log.w(LOG_TAG, "Sending PIN Invitation !");
					UiObject pinParent = new UiObject(new UiSelector().className("android.widget.TextView").text("PIN:"));
					try {
						pin = pinParent.getFromParent(new UiSelector().className("android.widget.TextView").index(1));
						pinID = pin.getText();
					} catch (UiObjectNotFoundException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}

					System.out.println("Found Box and PIN ID is " + pinID);

					UiObject okButton = new UiObject(new UiSelector().className("android.widget.Button").text("OK"));
					try {
						okButton.click();
						try {
							String progArray = "setprop P2Ppin " + pinID;
							java.lang.Process p = Runtime.getRuntime().exec(progArray);
						}

						catch (IOException e) {
							e.printStackTrace();
						}
					} catch (UiObjectNotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

					return (okCancelDialog.waitUntilGone(25000));
				}
				return false;
			}
		};

		// Register watcher
		UiDevice.getInstance().registerWatcher(MYOKCANCELDIALOGWATCHER_STRING, InvitationWatcher);

		// Run watcher
		sleep(1000);
		UiDevice.getInstance().runWatchers();
		// getUiDevice().pressBack();
	}
}
