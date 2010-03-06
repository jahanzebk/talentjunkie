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
  
  def reset_password
    new_password = generate_random_password
    self.password = new_password
    self.save
    new_password
  end
  
  private
  
  def generate_random_password(size=8)
    (1..size).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join
  end
end