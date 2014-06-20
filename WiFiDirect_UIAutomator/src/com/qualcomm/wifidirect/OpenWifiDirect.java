package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Method;

import android.util.Log;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class OpenWifiDirect extends UiAutomatorTestCase {

	private static final String LOG_TAG = "WiFiDirectAutomation";

	public void testDemo() throws UiObjectNotFoundException, FileNotFoundException {

		Log.e(LOG_TAG, "Starting our test!");

		UiObject wifiOption = new UiObject(new UiSelector().className("android.widget.TextView").textContains("Fi"));
		wifiOption.clickAndWaitForNewWindow();
		sleep(2000);

		UiObject moreOptions = new UiObject(new UiSelector().className("android.widget.ImageButton").description("More options"));
		moreOptions.clickAndWaitForNewWindow();

		UiObject selectP2P = new UiObject(new UiSelector().className("android.widget.TextView").textContains("Fi Direct"));
		UiObject isWiFiON = new UiObject(new UiSelector().className("android.widget.LinearLayout").index(2));

		if (isWiFiON.isEnabled() == true) {
			System.out.println("WiFi is Turned ON");
			selectP2P.clickAndWaitForNewWindow();
		} else {
			System.out.println("WiFi is Turned OFF");
			Log.e(LOG_TAG, "Couldn't Access WiFi-Direct, check if there is any issue with Device WiFi");
		}

		UiObject P2PdeviceIDparent = new UiObject(new UiSelector().className("android.widget.FrameLayout").index(1));
		UiObject P2PdeviceID = P2PdeviceIDparent.getChild(new UiSelector().className("android.widget.TextView"));

		String temp = P2PdeviceID.getText();

		String serial = null;

		try {
			String progArray = "setprop P2PdeviceID " + temp;
			java.lang.Process p = Runtime.getRuntime().exec(progArray);
		}

		catch (IOException e) {
			e.printStackTrace();
		}

		try {
			Class<?> c = Class.forName("android.os.SystemProperties");
			Method get = c.getMethod("get", String.class);
			serial = (String) get.invoke(c, "ro.serialno");
		} catch (Exception ignored) {
		}

		System.out.println();
		System.out.println(temp);
		System.out.println(serial);
		System.out.println();

		/*
		 * PrintWriter out = new PrintWriter("/sdcard/P2PdeviceID_" + serial+
		 * ".txt"); out.print(temp); out.close();
		 */

	}

}
