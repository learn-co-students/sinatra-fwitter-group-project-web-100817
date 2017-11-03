class User < ActiveRecord::Base
  has_many :tweets
  include BCrypt

  def password=(new_password)
   password = Password.create(new_password)
   self.password_hash = password
  end

  def password
    Password.new(password_hash)
  end

  def authenticate(word)
    return self if self.password == word
    false
  end

  def slug
    self.username.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.all.find {|user| user.slug == slug}
  end

end
