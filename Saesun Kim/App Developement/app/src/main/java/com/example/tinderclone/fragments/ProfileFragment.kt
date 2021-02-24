package com.example.tinderclone.fragments

import android.os.Bundle
import android.service.autofill.UserData
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.tinderclone.R
import com.example.tinderclone.activity.TinderCallback
import com.google.firebase.database.DatabaseReference


class ProfileFragment : Fragment() {

    private lateinit var userId: String
    private lateinit var userData: DatabaseReference

    private var callback:TinderCallback? = null

    fun setCallback(callback:TinderCallback) {
        this.callback=callback

    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_profile, container, false)
    }

}