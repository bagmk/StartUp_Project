package com.example.tinderclone.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.tinderclone.R
import com.example.tinderclone.activity.TinderCallback
import com.google.firebase.database.DatabaseReference


class MatchesFragment : Fragment() {

    private lateinit var userId:String
    private lateinit var userDatabase:DatabaseReference
    private lateinit var chatDatabase:DatabaseReference
    private var callback: TinderCallback? = null

    fun setCallback(callback: TinderCallback) {
        this.callback=callback
        userId=callback.onGetUserId()
        userDatabase=callback.getUserDatabase()
        chatDatabase=callback.getChatDatabase()

    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_matches, container, false)
    }

}