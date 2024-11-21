class MessagesController < ApplicationController
  before_action :authorization_middleware

  def create
    conversation = current_user.conversations.find_by(conversation_uuid: params[:conversation_uuid])
    if conversation
      message = conversation.messages.create(user_id: current_user.id, message: params[:message])
      if message.save
        broadcast_new_message(conversation, message)
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

  private
    def broadcast_new_message(conversation, newMessage)
      participants = conversation.conversation_participants

      body = {
        conversation_uuid: conversation.conversation_uuid,
        message: newMessage.message,
        author: newMessage.user.username,
        created_at: newMessage.created_at,
        updated_at: newMessage.updated_at
      }

      participants.each do |participant|
        if participant.user.id != current_user.id
          ActionCable.server.broadcast("Activities_#{participant.user.username}", { action: "new_message", body: body })
        end
      end
    end
end
