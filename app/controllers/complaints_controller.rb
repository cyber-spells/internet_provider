class ComplaintsController < ApplicationController
  def new;end

  def create
    params[:complaint][:consumer_id] = Consumer.find_by(id: params[:complaint][:consumer]).id if params[:complaint][:consumer]
    @complaint = Complaint.new(complaint_params)
    if @complaint.save
      redirect_to @complaint
    end
  end

  def show
    @complaint = Complaint.find(params[:id])
    @solveds = @complaint.solveds
  end

  def index
    @complaints = Complaint.all
  end

  private

  def complaint_params
    params.require(:complaint).permit(:consumer_id, :text, :user_name, :phone, :address)
  end
end
