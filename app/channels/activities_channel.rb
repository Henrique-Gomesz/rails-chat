class ActivitiesChannel < ApplicationCable::Channel
  def subscribed
    Logger.new(STDOUT).info "User #{current_user.email} has subscribed to the Activities channel"
    stream_from "Activities_#{current_user.username}"
  end
end
