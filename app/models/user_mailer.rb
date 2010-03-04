class UserMailer < ActionMailer::Base
  def contact(recipient, subject, message, from, sent_at = Time.now)
     @subject = subject
     @recipients = recipient
     @from = 'no-reply@linguar.com'
     @sent_on = sent_at
     @body["title"] = 'This is title'
     @body["email"] = from
     @body["message"] = message
  end
end
