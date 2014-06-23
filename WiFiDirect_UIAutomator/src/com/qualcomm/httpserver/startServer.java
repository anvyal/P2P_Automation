package com.qualcomm.httpserver;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class startServer extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";

	public void testDemo() {
		UiObject stopServer = new UiObject(new UiSelector().className("android.widget.ToggleButton").text("Stop server"));
		try {
			if (stopServer.isEnabled() == true) {
				Log.e(LOG_TAG, "KWS HTTP Server already started");

				UiObject serverLog = new UiObject(new UiSelector().className("android.widget.EditText").index(1));
				String temp = serverLog.getText();
				System.out.println(temp);
				//new print2File(temp);
			}

		} catch (UiObjectNotFoundException e) {
			UiObject startServer = new UiObject(new UiSelector().className("android.widget.ToggleButton").text("Start server"));
			try {
				Log.e(LOG_TAG, "Starting KWS HTTP Server");
				startServer.clickAndWaitForNewWindow();
				sleep(2000);
				UiObject serverLog = new UiObject(new UiSelector().className("android.widget.EditText").index(1));
				String temp = serverLog.getText();
				System.out.println(temp);
			} catch (UiObjectNotFoundException e1) {
				Log.e(LOG_TAG, "Unable to KWS HTTP Start Server");
			}
		}
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