class SimpleUser < User

  public
  
  def self.authenticate(email, password)
    user = SimpleUser.first(:conditions => ['primary_email = ?', email])
    if user.blank? || Digest::SHA256.hexdigest(password + user.password_salt) != user.password_hash
      raise SecurityError, "Email or password invalid"
    end
    user
  end
  
  def password
    self.password_hash
  end
  
  def password=(pass)
    if pass.blank? or pass.size < 4
      self.errors.add("password", "must be at least 4 characters long")
      raise ActiveRecord::RecordInvalid.new(self)
    else
      salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
      self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
    end
  end
end