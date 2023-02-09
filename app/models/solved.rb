class Solved < ApplicationRecord
  belongs_to :employee
  belongs_to :complaint

  after_create :close_complaint

  private

  def close_complaint
    complaint.update(
      state: Complaint.states[:resolved],
      employee: employee,
    )
  end
end
