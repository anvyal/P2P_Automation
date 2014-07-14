rem ant build
cd bin
adb -s 141ff73 push WiFiDirect_UIAutomator.jar /data/local/tmp/
adb -s 141ff73 shell uiautomator runtest WiFiDirect_UIAutomator.jar -c com.qualcomm.wifidirect.sendInvite
cd ..
