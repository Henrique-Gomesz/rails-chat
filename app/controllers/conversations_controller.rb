class ConversationsController < ApplicationController
  before_action :authorization_middleware

  def show
    conversations = current_user.conversations
    render json: conversations, include: { conversation_participants: { include: { user: { only: :username } }, only: :user }, messages: { include: { user: { only: :username } },  only: [ :message, :created_at ] } }
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
      broadcast_new_chat(participants, conversation)
      render json: conversation, include: { conversation_participants: { include: { user: { only: :username } }, only: :user } }
    else
      render json: { error: conversation.errors.full_messages }, status: :bad_request
    end
  end

  private
    def broadcast_new_chat(participants, conversation)
        conversation_data = conversation.as_json(
        include: {
          conversation_participants: {
            include: {
              user: { only: :username }
            },
            only: :user
          }
        }
      )
      participants.each do |participant|
        user = User.find_by(username: participant)
        if user and user.id != current_user.id
          ActionCable.server.broadcast("Activities_#{user.username}", { action: "new_conversation", body: conversation_data })
        end
      end
    end
end
