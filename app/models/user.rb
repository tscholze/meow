require 'digest/sha1'

class User < ActiveRecord::Base

  attr_accessor :password, :password_confirmation
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :login

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def password=(pass)
    @password=pass
    if !@password.empty? then
      self.salt = User.random_string(10) if !self.salt?
      self.hashed_password = User.encrypt(@password, self.salt)
    end
  end

  def self.authenticate(login, pass)
    u = where(:login => login).first
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end

end
