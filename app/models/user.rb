class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def deliver_password_reset_instructions!
    reset_password_reset_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end
