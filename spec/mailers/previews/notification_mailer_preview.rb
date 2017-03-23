# Preview all emails at http://127.0.0.1:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://127.0.0.1:3000/rails/mailers/notification_mailer/job_failed
  def job_failed
    NotificationMailer.job_failed "Viber", "Exception text"
  end

end
