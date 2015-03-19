package org.apache.cordova.core;

import java.util.ArrayList;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class SqliteController extends SQLiteOpenHelper {

	public SqliteController(Context applicationcontext) {
		super(applicationcontext, "androidsqlite.photonworld", null, 1);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void onCreate(SQLiteDatabase database) {
		// TODO Auto-generated method stub
		String query;
		query = "CREATE TABLE NotificationCenter ( NotificationNbr INTEGER PRIMARY KEY, NotificationMsg TEXT)";
		database.execSQL(query);

	}

	@Override
	public void onUpgrade(SQLiteDatabase database, int version_old,
			int current_version) {
		// TODO Auto-generated method stub
		String query;
		query = "DROP TABLE IF EXISTS NotificationCenter";
		database.execSQL(query);
		onCreate(database);
	}

	public void insertNotification(String Notification ) {
		try {
			SQLiteDatabase database = this.getWritableDatabase();
			ContentValues values = new ContentValues();
			values.put("NotificationMsg", Notification);
			database.insert("NotificationCenter", null, values);
			database.close();
		} catch (Exception e) {
		   Log.d("Notification_error :" , e.toString());
		}
		
	}

	public ArrayList<String> getAllNotifications() {
		ArrayList<String> NotificationsList;
		NotificationsList = new ArrayList<String>();
		String selectQuery = "SELECT * FROM NotificationCenter";
		SQLiteDatabase database = this.getWritableDatabase();
		Cursor cursor = database.rawQuery(selectQuery, null);
		if (cursor.moveToFirst()) {
			do {
				NotificationsList.add(cursor.getString(1));
				/*HashMap<String, String> map = new HashMap<String, String>();
				//map.put("NotificationNbr", cursor.getString(0));
				map.put("NotificationMsg", cursor.getString(1));
				NotificationsList.add(map);*/
			} while (cursor.moveToNext());
		}
		return NotificationsList;
	}

	

}
