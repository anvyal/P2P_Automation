package com.qualcomm.wifidirect;

import android.util.Log;

import com.android.uiautomator.core.UiDevice;
import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.core.UiWatcher;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;


	public class CopyOfplayVideo extends UiAutomatorTestCase{
		
		private static final String LOG_TAG = "AnveshDemoLog";
		private static final String MYOKCANCELDIALOGWATCHER_STRING = "CantPlayVideoWatcher";

		public void testDemo() throws UiObjectNotFoundException {  
			
			
				 
			launchAppCalled("Android_7212");			
		   
		   
		   
		   
		   
		   
		   
		}
		
		
		//Function Get Properties from android system
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
		

	    protected static void launchAppCalled(String nameOfAppToLaunch) throws UiObjectNotFoundException {
	        UiScrollable appViews = new UiScrollable(new UiSelector().scrollable(true));
	          // Set the swiping mode to horizontal (the default is vertical)
	          appViews.setAsHorizontalList();
	          appViews.scrollToBeginning(10);  // Otherwise the Apps may be on a later page of apps.
	          int maxSearchSwipes = appViews.getMaxSearchSwipes();

	          UiSelector selector;
	          selector = new UiSelector().className(android.widget.TextView.class.getName());
	          
	          UiObject appToLaunch;
	          
	          // The following loop is to workaround a bug in Android 4.2.2 which
	          // fails to scroll more than once into view.
	          for (int i = 0; i < maxSearchSwipes; i++) {

	              try {
	                  appToLaunch = appViews.getChildByText(selector, nameOfAppToLaunch);
	                  if (appToLaunch != null) {
	                      // Create a UiSelector to find the Settings app and simulate      
	                      // a user click to launch the app.
	                      appToLaunch.clickAndWaitForNewWindow();
	                      break;
	                  }
	              } catch (UiObjectNotFoundException e) {
	                  System.out.println("Did not find match for " + e.getLocalizedMessage());
	              }

	              for (int j = 0; j < i; j++) {
	                  appViews.scrollForward();
	                  System.out.println("scrolling forward 1 page of apps.");
	              }
	          }
	    }

}