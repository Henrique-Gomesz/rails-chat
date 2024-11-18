class ChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = current_user.conversations.find_by(conversation_uuid: params[:conversation_uuid])
    if conversation
      stream_from "Chat_#{params[:conversation_uuid]}"
    end
  end

  def unsubscribed
    puts "User #{current_user.email} has unsubscribed from the chat channel"
  end

  def appear(data)
    puts "User #{current_user.email} has appeared in the chat channel"
  end

  def away
    puts "User #{current_user.email} has gone away in the chat channel"
  end

  def send_message(data)
    stream_from "data_channel"
  end
end
