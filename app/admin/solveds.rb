ActiveAdmin.register Solved do
  belongs_to :complaint
  menu false

  permit_params :text, :complaint_id, :employee_id

  # actions :new,:create,:show

  # permit_params do
  #   permitted = [:text, :complaint_id, :employee_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form partial: "form"

  controller do
    def create
      @solved = Solved.new(permitted_params[:solved])
      @solved.complaint = Complaint.find(params[:complaint_id])
      @solved.employee = current_employee
      consumer = @solved.complaint.consumer
      if @solved.save

        # send email to consumer

        # send email to consumer with comment from admin
        email = {
          html: render_to_string(:partial => 'admin/solveds/resolved', :locals => { consumer: consumer, solved: @solved }),
          text: 'Text',
          subject: 'Відповідь на скаргу на сайті провайдера SunCom',
          from: {
            name: 'SunCom',
            email: 'zyzen.vasyl@student.uzhnu.edu.ua'
          },
          to: [
            {
              email: consumer.email
            }
          ]
        }

        @smtp_service.send_email(email)

        # Create new notification for consumer
        ConsumerNotification.create(consumer: consumer, title: "Відповідь на скаргу",
                                    body: "Ви отримали відповідь на скаргу з ID:#{@solved.id}. Перегляньте деталі на вкладці скарг.")

        redirect_to admin_complaint_path(@solved.complaint)
      else
        render :new
      end
    end
  end
end
