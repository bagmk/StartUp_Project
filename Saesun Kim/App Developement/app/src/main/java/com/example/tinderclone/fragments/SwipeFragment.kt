package com.example.tinderclone.fragments

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import com.example.tinderclone.R
import com.example.tinderclone.User
import com.example.tinderclone.activity.TinderCallback
import com.example.tinderclone.adapters.CardsAdapter
import com.example.tinderclone.util.DATA_GENDER
import com.example.tinderclone.util.DATA_MATCHES
import com.example.tinderclone.util.DATA_SWIPES_LEFT
import com.example.tinderclone.util.DATA_SWIPES_RIGHT
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ValueEventListener
import com.lorentzos.flingswipe.SwipeFlingAdapterView
import kotlinx.android.synthetic.main.fragment_profile.view.*
import kotlinx.android.synthetic.main.fragment_swipe.*


class SwipeFragment : Fragment() {
    private var callback: TinderCallback? = null
    private lateinit var userId: String
    private lateinit var userDatabase: DatabaseReference
    private var cardsAdapter: ArrayAdapter<User>? = null
    private var rowItems = ArrayList<User>()

    private var preferredGender: String? = null


    fun setCallback(callback: TinderCallback) {
        this.callback = callback
        userId = callback.onGetUserId()
        userDatabase = callback.getUserDatabase()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_swipe, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        userDatabase.child(userId).addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(p0: DataSnapshot) {
                val user = p0.getValue(User::class.java)
                preferredGender = user?.preferredGender
                populateItems()
            }

            override fun onCancelled(p0: DatabaseError) {

            }
        })


        cardsAdapter = CardsAdapter(context, R.layout.item, rowItems)

        frame.adapter = cardsAdapter
        frame.setFlingListener(object : SwipeFlingAdapterView.onFlingListener {
            override fun removeFirstObjectInAdapter() {
            }

            override fun onLeftCardExit(p0: Any?) {
            }

            override fun onRightCardExit(p0: Any?) {
            }

            override fun onAdapterAboutToEmpty(p0: Int) {
            }

            override fun onScroll(p0: Float) {
            }
        })
    }

    fun populateItems() {
        noUsersLayout.visibility = View.GONE
        progressLayout.visibility = View.VISIBLE
        val cardsQuery = userDatabase.orderByChild(DATA_GENDER).equalTo(preferredGender)
        cardsQuery.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onCancelled(p0: DatabaseError) {
            }

            override fun onDataChange(p0: DataSnapshot) {
                p0.children.forEach { child ->
                    val user = child.getValue(User::class.java)
                    if (user != null) {
                        var showUser = true
                        if (child.child(DATA_SWIPES_LEFT).hasChild(userId) ||
                            child.child(DATA_SWIPES_RIGHT).hasChild(userId) ||
                            child.child(DATA_MATCHES).hasChild(userId)
                        ) {
                            showUser = false
                        }
                        if (showUser) {
                            rowItems.add(user)
                            cardsAdapter?.notifyDataSetChanged()
                        }
                    }
                }
                progressLayout.visibility = View.GONE
                if (rowItems.isEmpty()) {
                    noUsersLayout.visibility = View.VISIBLE
                }
            }
        })
    }

}