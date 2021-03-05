package com.example.tinderclone.activity

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import com.bumptech.glide.Glide
import com.example.tinderclone.Message
import com.example.tinderclone.R
import com.example.tinderclone.User
import com.example.tinderclone.adapters.MessageAdapter
import com.example.tinderclone.util.DATA_CHATS
import com.example.tinderclone.util.DATA_MESSAGES
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_chat.*
import java.util.*
import kotlin.collections.ArrayList

class ChatActivity : AppCompatActivity() {
    private var chatId:String?=null
    private var userId:String?=null
    private var imageUrl:String?=null
    private var otherUserId:String?=null

    private lateinit var chatDatabase: DatabaseReference
    private lateinit var messageAdapter: MessageAdapter
    private val chatMessageListener = object : ChildEventListener{
        override fun onChildAdded(p0: DataSnapshot, p1: String?) {
            val message = p0.getValue(Message::class.java)
            if(message != null){
                messageAdapter.addMessage(message)
                messageRV.post{
                    messageRV.smoothScrollToPosition(messageAdapter.itemCount-1)
                }
            }
        }

        override fun onChildChanged(p0: DataSnapshot, p1: String?) {


        }

        override fun onChildRemoved(p0: DataSnapshot) {

        }

        override fun onChildMoved(p0: DataSnapshot, p1: String?) {

        }

        override fun onCancelled(p0: DatabaseError) {

        }


    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chat)

        chatId=intent.extras?.getString(PARAM_CHAT_ID)
        userId=intent.extras?.getString(PARAM_USER_ID)
        imageUrl=intent.extras?.getString(PARAM_IMAGE_URL)
        otherUserId=intent.extras?.getString(PARAM_OTHER_USER_ID)

        if(chatId.isNullOrEmpty()||userId.isNullOrEmpty()||imageUrl.isNullOrEmpty()||otherUserId.isNullOrEmpty()){

            Toast.makeText(this,"Chat room error",Toast.LENGTH_SHORT).show()
            finish()
        }

        chatDatabase=FirebaseDatabase.getInstance().reference.child(DATA_CHATS)
        messageAdapter= MessageAdapter(ArrayList(), userId!!)
        messageRV.apply{
            setHasFixedSize(false)
            layoutManager = LinearLayoutManager(context)
            adapter = messageAdapter
        }
        chatDatabase.child(chatId!!).child(DATA_MESSAGES).addChildEventListener(chatMessageListener)

        chatDatabase.child(chatId!!).addListenerForSingleValueEvent(object: ValueEventListener{
            override fun onDataChange(p0: DataSnapshot) {
                p0.children.forEach{value->
                    val key = value.key
                    val user = value.getValue(User::class.java)
                    if(!key.equals(userId)){
                        topNameTV.text = user?.name
                        Glide.with(this@ChatActivity)
                            .load(user?.imageUrl)
                            .into(topPhotoIV)
                        topPhotoIV.setOnClickListener{
                            startActivity(UserInfoActivity.newIntent(this@ChatActivity,otherUserId))
                        }
                    }

                }
            }

            override fun onCancelled(p0: DatabaseError) {

            }


        })

    }


    fun onSend(v: View){
        val message = Message(userId,messageET.text.toString(),Calendar.getInstance().time.toString())
        val key = chatDatabase.child(chatId!!).child(DATA_MESSAGES).key
        if (!key.isNullOrEmpty()){
            chatDatabase.child(chatId!!).child(DATA_MESSAGES).child(key).setValue(message)
        }
        messageET.setText("",TextView.BufferType.EDITABLE)
    }
    companion object {

        private val PARAM_CHAT_ID = "Chat id"
        private val PARAM_USER_ID = "User id"
        private val PARAM_IMAGE_URL = "Image id"
        private val PARAM_OTHER_USER_ID = "Other user id"
        fun newIntent(context: Context?, chatId:String?, userId:String?,imageUrl: String?, otherUserId:String?): Intent{
            val intent = Intent(context,ChatActivity::class.java)
            intent.putExtra(PARAM_CHAT_ID,chatId)
            intent.putExtra(PARAM_USER_ID,userId)
            intent.putExtra(PARAM_IMAGE_URL,imageUrl)
            intent.putExtra(PARAM_OTHER_USER_ID,otherUserId)
            return intent

        }
    }
}