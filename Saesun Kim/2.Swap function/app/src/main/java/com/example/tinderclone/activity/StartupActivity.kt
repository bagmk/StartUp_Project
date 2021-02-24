package com.example.tinderclone.activity

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import com.example.tinderclone.R

class StartupActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_startup)
    }

    fun onLogin(v : View) {
        startActivity(LoginActivity.newIntent(this))
    }

    fun onSignup(v:View) {
        startActivity(SignupActivity.newIntent(this))
    }
}