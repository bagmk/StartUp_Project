package com.example.tinderclone.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import com.example.tinderclone.R
import com.example.tinderclone.User

class CardsAdapter(context: Context, resourceId: Int, users: List<User>) :
    ArrayAdapter<User>(context, resourceId, users) {
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        var user = getItem(position)
        var finalView =
            convertView ?: LayoutInflater.from(context).inflate(R.layout.item, parent, false)
        var name = finalView.findViewById<>()

    }


}