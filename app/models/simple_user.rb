class SimpleUser < User

  validates_presence_of :password
  
  def self.authenticate(email, password)
    user = User.first(:conditions => ['primary_email = ?', email])
    if user.blank? || Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash
      raise SecurityError, "Email or password invalid"
    end
    user
  end
  
  def password
    self.password_hash
  end
  
  def password=(pass)
    return if pass.blank?
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
end