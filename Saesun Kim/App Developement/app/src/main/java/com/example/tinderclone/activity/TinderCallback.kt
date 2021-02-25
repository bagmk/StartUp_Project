package com.example.tinderclone.activity

import com.google.firebase.database.DatabaseReference

interface TinderCallback {

    fun onSignout()
    fun onGetUserId(): String
    fun getUserDatabase(): DatabaseReference
    fun profileComplete()
    fun startActivityForPhoto()
}