class Complaint < ApplicationRecord
  belongs_to :consumer, optional: true
  belongs_to :employee, optional: true
  has_one :solved
  has_many :solveds

  after_create :update_consumer

  enum state: {
    open: 0,
    in_process: 1,
    close_consumer: 2,
    close_without_resolved: 3,
    resolved: 4
  }

  states.each do |state, value|
    scope state.pluralize.to_sym, -> {where(state: value)}
  end

  def name
    "#{id}"
  end

  private

  def update_consumer
    return unless consumer
    consumer.update(
      phone: (consumer.phone || phone),
      address: (consumer.address || address),
      user_name: (consumer.user_name || user_name),
    )
  end
end
