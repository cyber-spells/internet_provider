# frozen_string_literal: true

class ConsumerNotificationComponent < ViewComponent::Base
  def initialize(consumer_notification:)
    @notification = consumer_notification

    @viewed = consumer_notification.viewed?
  end
end
