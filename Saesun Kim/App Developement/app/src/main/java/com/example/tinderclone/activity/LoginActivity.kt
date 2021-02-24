package com.example.tinderclone.activity

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.example.tinderclone.R

class LoginActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
    }

    fun onLogin(v: View){
        startActivity(MainActivity.newIntent(this))

    }
    companion object{
        fun newIntent(context: Context?) = Intent(context,LoginActivity::class.java)


    }
}