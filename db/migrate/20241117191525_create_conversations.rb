class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.string :conversation_uuid
      t.string :name

      t.timestamps
    end
  end
end