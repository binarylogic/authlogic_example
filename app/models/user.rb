class User < ActiveRecord::Base
  acts_as_authentic
  
  def deliver_password_reset_instructions!
    reset_password_reset_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
