class User < ActiveRecord::Base
  include BCrypt
  has_many :tweets

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def password
    @password ||= Password.new(password_digest)
  end

  def slug
    self.username.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.find_by(username: slug.gsub("-", " "))
  end

  def authenticate(string)
    if self.password == string
      self
    else
      false
    end
  end

end