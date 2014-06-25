rem ant build
cd bin
adb -s 1420e50 push WiFiDirect_UIAutomator.jar /data/local/tmp/
adb -s 1420e50 shell uiautomator runtest WiFiDirect_UIAutomator.jar -c com.qualcomm.wifidirect.isConnected
cd ..
