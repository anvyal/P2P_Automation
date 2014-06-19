package com.qualcomm.wifidirect;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.lang.reflect.Method;

public class print2File {

	public void printLog(String Log) {

		String serial = new String();
		try {
			Class<?> c = Class.forName("android.os.SystemProperties");
			Method get = c.getMethod("get", String.class);
			serial = (String) get.invoke(c, "ro.serialno");
		} catch (Exception ignored) {
		}

		PrintWriter out;
		try {
			out = new PrintWriter("/sdcard/WiFiDirectLog_" + serial
					+ ".txt");
			out.print(Log);
			out.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("Unable to Log on file: "+Log);
		}

	}
}
