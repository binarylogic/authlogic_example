class User < ActiveRecord::Base
  acts_as_authentic :allow_blank_login_and_password_fields => true
  
  validates_presence_of :login, :if => Proc.new { |user| user.openid_identifier.blank? }
  validates_presence_of :password, :if => Proc.new { |user| user.openid_identifier.blank? }
  validate :normalize_openid_identifier
  validates_uniqueness_of :openid_identifier, :allow_blank => true
  
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
