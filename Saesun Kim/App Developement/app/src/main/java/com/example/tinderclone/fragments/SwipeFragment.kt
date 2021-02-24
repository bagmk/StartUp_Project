package com.example.tinderclone.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.tinderclone.R
import com.example.tinderclone.activity.TinderCallback


class SwipeFragment : Fragment() {
    private var callback: TinderCallback? = null

    fun setCallback(callback: TinderCallback) {
        this.callback=callback

    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_swipe, container, false)
    }
}