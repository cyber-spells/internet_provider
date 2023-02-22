class ComplaintsController < ApplicationController
  before_action :authenticate_consumer!
  # def new;end

  def create
    params[:complaint][:consumer_id] = Consumer.find_by(id: params[:complaint][:consumer]).id if params[:complaint][:consumer]
    @complaint = Complaint.new(complaint_params)
    if @complaint.save
      redirect_to root_path
    end
  end

  def get_complaint
    @complaint = Complaint.find(params[:id])
    @solveds = @complaint.solveds
    respond_to do |format|
      format.js {}
    end
  end

  private

  def complaint_params
    params.require(:complaint).permit(:consumer_id, :text, :user_name, :phone, :address)
  end
end
