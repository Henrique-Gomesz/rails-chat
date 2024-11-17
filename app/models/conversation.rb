class Conversation < ApplicationRecord
  has_many :conversation_participants
  has_many :users, through: :conversation_participants
  has_many :messages

  validates :conversation_uuid, uniqueness: true
end
