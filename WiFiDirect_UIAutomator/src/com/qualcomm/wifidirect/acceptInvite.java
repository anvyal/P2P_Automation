package com.qualcomm.wifidirect;

import java.io.IOException;

import android.util.Log;

import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiWatcher;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class acceptInvite extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";
	private static final String MYOKCANCELDIALOGWATCHER_STRING = "InvitationWatcher";

	public void testDemo() throws UiObjectNotFoundException {

		Log.e(LOG_TAG, "Waiting for Invitation!");

		boolean success = false;

		// set P2Pinvitation to NA
		try {
			String progArray = "setprop P2Pinvitation NA";
			java.lang.Process p = Runtime.getRuntime().exec(progArray);
		} catch (IOException e) {
			e.printStackTrace();
		}

		for (int i = 1; i <= 5 && !success; i++) {
			System.out.println("Trying to Accept Invite for " + i + " time");

			accept();

			if (getProperty("P2Pinvitation").equals("Accepted")) {
				success = true;
			}			
		}
		if (success) {
			Log.e(LOG_TAG, "Didn't get any invitation from peer");
		}

	}

	public void accept() {

		// Define watcher
		UiWatcher InvitationWatcher = new UiWatcher() {
			@Override
			public boolean checkForCondition() {
				UiObject okCancelDialog = new UiObject(new UiSelector().textContains("Invitation to connect"));
				if (okCancelDialog.exists()) {
					Log.w(LOG_TAG, "Recieved Invitation !");
					UiObject okButton = new UiObject(new UiSelector().className("android.widget.Button").text("Accept"));
					try {
						okButton.click();
						try {
							String progArray = "setprop P2Pinvitation Accepted";
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
		sleep(3000);
		UiDevice.getInstance().runWatchers();
		// getUiDevice().pressBack();
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