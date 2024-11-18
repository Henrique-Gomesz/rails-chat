class MessagesController < ApplicationController
  before_action :authorization_middleware

  def create
    conversation = current_user.conversations.find_by(conversation_uuid: params[:conversation_uuid])
    if conversation
      message = conversation.messages.create(user_id: current_user.id, message: params[:message])
      if message.save
        ActionCable.server.broadcast("Chat_#{conversation.conversation_uuid}", { action: "new_message", body: "A new message from a conversation" })
        render json: message
      else
        render json: { error: message.errors.full_messages }, status: :bad_request
      end
    else
      render json: { error: "Conversation not found" }, status: :not_found
    end
  end

  def show
    conversation = current_user.conversations.find_by(conversation_uuid: params[:conversation_uuid])
    if conversation
      render json: conversation.messages, include: { user: { only: [ :username ] } }
    else
      render json: { error: "Conversation not found" }, status: :not_found
    end
  end
end
