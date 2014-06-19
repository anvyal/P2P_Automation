package com.qualcomm.wifidirect;


import android.util.Log;

import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiWatcher;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;
 
public class watcherTry extends UiAutomatorTestCase {
 
	
	private static final String LOG_TAG = "AnveshDemoLog";
	private static final String MYOKCANCELDIALOGWATCHER_STRING = "CantPlayVideoWatcher";
	
 
		
	public void testWatcherDemoTestExample1() throws UiObjectNotFoundException {
		Log.w(LOG_TAG, "Starting our test!");

		
		/////////////////////////////////////////////////////////////////////
		// This concludes the section devoted to simply launching the app. //
		/////////////////////////////////////////////////////////////////////
 
		// Define watcher
		UiWatcher CantPlayVideoWatcher = new UiWatcher() {
			@Override
			public boolean checkForCondition() {
				UiObject okCancelDialog = new UiObject(new UiSelector().textStartsWith("Can't play"));
				if(okCancelDialog.exists()){
					Log.w(LOG_TAG, "Can't Play this Video Observed");
					UiObject okButton = new UiObject(new UiSelector().className("android.widget.Button").text("OK"));
					try {
						okButton.click();
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
		UiDevice.getInstance().registerWatcher(MYOKCANCELDIALOGWATCHER_STRING, CantPlayVideoWatcher);
 
		// Run watcher
		UiDevice.getInstance().runWatchers();
 
		

	}
 
}