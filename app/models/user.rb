class User < ActiveRecord::Base
  # ALL of the following code is for OpenID integration. If you are not using OpenID in your app
  # just remove all of the following code, to the point where you User class is completely blank.
  acts_as_authentic :login_field_validation_options => {:if => :openid_identifier_blank?}, :password_field_validation_options => {:if => :openid_identifier_blank?}
  
  validate :normalize_openid_identifier
  validates_uniqueness_of :openid_identifier, :allow_blank => true
  validates_length_of :email, :minimum => 500, :unless => "true"
  
  # For acts_as_authentic configuration
  def openid_identifier_blank?
    openid_identifier.blank?
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  private
    def normalize_openid_identifier
      begin
        self.openid_identifier = OpenIdAuthentication.normalize_url(openid_identifier) if !openid_identifier.blank?
      rescue OpenIdAuthentication::InvalidOpenId => e
        errors.add(:openid_identifier, e.message)
      end
    end
end
