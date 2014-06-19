package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;

public class searchDevices extends UiAutomatorTestCase {

	public void testDemo() throws UiObjectNotFoundException,
			FileNotFoundException {

		UiObject searchDevices = new UiObject(new UiSelector().className(
				"android.widget.TextView").description("Search for devices"));
		if (searchDevices != null) {
			searchDevices.click();
			sleep(5000);
		}

	}
}
