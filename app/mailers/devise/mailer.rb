# frozen_string_literal: true

if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts = {})
      @smtp_service = SendPulse::SmtpService.new(ENV['SENDPULSE_CLIENT_ID'], ENV['SENDPULSE_CLIENT_SECRET'], 'https', nil)

      @token = token

      default_url_options[:host] = Rails.env.development? ? 'localhost:3000' : 'http://46.101.202.118'

      @resource = record
      # send email to consumer
      email = {
        html: render_to_string(:partial => 'consumers/mailer/reset_password_instructions'),
        text: 'Text',
        subject: 'Відновлення паролю на сайті провайдера ZizenCom',
        from: {
          name: 'ZizenCom',
          email: 'zyzen.vasyl@student.uzhnu.edu.ua'
        },
        to: [
          {
            email: @resource.email
          }
        ]
      }

      @smtp_service.send_email(email)
    end

    def unlock_instructions(record, token, opts = {})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
    end

    def email_changed(record, opts = {})
      devise_mail(record, :email_changed, opts)
    end

    def password_change(record, opts = {})
      devise_mail(record, :password_change, opts)
    end
  end
end