class Notifier < ActionMailer::Base
  default_url_options[:host] = "authlogic_example.binarylogic.com"
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Binary Logic Notifier <noreply@binarylogic.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_url => edit_password_account_url(:password_reset_token => user.password_reset_token)
  end
end