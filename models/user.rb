# require 'bcrypt'
class User < ActiveRecord::Base
  # include BCrypt

  has_many  :tweets

  def slug
    "#{self.username.gsub(/ /, "-")}"
  end

  def self.find_by_slug(slug)
    self.find_by(username: slug.gsub(/-/, " "))
  end

  def authenticate(check_password)
      password == check_password ? self : false
    end
    # private
  def password
    BCrypt::Password.new(password_digest)
  end

  def password=(new_password)
    password = BCrypt::Password.create(new_password)
    self.password_digest = password
  end
end
