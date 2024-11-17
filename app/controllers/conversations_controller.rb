class ConversationsController < ApplicationController
  before_action :authorization_middleware

  def show
    conversations = current_user.conversations
    render json: conversations
  end

  def create
    current_user
    conversation_name = params[:conversation_name]
    participants = params[:participants]
    conversation = Conversation.create(conversation_uuid: SecureRandom.uuid, name: conversation_name)
    conversation.conversation_participants.create(user_id: current_user.id)

    participants.each do |participant|
      user = User.find_by(username: participant)
      if user and user.id != current_user.id
        conversation.conversation_participants.create(user_id: user.id)
      end
    end

    if conversation.save
      render json: conversation
    else
      render json: { error: conversation.errors.full_messages }, status: :bad_request
    end
  end
end
