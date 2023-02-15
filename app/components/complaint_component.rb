# frozen_string_literal: true

class ComplaintComponent < ViewComponent::Base
  def initialize(complaint:)
    @complaint = complaint
  end
end
