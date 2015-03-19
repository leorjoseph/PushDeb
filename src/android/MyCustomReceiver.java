package org.apache.cordova.core;

import java.util.Iterator;

import org.apache.cordova.PluginResult;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class MyCustomReceiver extends BroadcastReceiver {
	private static final String TAG = "MyCustomReceiver";
	private String msg = "";
	SqliteController mSqliteController;
	boolean flag = false;

	@Override
	public void onReceive(Context context, Intent intent) {
		try {
			if (intent == null) {
				Log.d(TAG, "Receiver intent null");
			} else {
				String action = intent.getAction();
				Log.d(TAG, "got action " + action);
				if (action.equals("photonworld")) {
					String channel = intent.getExtras().getString(
							"com.parse.Channel");
					JSONObject json = new JSONObject(intent.getExtras()
							.getString("com.parse.Data"));

					Log.d(TAG, "got action " + action + " on channel "
							+ channel + " with:");
					mSqliteController = new SqliteController(context);
					Iterator itr = json.keys();
					while (itr.hasNext()) {
						String key = (String) itr.next();
						if (key.equals("alert")) {
							msg = json.getString(key);
							if (msg != null) {
								mSqliteController.insertNotification(msg);
							}

						}
						Log.d(TAG, "..." + key + " => " + json.getString(key));
					}
				}
			}
			
			Log.d(TAG,"JSONException: " + mSqliteController.getAllNotifications());

			// Relative outPut for NotificationCenter
			/*
			 * [{NotificationCenterId=1, Notification=PhotonWorld},
			 * {NotificationCenterId=2, Notification=PhotonWorld}]
			 */
		} catch (JSONException e) {
			Log.d(TAG, "JSONException: " + e.getMessage());
		}
	}
}
