package com.example.tinderclone.activity

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TableLayout
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.example.tinderclone.R
import com.example.tinderclone.fragments.MatchesFragment
import com.example.tinderclone.fragments.ProfileFragment
import com.example.tinderclone.fragments.SwipeFragment
import com.example.tinderclone.util.Data_USERS
import com.google.android.material.tabs.TabLayout
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_main.*


class TinderActivity : AppCompatActivity(), TinderCallback {

    private var firebaseAuth = FirebaseAuth.getInstance()
    private var userId = firebaseAuth.currentUser?.uid
    private lateinit var userDatabase:DatabaseReference

    private var profileFragment: ProfileFragment? = null
    private var swipeFragment: SwipeFragment? = null
    private var matchesFragment: MatchesFragment? = null

    private var profileTab: TabLayout.Tab? = null
    private var swipeTab: TabLayout.Tab? = null
    private var matchesTab: TabLayout.Tab? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if(userId.isNullOrEmpty()){
            onSignout()
        }

        userDatabase = FirebaseDatabase.getInstance().reference.child(Data_USERS)

        profileTab = navigationTabs.newTab()
        swipeTab = navigationTabs.newTab()
        matchesTab = navigationTabs.newTab()

        profileTab?.icon = ContextCompat.getDrawable(this, R.drawable.tab_profile)
        swipeTab?.icon = ContextCompat.getDrawable(this, R.drawable.tab_swipe)
        matchesTab?.icon = ContextCompat.getDrawable(this, R.drawable.tab_matches)

        navigationTabs.addTab(profileTab!!)
        navigationTabs.addTab(swipeTab!!)
        navigationTabs.addTab(matchesTab!!)


        navigationTabs.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
            override fun onTabReselected(tab: TabLayout.Tab?) {
                onTabSelected(tab)
            }

            override fun onTabUnselected(p0: TabLayout.Tab?) {
            }

            override fun onTabSelected(tab: TabLayout.Tab?) {
                when (tab) {
                    profileTab -> {
                        if (profileFragment == null) {
                            profileFragment = ProfileFragment()
                            profileFragment!!.setCallback(this@TinderActivity)
                        }
                        replaceFragment(profileFragment!!)
                    }
                    swipeTab -> {
                        if (swipeFragment == null) {
                            swipeFragment = SwipeFragment()
                            swipeFragment!!.setCallback(this@TinderActivity)
                        }
                        replaceFragment(swipeFragment!!)

                    }
                    matchesTab -> {
                        if (matchesFragment == null) {
                            matchesFragment = MatchesFragment()
                            matchesFragment!!.setCallback(this@TinderActivity)
                        }
                        replaceFragment(matchesFragment!!)

                    }
                }
            }


        })
        profileTab?.select()
    }

    fun replaceFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragmentContainer, fragment)
            .commit()
    }



    override fun onSignout() {
        firebaseAuth.signOut()
        startActivity(StartupActivity.newIntent(this))
        finish()
    }


    override fun onGetUserId(): String = userId!!

    override fun getUserDatabase(): DatabaseReference =userDatabase


    companion object {
        fun newIntent(context: Context?) = Intent(context, TinderActivity::class.java)
    }
}