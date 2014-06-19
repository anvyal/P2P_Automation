package com.qualcomm.wifidirect;

import com.android.uiautomator.core.UiObject;
import com.android.uiautomator.core.UiObjectNotFoundException;
import com.android.uiautomator.core.UiScrollable;
import com.android.uiautomator.core.UiSelector;
import com.android.uiautomator.testrunner.UiAutomatorTestCase;


	public class widevine_working extends UiAutomatorTestCase{

		public void testDemo() throws UiObjectNotFoundException {   
		   
		   // Simulate a short press on the HOME button.
		   getUiDevice().pressHome();
		   
		   UiObject allAppsButton = new UiObject(new UiSelector().className("android.widget.TextView").index(2));

		   allAppsButton.clickAndWaitForNewWindow();
		   
		   UiObject appsTab = new UiObject(new UiSelector()
		      .text("Apps"));
		   
		   // Simulate a click to enter the Apps tab.
		   appsTab.click();

		   UiScrollable appViews = new UiScrollable(new UiSelector()
		      .scrollable(true));
		   
		   appViews.setAsHorizontalList();
		   
		   launchAppCalled("Widevine Demo");
		   
		   /*
		   
		   UiObject widevineApp = appViews.getChildByText(new UiSelector()
		      .className(android.widget.TextView.class.getName()), 
		      "Widevine Demo");
		   widevineApp.clickAndWaitForNewWindow();
		   
		   */
		   
		   UiObject settingsValidation = new UiObject(new UiSelector()
		      .packageName("com.widevine.demo"));
		   assertTrue("Unable to detect Settings", 
		      settingsValidation.exists());
		   
		   //UiObject downloadButton = new UiObject(new UiSelector().className("android.widget.TextView").text("Downloads"));
		   //downloadButton.click();
		   sleep(5000);
		   
		   String path = getProperty("videoFile");
		   System.out.println(path);
		   
		   //Playing Video File /sdcard/Widevine/inception_base_360p_single.wvm
		   UiObject playVideo = new UiObject(new UiSelector().className("android.widget.TextView").text(path));
		   
		   //UiObject parent =playVideo.getFromParent(index);
		   UiObject parent =playVideo.getFromParent(new UiSelector().className("android.widget.ImageView"));
		   	   
		   parent.clickAndWaitForNewWindow();
		   
		   //Acquire Rights
		   UiObject acquireRightsButton = new UiObject(new UiSelector().className("android.widget.Button").text("Acquire Rights"));
		   acquireRightsButton.click();
		   
		   sleep (3000);
		   
		   //Playing Video
		   UiObject playButton = new UiObject(new UiSelector().className("android.widget.Button").text("Play"));
		   playButton.click();
		   
		   ///sdcard/Widevine/inception_base_360p_single.wvm
		   
		   sleep (5000);
		   getUiDevice().pressBack();
		   
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
