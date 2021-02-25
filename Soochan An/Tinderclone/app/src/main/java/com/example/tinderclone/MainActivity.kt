package com.example.tinderclone

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.Toast
import com.lorentzos.flingswipe.SwipeFlingAdapterView

class MainActivity : AppCompatActivity() {

    private var al = new ArrayList<string>()
    private var arrayAdator: ArrayAdapter<String>? = null
    private var i = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        al.add("php");
        al.add("c");
        al.add("python");
        al.add("java");

        //choose your favorite adapter
        arrayAdapter =  ArrayAdapter(this, R. layout.item, R.id.helloText, al )

        //set the listener and the adapter
        val adapter: Any = frame.setAdapter(arrayAdapter);
        frame.setFlingListener(object: SwipeFlingAdapterView.onFlingListener {
            override fun removeFirstObjectInAdapter() { Log.d("LIST", "removed object!");
                al.removeAt(0);
                arrayAdapter.notifyDataSetChanged();
            }

            override fun onLeftCardExit(p0: Any?) {
                Toast.makeText(this@MyActivity.this, "Left!", Toast.LENGTH_SHORT).show();
            }

            override fun onRightCardExit(p0: Any?) {
                Toast.makeText(this@MainActivity, "Right!", Toast.LENGTH_SHORT).show();
            }

            override fun onAdapterAboutToEmpty(p0: Int) {
                al.add("XML $1")
            };
                arrayAdapter?.notifyDataSetChanged();
                Log.d("LIST", "notified");
                i++;
            }

            override fun onScroll(p0: Float) {
            }
    }
}