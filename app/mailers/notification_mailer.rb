class NotificationMailer < ApplicationMailer

  def job_failed(messenger, exception)
    @exception = exception
    mail(to: 'admin@example.com', subject: "#{messenger} Exception")
  end
end
