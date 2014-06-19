rem ant build
cd bin
adb push WiFiDirect_UIAutomator.jar /data/local/tmp/
adb shell uiautomator runtest WiFiDirect_UIAutomator.jar -c com.qualcomm.wifidirect.sendInvite
cd ..
