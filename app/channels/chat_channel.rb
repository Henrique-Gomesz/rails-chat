class ChatChannel < ApplicationCable::Channel
  def subscribed
    # PEGAR USERNAME DO DESTINATÁRIO
    # BUSCAR NA TABELA DE CONVERSAS E PEGAR O ID DA CONVERSA
    # stream_from "chat_channel_#{conversation_id}"
    stream_from ""
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
