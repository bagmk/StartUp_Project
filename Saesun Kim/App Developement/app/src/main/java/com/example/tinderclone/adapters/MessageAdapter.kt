package com.example.tinderclone.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.tinderclone.Message
import com.example.tinderclone.R

class MessageAdapter(private var messages: ArrayList<Message>, val userId: String) :
    RecyclerView.Adapter<MessageAdapter.MessageViewHolder>() {

    companion object {
        val MESSAGE_CURRENT_USER = 1
        val MESSAGE_OTHER_USER = 2
    }

    class MessageViewHolder(private val view: View) : RecyclerView.ViewHolder(view) {

        fun bind(message: Message) {
            view.findViewById<TextView>(R.id.messageTV).text = message.message
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, itemrViewType: Int): MessageViewHolder {
        if (itemrViewType == MESSAGE_CURRENT_USER) {
            return MessageViewHolder(
                LayoutInflater.from(parent.context).inflate(
                    R.layout.item_current_user_message,
                    parent,
                    false
                )
            )
        } else {            return MessageViewHolder(
            LayoutInflater.from(parent.context).inflate(
                R.layout.item_other_user_message,
                parent,
                false))
        }
    }

    override fun onBindViewHolder(holder: MessageViewHolder, position: Int) {
        holder.bind(messages[position])
    }

    override fun getItemViewType(position: Int): Int {
        if (messages[position].sentBy.equals(userId)) {
            return MESSAGE_CURRENT_USER
        } else {
            return MESSAGE_OTHER_USER
        }
    }

    override fun getItemCount(): Int {

    }

}